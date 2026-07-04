#!/bin/bash
# Universal agent with proper timeout handling

PROMPT="$@"

if [ -z "$PROMPT" ]; then
    echo "Usage: ~/agent_fixed_timeout.sh 'Your prompt here'"
    exit 1
fi

echo "🤖 Trying agents in order..."

# Try Claude Code (with longer timeout)
echo -n "  1️⃣ Claude Code: "
response=$(timeout 30 fcc-claude -p "$PROMPT" 2>/dev/null)
if [ -n "$response" ] && [[ "$response" != *"error"* ]] && [[ "$response" != *"failed"* ]]; then
    echo "✅ Success!"
    echo ""
    echo "$response"
    exit 0
else
    echo "❌ Failed (timeout or error)"
fi

# Try Codex
echo -n "  2️⃣ Codex: "
response=$(timeout 30 ~/codex_work.sh exec "$PROMPT" 2>/dev/null)
if [ -n "$response" ] && [[ "$response" != *"error"* ]]; then
    echo "✅ Success!"
    echo ""
    echo "$response"
    exit 0
else
    echo "❌ Failed"
fi

# Try llm.py
echo -n "  3️⃣ llm.py: "
response=$(timeout 30 ~/llm_launch.sh "$PROMPT" --fast 2>/dev/null)
if [ -n "$response" ] && [[ "$response" != *"Error"* ]]; then
    echo "✅ Success!"
    echo ""
    echo "$response"
    exit 0
else
    echo "❌ Failed"
fi

echo ""
echo "❌ All agents failed!"
exit 1
