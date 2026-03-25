#!/usr/bin/env bash
# Unit test orchestrator for superplanning skill behavior tests
# Usage: ./run-skill-tests.sh [--verbose] [--test NAME] [--timeout SECONDS]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

VERBOSE=false
SPECIFIC_TEST=""
TIMEOUT=300  # 5 min default per test file

while [[ $# -gt 0 ]]; do
    case $1 in
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --test|-t)
            SPECIFIC_TEST="$2"
            shift 2
            ;;
        --timeout)
            TIMEOUT="$2"
            shift 2
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --verbose, -v        Show verbose output"
            echo "  --test, -t NAME      Run only the specified test file"
            echo "  --timeout SECONDS    Set timeout per test file (default: 300)"
            echo "  --help, -h           Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found"
    exit 1
fi

echo "========================================"
echo " Superplanning Unit Tests"
echo "========================================"
echo "Repository: $(cd "$SCRIPT_DIR/../../.." && pwd)"
echo "Time: $(date)"
echo "Claude: $(claude --version 2>/dev/null || echo 'not found')"
echo ""

tests=("test-superplanning.sh")

if [ -n "$SPECIFIC_TEST" ]; then
    tests=("$SPECIFIC_TEST")
fi

passed=0
failed=0

for test in "${tests[@]}"; do
    test_path="$SCRIPT_DIR/$test"
    echo "----------------------------------------"
    echo "Running: $test"
    echo "----------------------------------------"

    if [ ! -f "$test_path" ]; then
        echo "  [SKIP] Not found: $test_path"
        continue
    fi

    chmod +x "$test_path"
    start=$(date +%s)

    if [ "$VERBOSE" = true ]; then
        if timeout "$TIMEOUT" bash "$test_path" --verbose; then
            duration=$(( $(date +%s) - start ))
            echo "  [PASS] $test (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            duration=$(( $(date +%s) - start ))
            [ $exit_code -eq 124 ] \
                && echo "  [FAIL] $test (timeout after ${TIMEOUT}s)" \
                || echo "  [FAIL] $test (${duration}s)"
            failed=$((failed + 1))
        fi
    else
        if output=$(timeout "$TIMEOUT" bash "$test_path" 2>&1); then
            duration=$(( $(date +%s) - start ))
            echo "  [PASS] (${duration}s)"
            passed=$((passed + 1))
        else
            exit_code=$?
            duration=$(( $(date +%s) - start ))
            [ $exit_code -eq 124 ] \
                && echo "  [FAIL] (timeout after ${TIMEOUT}s)" \
                || echo "  [FAIL] (${duration}s)"
            echo ""
            echo "$output" | sed 's/^/  /'
            failed=$((failed + 1))
        fi
    fi

    echo ""
done

echo "========================================"
echo " Summary"
echo "========================================"
echo "  Passed: $passed"
echo "  Failed: $failed"
echo ""

if [ "$failed" -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
