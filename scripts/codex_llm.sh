#!/bin/bash
# Use Codex through FCC with fallback to llm.py if Codex fails

echo "=== Using Codex (via FCC) ==="
echo ""

PROMPT="$@"

if [ -z "$PROMPT" ]; then
    echo "Usage: ~/codex_llm.sh 'Your prompt here'"
    exit 1
fi

echo "📌 Trying Codex via FCC..."
response=$(fcc-codex exec "$PROMPT" 2>/dev/null)

if [ -n "$response" ]; then
    echo "✅ Codex response:"
    echo "$response"
else
    echo "⚠️  Codex failed, falling back to llm.py..."
    ~/llm_launch.sh "$PROMPT" --fast
fi
