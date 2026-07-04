#!/bin/bash
# Codex alternative using llm.py

PROMPT="$@"

if [ -z "$PROMPT" ]; then
    echo "Usage: ~/codex_alt.sh 'Your prompt here'"
    exit 1
fi

echo "📌 Using llm.py as Codex alternative..."
~/llm_launch.sh "$PROMPT" --fast 2>/dev/null | tail -5
