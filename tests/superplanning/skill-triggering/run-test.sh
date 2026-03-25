#!/usr/bin/env bash
# Test skill triggering with naive prompts (no explicit skill mention)
# Usage: ./run-test.sh <skill-name> <prompt-file> [max-turns]
set -e

SKILL_NAME="$1"
PROMPT_FILE="$2"
MAX_TURNS="${3:-3}"

if [ -z "$SKILL_NAME" ] || [ -z "$PROMPT_FILE" ]; then
    echo "Usage: $0 <skill-name> <prompt-file> [max-turns]"
    echo "Example: $0 superplanning prompts/brainstorm-idea.txt"
    exit 1
fi

# PLUGIN_DIR = project root (three levels up from tests/superplanning/skill-triggering/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "$SCRIPT_DIR/../../.." && pwd)"

TIMESTAMP=$(date +%s)
OUTPUT_DIR="/tmp/superplanning-tests/${TIMESTAMP}/skill-triggering/${SKILL_NAME}"
mkdir -p "$OUTPUT_DIR"

PROMPT=$(cat "$PROMPT_FILE")
cp "$PROMPT_FILE" "$OUTPUT_DIR/prompt.txt"

echo "=== Skill Triggering Test ==="
echo "Skill:       $SKILL_NAME"
echo "Prompt file: $PROMPT_FILE"
echo "Max turns:   $MAX_TURNS"
echo "Plugin dir:  $PLUGIN_DIR"
echo "Output dir:  $OUTPUT_DIR"
echo ""

LOG_FILE="$OUTPUT_DIR/claude-output.json"

echo "Running claude -p ..."
timeout 300 claude -p "$PROMPT" \
    --plugin-dir "$PLUGIN_DIR" \
    --dangerously-skip-permissions \
    --max-turns "$MAX_TURNS" \
    --output-format stream-json \
    > "$LOG_FILE" 2>&1 || true

echo ""
echo "=== Results ==="

# Match "skill":"superplanning" or "skill":"namespace:superplanning"
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

echo ""
echo "First assistant response (truncated):"
grep '"type":"assistant"' "$LOG_FILE" 2>/dev/null | head -1 \
    | python3 -c "import sys,json; data=json.loads(sys.stdin.read()); \
      content=data.get('message',{}).get('content',[]); \
      text=next((c.get('text','') for c in content if isinstance(c,dict) and c.get('type')=='text'),''); \
      print(text[:500])" 2>/dev/null \
    || grep '"type":"assistant"' "$LOG_FILE" | head -1 | head -c 500

echo ""
echo "Full log: $LOG_FILE"

if [ "$TRIGGERED" = "true" ]; then
    exit 0
else
    exit 1
fi
