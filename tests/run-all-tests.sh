#!/usr/bin/env bash
# Master test runner — runs all three test layers for superplanning
# Usage: ./run-all-tests.sh [--unit-only] [--verbose]
#
# Layers:
#   1. Unit/behavior tests     (~5 min)  — fast, run during development
#   2. Skill triggering        (~30 min) — verifies naive prompts auto-invoke the skill
#   3. Explicit skill requests (~25 min) — verifies named invocation fires before actions
#   4. Document creation       (~10 min) — verifies files are written to project docs/ folder
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

UNIT_ONLY=false
VERBOSE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --unit-only)
            UNIT_ONLY=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [--unit-only] [--verbose]"
            echo ""
            echo "Options:"
            echo "  --unit-only    Run only unit/behavior tests (~5 min)"
            echo "  --verbose, -v  Show verbose output from each layer"
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
echo " Superplanning — Full Test Suite"
echo "========================================"
echo "Time: $(date)"
echo "Claude: $(claude --version 2>/dev/null || echo 'not found')"
if [ "$UNIT_ONLY" = true ]; then
    echo "Mode: unit tests only"
else
    echo "Mode: all layers (~70 min)"
fi
echo ""

LAYER_PASSED=0
LAYER_FAILED=0

run_layer() {
    local name="$1"
    local script="$2"
    local args="${3:-}"

    echo "========================================"
    echo " Layer: $name"
    echo "========================================"
    echo ""

    chmod +x "$script"

    set +e
    if [ "$VERBOSE" = true ]; then
        bash "$script" $args
    else
        bash "$script" $args
    fi
    result=$?
    set -e

    if [ $result -eq 0 ]; then
        echo ""
        echo "Layer PASSED: $name"
        LAYER_PASSED=$((LAYER_PASSED + 1))
    else
        echo ""
        echo "Layer FAILED: $name"
        LAYER_FAILED=$((LAYER_FAILED + 1))
    fi

    echo ""
}

# Layer 1: Unit tests (always run)
run_layer "Unit / Behavior Tests" \
    "$SCRIPT_DIR/superplanning/unit/run-skill-tests.sh" \
    "$([ "$VERBOSE" = true ] && echo '--verbose' || echo '')"

if [ "$UNIT_ONLY" = false ]; then
    # Layer 2: Skill triggering
    run_layer "Skill Triggering Tests" \
        "$SCRIPT_DIR/superplanning/skill-triggering/run-all.sh" \
        "$([ "$VERBOSE" = true ] && echo '--verbose' || echo '')"

    # Layer 3: Explicit skill requests
    run_layer "Explicit Skill Request Tests" \
        "$SCRIPT_DIR/superplanning/explicit-skill-requests/run-all.sh" \
        "$([ "$VERBOSE" = true ] && echo '--verbose' || echo '')"

    # Layer 4: Document creation (verifies files actually land on disk in project root)
    run_layer "Document Creation Tests" \
        "$SCRIPT_DIR/superplanning/document-creation/run-all.sh" \
        "$([ "$VERBOSE" = true ] && echo '--verbose' || echo '')"
fi

echo "========================================"
echo " Final Summary"
echo "========================================"
echo ""
echo "  Layers passed: $LAYER_PASSED"
echo "  Layers failed: $LAYER_FAILED"
echo ""

if [ "$UNIT_ONLY" = true ]; then
    echo "Note: Skill triggering and explicit request tests were not run."
    echo "Run without --unit-only for the full suite (~60 min)."
    echo ""
fi

if [ "$LAYER_FAILED" -gt 0 ]; then
    echo "STATUS: FAILED"
    exit 1
else
    echo "STATUS: PASSED"
    exit 0
fi
