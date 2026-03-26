#!/usr/bin/env bash
# Integration test: New Product mode writes all 4 product docs to docs/product/
# Creates a temp git repo, runs Claude inside it, verifies all files were created.
# Usage: ./run-new-product-test.sh [max-turns]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"
PROMPT_FILE="$SCRIPT_DIR/prompts/new-product-creates-docs.txt"
MAX_TURNS="${1:-30}"
TIMEOUT=600

# Create a temp project dir with a git repo
TMPDIR_PROJECT=$(mktemp -d)
trap 'rm -rf "$TMPDIR_PROJECT"' EXIT

cd "$TMPDIR_PROJECT"
git init -q
git config user.email "test@example.com"
git config user.name "Test"

echo "=== Document Creation Test: New Product Mode ==="
echo "Checks that: docs/product/{mission,mvp-plan,roadmap,tech-stack}.md are created"
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

# Check 1: docs/product/ directory was created inside the project
if [ -d "$TMPDIR_PROJECT/docs/product" ]; then
    check_pass "docs/product/ directory was created in the project root"
else
    check_fail "docs/product/ directory was NOT created (found: $(ls "$TMPDIR_PROJECT" 2>/dev/null || echo 'nothing'))"
fi

# Check 2: mission.md exists with expected content
MISSION_FILE="$TMPDIR_PROJECT/docs/product/mission.md"
if [ -f "$MISSION_FILE" ]; then
    check_pass "docs/product/mission.md was created"
    if grep -qi "mission\|who we serve\|problem" "$MISSION_FILE"; then
        check_pass "mission.md contains expected structure"
    else
        check_fail "mission.md does not have expected structure"
        echo "  Content (first 10 lines):"; head -10 "$MISSION_FILE" | sed 's/^/    /'
    fi
else
    check_fail "docs/product/mission.md was NOT created"
fi

# Check 3: mvp-plan.md exists with expected content
MVP_FILE="$TMPDIR_PROJECT/docs/product/mvp-plan.md"
if [ -f "$MVP_FILE" ]; then
    check_pass "docs/product/mvp-plan.md was created"
    if grep -qi "mvp\|must have\|value proposition\|scope" "$MVP_FILE"; then
        check_pass "mvp-plan.md contains expected structure"
    else
        check_fail "mvp-plan.md does not have expected structure"
        echo "  Content (first 10 lines):"; head -10 "$MVP_FILE" | sed 's/^/    /'
    fi
else
    check_fail "docs/product/mvp-plan.md was NOT created"
fi

# Check 4: roadmap.md exists with expected content
ROADMAP_FILE="$TMPDIR_PROJECT/docs/product/roadmap.md"
if [ -f "$ROADMAP_FILE" ]; then
    check_pass "docs/product/roadmap.md was created"
    if grep -qi "roadmap\|phase\|goal\|exit criteria" "$ROADMAP_FILE"; then
        check_pass "roadmap.md contains expected structure"
    else
        check_fail "roadmap.md does not have expected structure"
        echo "  Content (first 10 lines):"; head -10 "$ROADMAP_FILE" | sed 's/^/    /'
    fi
else
    check_fail "docs/product/roadmap.md was NOT created"
fi

# Check 5: tech-stack.md exists with expected content
TECHSTACK_FILE="$TMPDIR_PROJECT/docs/product/tech-stack.md"
if [ -f "$TECHSTACK_FILE" ]; then
    check_pass "docs/product/tech-stack.md was created"
    if grep -qi "tech\|stack\|layer\|choice\|rationale" "$TECHSTACK_FILE"; then
        check_pass "tech-stack.md contains expected structure"
    else
        check_fail "tech-stack.md does not have expected structure"
        echo "  Content (first 10 lines):"; head -10 "$TECHSTACK_FILE" | sed 's/^/    /'
    fi
else
    check_fail "docs/product/tech-stack.md was NOT created"
fi

echo ""
echo "=== Results ==="
echo "  Passed: $PASS_COUNT"
echo "  Failed: $FAIL_COUNT"
echo ""

if [ "$FAIL_COUNT" -gt 0 ]; then
    echo "STATUS: FAILED"
    echo ""
    echo "Claude output (last 50 lines):"
    tail -50 "$LOG_FILE" | sed 's/^/  /'
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
