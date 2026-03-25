#!/usr/bin/env bash
# Batch explicit skill request test runner
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
    "superplanning-please"
    "use-superplanning"
    "product-plan-via-skill"
    "brainstorm-via-skill"
    "feature-plan-via-skill"
)
LABELS=(
    "User asks for superplanning directly"
    "User says 'use superplanning'"
    "User asks for skill by name for product plan"
    "User asks for skill by name for brainstorm"
    "User asks for skill by name for feature plan"
)

echo "=== Explicit Skill Request Tests: superplanning ==="
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
            > "/tmp/superplanning-explicit-${stem}.log" 2>&1
        result=$?
        if [ $result -ne 0 ]; then
            cat "/tmp/superplanning-explicit-${stem}.log"
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
