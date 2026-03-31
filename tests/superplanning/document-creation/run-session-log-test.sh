#!/usr/bin/env bash
# Integration test: every session writes a Q&A log to docs/sessions/
# Creates a temp git repo, runs Claude through a brainstorm, verifies the log was created.
# Usage: ./run-session-log-test.sh [max-turns]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_FILE="$SCRIPT_DIR/prompts/session-log-created.txt"
MAX_TURNS="${1:-35}"
TIMEOUT=600

# Create a temp project dir with a git repo
TMPDIR_PROJECT=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PROJECT"' EXIT

cd "$TMPDIR_PROJECT"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

echo "=== Document Creation Test: Session Q&A Log ==="
echo "Checks that: docs/sessions/<date-slug>.md is created inside the project"
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
echo "=== Checking for session Q&A log ==="
echo ""

PASS_COUNT=0
FAIL_COUNT=0

check_pass() { echo "  PASS: $1"; PASS_COUNT=$((PASS_COUNT + 1)); }
check_fail() { echo "  FAIL: $1"; FAIL_COUNT=$((FAIL_COUNT + 1)); }

# Check 1: docs/sessions/ directory was created
if [ -d "$TMPDIR_PROJECT/docs/sessions" ]; then
    check_pass "docs/sessions/ directory was created in the project root"
else
    check_fail "docs/sessions/ was NOT created (found in docs/: $(ls "$TMPDIR_PROJECT/docs" 2>/dev/null || echo 'docs/ missing'))"
fi

# Check 2: at least one .md file was created in docs/sessions/
MD_FILES=$(find "$TMPDIR_PROJECT/docs/sessions" -name "*.md" 2>/dev/null || true)
if [ -n "$MD_FILES" ]; then
    check_pass "session Q&A log was written: $(echo "$MD_FILES" | xargs -n1 basename | tr '\n' ' ')"
else
    check_fail "no .md file found in docs/sessions/"
fi

# Check 3: file is inside the project directory
if [ -n "$MD_FILES" ]; then
    FIRST_FILE=$(echo "$MD_FILES" | head -1)
    if [[ "$FIRST_FILE" == "$TMPDIR_PROJECT"* ]]; then
        check_pass "session log is inside the project directory (not written to a global path)"
    else
        check_fail "session log was written outside the project: $FIRST_FILE"
    fi
fi

# Check 4: document contains expected Q&A log structure
if [ -n "$MD_FILES" ]; then
    FIRST_FILE=$(echo "$MD_FILES" | head -1)
    if grep -qi "Phase\|Q:\|User:\|AI position\|question\|answer\|decision" "$FIRST_FILE"; then
        check_pass "document contains expected Q&A log structure"
    else
        check_fail "document does not have expected structure (missing Phase headers, Q:, User:, AI position, or decision table)"
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
