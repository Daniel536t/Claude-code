#!/bin/bash
echo "╔══════════════════════════════════════════╗"
echo "║   Comparing Claude Code vs Codex       ║"
echo "╚══════════════════════════════════════════╝"
echo ""

PROMPT="Write a Python function that adds two numbers"

echo "📌 Prompt: $PROMPT"
echo ""

echo "1️⃣ Claude Code (via FCC):"
echo "---"
fcc-claude -p "$PROMPT" 2>/dev/null | head -15
echo "---"
echo ""

echo "2️⃣ Codex (via FCC):"
echo "---"
fcc-codex exec "$PROMPT" 2>/dev/null | head -15
echo "---"
echo ""

echo "3️⃣ llm.py (Full fallback chain):"
echo "---"
~/llm_launch.sh "$PROMPT" --fast 2>/dev/null | tail -10
echo "---"
