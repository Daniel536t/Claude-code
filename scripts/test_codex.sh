#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   Testing Codex with FCC               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "1️⃣ Testing Codex with Kimi K2.6 (fastest):"
fcc-codex exec "Say OK in one word" 2>/dev/null | head -3

echo ""
echo "2️⃣ Testing Codex with Nemotron:"
~/switch.sh nemotron > /dev/null 2>&1
sleep 2
fcc-codex exec "Say OK in one word" 2>/dev/null | head -3

echo ""
echo "3️⃣ Testing Codex with DeepSeek V4:"
~/switch.sh deepseek > /dev/null 2>&1
sleep 2
fcc-codex exec "Say OK in one word" 2>/dev/null | head -3

echo ""
echo "4️⃣ Switch back to fastest:"
~/switch.sh kimi > /dev/null 2>&1
echo "✅ Back to Kimi K2.6"

echo ""
echo "5️⃣ Test Codex with a real task:"
fcc-codex exec "Write a Python hello world function" 2>/dev/null | head -10
