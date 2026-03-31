#!/usr/bin/env bash
# Batch runner for document creation integration tests
# Tests that superplanning actually writes files to docs/ inside the project.
# Usage: ./run-all.sh [--verbose]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

echo "=== Document Creation Tests: superplanning ==="
echo "These tests create a real temp project, run Claude, and verify files land"
echo "in docs/ inside the project root — not in a global or absolute path."
echo ""

PASSED=0
FAILED=0
RESULTS=()

run_creation_test() {
    local label="$1"
    local script="$2"

    echo "Testing: $label"
    chmod +x "$script"

    set +e
    if [ "$VERBOSE" = true ]; then
        bash "$script"
        result=$?
    else
        LOG=$(bash "$script" 2>&1)
        result=$?
        if [ $result -ne 0 ]; then
            echo "$LOG"
        fi
    fi
    set -e

    if [ $result -eq 0 ]; then
        PASSED=$((PASSED + 1))
        RESULTS+=("  PASS: $label")
    else
        FAILED=$((FAILED + 1))
        RESULTS+=("  FAIL: $label")
    fi

    echo ""
    echo "---"
    echo ""
}

run_creation_test \
    "Brainstorm mode writes docs/brainstorms/<topic>.md into project root" \
    "$SCRIPT_DIR/run-brainstorm-test.sh"

run_creation_test \
    "New Product mode writes all 4 docs/product/ documents" \
    "$SCRIPT_DIR/run-new-product-test.sh"

run_creation_test \
    "Every session writes a Q&A log to docs/sessions/" \
    "$SCRIPT_DIR/run-session-log-test.sh"

echo ""
echo "=== Summary ==="
for r in "${RESULTS[@]}"; do
    echo "$r"
done
echo ""
echo "Passed: $PASSED"
echo "Failed: $FAILED"

if [ "$FAILED" -gt 0 ]; then
    exit 1
fi
