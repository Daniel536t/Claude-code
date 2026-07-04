#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing Codex Simple ==="
echo ""

# Test 1: Basic prompt
echo "1️⃣ Basic prompt:"
~/codex_work.sh exec "Say OK" 2>&1 | head -5

echo ""
echo "2️⃣ Code generation:"
~/codex_work.sh exec "Write hello world in Python" 2>&1 | head -10

echo ""
echo "3️⃣ Question:"
~/codex_work.sh exec "What is 2+2?" 2>&1 | head -5
