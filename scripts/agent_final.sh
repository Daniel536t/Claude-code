#!/bin/bash
# Universal agent - tries Claude Code, then Codex, then llm.py

PROMPT="$@"

if [ -z "$PROMPT" ]; then
    echo "Usage: ~/agent_final.sh 'Your prompt here'"
    exit 1
fi

echo "🤖 Trying agents in order..."

# Try Claude Code
echo -n "  1️⃣ Claude Code: "
response=$(timeout 10 fcc-claude -p "$PROMPT" 2>/dev/null)
if [ -n "$response" ] && [[ "$response" != *"error"* ]]; then
    echo "✅ Success!"
    echo ""
    echo "$response"
    exit 0
else
    echo "❌ Failed"
fi

# Try Codex
echo -n "  2️⃣ Codex: "
response=$(timeout 10 ~/codex_work.sh exec "$PROMPT" 2>/dev/null)
if [ -n "$response" ]; then
    echo "✅ Success!"
    echo ""
    echo "$response"
    exit 0
else
    echo "❌ Failed"
fi

# Try llm.py
echo -n "  3️⃣ llm.py: "
response=$(timeout 10 ~/llm_launch.sh "$PROMPT" --fast 2>/dev/null)
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
