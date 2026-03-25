#!/usr/bin/env bash
# Test explicit skill requests — user names the skill directly
# Verifies Skill tool fires BEFORE any action tools (Read, Write, Bash, etc.)
# Usage: ./run-test.sh <skill-name> <prompt-file> [max-turns]
set -e

SKILL_NAME="$1"
PROMPT_FILE="$2"
MAX_TURNS="${3:-3}"

if [ -z "$SKILL_NAME" ] || [ -z "$PROMPT_FILE" ]; then
    echo "Usage: $0 <skill-name> <prompt-file> [max-turns]"
    echo "Example: $0 superplanning prompts/superplanning-please.txt"
    exit 1
fi

# PLUGIN_DIR = project root (three levels up from tests/superplanning/explicit-skill-requests/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

TIMESTAMP=$(date +%s)
OUTPUT_DIR="/tmp/superplanning-tests/${TIMESTAMP}/explicit-skill-requests/${SKILL_NAME}"
mkdir -p "$OUTPUT_DIR"

PROMPT=$(cat "$PROMPT_FILE")
cp "$PROMPT_FILE" "$OUTPUT_DIR/prompt.txt"

# Create a minimal project context so the resume-check in Phase 0 has something to scan
PROJECT_DIR="$OUTPUT_DIR/project"
mkdir -p "$PROJECT_DIR/docs/brainstorms"
mkdir -p "$PROJECT_DIR/docs/plans"
mkdir -p "$PROJECT_DIR/docs/product"

cat > "$PROJECT_DIR/docs/plans/example-plan.md" << 'EOF'
# Example prior plan (for context only)

## Unit 1: Add user model
Create user model with email and name fields.
EOF

echo "=== Explicit Skill Request Test ==="
echo "Skill:       $SKILL_NAME"
echo "Prompt file: $PROMPT_FILE"
echo "Max turns:   $MAX_TURNS"
echo "Plugin dir:  $PLUGIN_DIR"
echo "Output dir:  $OUTPUT_DIR"
echo ""

LOG_FILE="$OUTPUT_DIR/claude-output.json"
cd "$PROJECT_DIR"

echo "Running claude -p ..."
timeout 300 claude -p "$PROMPT" \
    --plugin-dir "$PLUGIN_DIR" \
    --dangerously-skip-permissions \
    --max-turns "$MAX_TURNS" \
    --output-format stream-json \
    > "$LOG_FILE" 2>&1 || true

echo ""
echo "=== Results ==="

SKILL_PATTERN='"skill":"([^"]*:)?'"${SKILL_NAME}"'"'
if grep -q '"name":"Skill"' "$LOG_FILE" && grep -qE "$SKILL_PATTERN" "$LOG_FILE"; then
    echo "PASS: Skill '$SKILL_NAME' was triggered"
    TRIGGERED=true
else
    echo "FAIL: Skill '$SKILL_NAME' was NOT triggered"
    TRIGGERED=false
fi

echo ""
echo "Skills triggered in this run:"
grep -o '"skill":"[^"]*"' "$LOG_FILE" 2>/dev/null | sort -u || echo "  (none)"

# Premature action detection
echo ""
echo "Checking for premature action before Skill invocation..."
FIRST_SKILL_LINE=$(grep -n '"name":"Skill"' "$LOG_FILE" 2>/dev/null | head -1 | cut -d: -f1)
if [ -n "$FIRST_SKILL_LINE" ]; then
    PREMATURE=$(head -n "$FIRST_SKILL_LINE" "$LOG_FILE" \
        | grep '"type":"tool_use"' \
        | grep -v '"name":"Skill"' \
        | grep -v '"name":"TodoWrite"' \
        || true)
    if [ -n "$PREMATURE" ]; then
        echo "WARNING: Action tools invoked BEFORE Skill:"
        echo "$PREMATURE" | head -5
    else
        echo "OK: No premature tool invocations"
    fi
else
    echo "WARNING: No Skill invocation found"
fi

echo ""
echo "Full log: $LOG_FILE"

if [ "$TRIGGERED" = "true" ]; then
    exit 0
else
    exit 1
fi
