#!/usr/bin/env bash
# Batch skill triggering test runner
# Usage: ./run-all.sh [--verbose]
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPTS_DIR="$SCRIPT_DIR/prompts"

VERBOSE=false
if [[ "${1:-}" == "--verbose" ]]; then
    VERBOSE=true
fi

# prompt file stems and matching labels (parallel arrays — bash 3 compatible)
STEMS=(
    "brainstorm-idea"
    "new-product-plan"
    "new-feature-plan"
    "help-think-through"
    "is-this-worth-building"
    "plan-from-scratch"
)
LABELS=(
    "Brainstorm mode (pure ideation)"
    "New product mode (explicit)"
    "New feature mode (existing codebase)"
    "Brainstorm mode (decision validation)"
    "Brainstorm mode (worth-it question)"
    "New product mode (alternative phrasing)"
)

echo "=== Skill Triggering Tests: superplanning ==="
echo ""

PASSED=0
FAILED=0
RESULTS=()

for i in "${!STEMS[@]}"; do
    stem="${STEMS[$i]}"
    label="${LABELS[$i]}"
    prompt_file="$PROMPTS_DIR/${stem}.txt"

    if [ ! -f "$prompt_file" ]; then
        echo "SKIP: No prompt file for '$stem'"
        continue
    fi

    echo "Testing: $label ($stem)"

    set +e
    if [ "$VERBOSE" = true ]; then
        "$SCRIPT_DIR/run-test.sh" superplanning "$prompt_file" 3
        result=$?
    else
        "$SCRIPT_DIR/run-test.sh" superplanning "$prompt_file" 3 \
            > "/tmp/superplanning-trigger-${stem}.log" 2>&1
        result=$?
        if [ $result -ne 0 ]; then
            cat "/tmp/superplanning-trigger-${stem}.log"
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
done

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
