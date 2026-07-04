#!/bin/bash
# Universal agent - tries Claude Code, then Codex, then llm.py

PROMPT="$@"

if [ -z "$PROMPT" ]; then
    echo "Usage: ~/agent.sh 'Your prompt here'"
    exit 1
fi

echo "🤖 Trying Claude Code..."
response=$(fcc-claude -p "$PROMPT" 2>/dev/null | head -10)
if [ -n "$response" ] && [ "$response" != "OK" ]; then
    echo "✅ Claude Code:"
    echo "$response"
    exit 0
fi

echo "⚠️  Claude Code failed, trying Codex..."
response=$(~/codex_work.sh exec "$PROMPT" 2>/dev/null | head -10)
if [ -n "$response" ]; then
    echo "✅ Codex:"
    echo "$response"
    exit 0
fi

echo "⚠️  Codex failed, trying llm.py..."
response=$(~/llm_launch.sh "$PROMPT" --fast 2>/dev/null | tail -10)
if [ -n "$response" ]; then
    echo "✅ llm.py:"
    echo "$response"
    exit 0
fi

echo "❌ All agents failed!"
exit 1
