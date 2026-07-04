#!/bin/bash
echo "=== Testing Claude Code ==="
echo ""

echo "1️⃣ Simple prompt:"
fcc-claude -p "Say OK in one word" 2>/dev/null | head -3

echo ""
echo "2️⃣ With model switch:"
~/switch.sh kimi > /dev/null 2>&1
sleep 2
fcc-claude -p "What model are you?" 2>/dev/null | head -3

echo ""
echo "3️⃣ Code generation:"
fcc-claude -p "Write a Python hello world" 2>/dev/null | head -10
