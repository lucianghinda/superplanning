#!/usr/bin/env bash
# Helper functions for superplanning skill unit tests

# Get the plugin root (project root, two levels above tests/superplanning/)
PLUGIN_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

# Run Claude Code with a prompt and capture output
# Usage: run_claude "prompt text" [timeout_seconds]
run_claude() {
    local prompt="$1"
    local timeout="${2:-120}"
    local max_turns="${3:-3}"
    local output_file
    output_file=$(mktemp)

    if timeout "$timeout" claude -p "$prompt" \
        --plugin-dir "$PLUGIN_DIR" \
        --dangerously-skip-permissions \
        --max-turns "$max_turns" \
        > "$output_file" 2>&1; then
        cat "$output_file"
        rm -f "$output_file"
        return 0
    else
        local exit_code=$?
        cat "$output_file" >&2
        rm -f "$output_file"
        return $exit_code
    fi
}

# Check if output contains a pattern
# Usage: assert_contains "output" "pattern" "test name"
assert_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -qi "$pattern"; then
        echo "  [PASS] $test_name"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /' | head -20
        return 1
    fi
}

# Check if output does NOT contain a pattern
# Usage: assert_not_contains "output" "pattern" "test name"
assert_not_contains() {
    local output="$1"
    local pattern="$2"
    local test_name="${3:-test}"

    if echo "$output" | grep -qi "$pattern"; then
        echo "  [FAIL] $test_name"
        echo "  Did not expect to find: $pattern"
        echo "  In output:"
        echo "$output" | sed 's/^/    /' | head -20
        return 1
    else
        echo "  [PASS] $test_name"
        return 0
    fi
}

# Check if pattern A appears before pattern B in the output
# Usage: assert_order "output" "pattern_a" "pattern_b" "test name"
assert_order() {
    local output="$1"
    local pattern_a="$2"
    local pattern_b="$3"
    local test_name="${4:-test}"

    local line_a
    local line_b
    line_a=$(echo "$output" | grep -ni "$pattern_a" | head -1 | cut -d: -f1)
    line_b=$(echo "$output" | grep -ni "$pattern_b" | head -1 | cut -d: -f1)

    if [ -z "$line_a" ]; then
        echo "  [FAIL] $test_name: pattern A not found: $pattern_a"
        return 1
    fi
    if [ -z "$line_b" ]; then
        echo "  [FAIL] $test_name: pattern B not found: $pattern_b"
        return 1
    fi

    if [ "$line_a" -lt "$line_b" ]; then
        echo "  [PASS] $test_name (A at line $line_a, B at line $line_b)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected '$pattern_a' before '$pattern_b'"
        echo "  But found A at line $line_a, B at line $line_b"
        return 1
    fi
}

# Check that output contains at least N of the given patterns (case-insensitive)
# Usage: assert_contains_at_least "output" N "test_name" "pat1" "pat2" ...
assert_contains_at_least() {
    local output="$1"
    local min_count="$2"
    local test_name="$3"
    shift 3
    local patterns=("$@")

    local found=0
    for pat in "${patterns[@]}"; do
        if echo "$output" | grep -qi "$pat"; then
            found=$((found + 1))
        fi
    done

    if [ "$found" -ge "$min_count" ]; then
        echo "  [PASS] $test_name (found $found of ${#patterns[@]} patterns)"
        return 0
    else
        echo "  [FAIL] $test_name"
        echo "  Expected at least $min_count matches; found $found"
        echo "  Patterns searched: ${patterns[*]}"
        return 1
    fi
}

export -f run_claude
export -f assert_contains
export -f assert_not_contains
export -f assert_order
export -f assert_contains_at_least
export PLUGIN_DIR
