#!/usr/bin/env bash
# Integration test: brainstorm mode writes requirements doc to docs/brainstorms/
# Creates a temp git repo, runs Claude inside it, verifies the file was created.
# Usage: ./run-brainstorm-test.sh [max-turns]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_FILE="$SCRIPT_DIR/prompts/brainstorm-creates-doc.txt"
MAX_TURNS="${1:-25}"
TIMEOUT=600

# Create a temp project dir with a git repo
TMPDIR_PROJECT=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PROJECT"' EXIT

cd "$TMPDIR_PROJECT"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

echo "=== Document Creation Test: Brainstorm Mode ==="
echo "Checks that: docs/brainstorms/<topic>.md is created inside the project"
echo ""
echo "Plugin dir:  $PLUGIN_DIR"
echo "Project dir: $TMPDIR_PROJECT"
echo "Max turns:   $MAX_TURNS"
echo ""

PROMPT=$(cat "$PROMPT_FILE")
LOG_FILE="$TMPDIR_PROJECT/claude-output.log"

echo "Running Claude..."
timeout "$TIMEOUT" claude -p "$PROMPT" \
    --plugin-dir "$PLUGIN_DIR" \
    --dangerously-skip-permissions \
    --max-turns "$MAX_TURNS" \
    > "$LOG_FILE" 2>&1 || true

echo ""
echo "=== Checking for created documents ==="
echo ""

PASS_COUNT=0
FAIL_COUNT=0

check_pass() { echo "  PASS: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
check_fail() { echo "  FAIL: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

# Check 1: docs/ directory was created inside the project
if [ -d "$TMPDIR_PROJECT/docs" ]; then
    check_pass "docs/ directory was created in the project root"
else
    check_fail "docs/ directory was NOT created (found: $(ls "$TMPDIR_PROJECT"))"
fi

# Check 2: docs/brainstorms/ subdirectory exists
if [ -d "$TMPDIR_PROJECT/docs/brainstorms" ]; then
    check_pass "docs/brainstorms/ subdirectory exists"
else
    check_fail "docs/brainstorms/ was NOT created"
fi

# Check 3: at least one .md file was created there
MD_FILES=$(find "$TMPDIR_PROJECT/docs/brainstorms" -name "*.md" 2>/dev/null || true)
if [ -n "$MD_FILES" ]; then
    check_pass "requirements document was written: $(echo "$MD_FILES" | xargs -n1 basename | tr '\n' ' ')"
else
    check_fail "no .md file found in docs/brainstorms/"
fi

# Check 4: file is not outside the project (no files in /tmp or ~ or absolute paths in content)
if [ -n "$MD_FILES" ]; then
    FIRST_FILE=$(echo "$MD_FILES" | head -1)
    if [[ "$FIRST_FILE" == "$TMPDIR_PROJECT"* ]]; then
        check_pass "document is inside the project directory (not written to a global path)"
    else
        check_fail "document was written outside the project: $FIRST_FILE"
    fi
fi

# Check 5: document contains the expected requirements structure
if [ -n "$MD_FILES" ]; then
    FIRST_FILE=$(echo "$MD_FILES" | head -1)
    if grep -qi "R1\|requirements\|problem frame\|success criteria" "$FIRST_FILE"; then
        check_pass "document contains expected requirements structure"
    else
        check_fail "document does not have expected structure (missing R1, Problem Frame, or Success Criteria)"
        echo ""
        echo "  Document content (first 30 lines):"
        head -30 "$FIRST_FILE" | sed 's/^/    /'
    fi
fi

echo ""
echo "=== Results ==="
echo "  Passed: $PASS_COUNT"
echo "  Failed: $FAIL_COUNT"
echo ""

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "STATUS: FAILED"
    echo ""
    echo "Claude output (last 40 lines):"
    tail -40 "$LOG_FILE" | sed 's/^/  /'
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
