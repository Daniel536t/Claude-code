#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing Codex with Real Tasks ==="
echo ""

echo "1️⃣ Codex - Simple hello:"
~/codex_work.sh exec "Say hello in one word" 2>&1 | head -5

echo ""
echo "2️⃣ Codex - Code generation:"
~/codex_work.sh exec "Write a Python function that adds two numbers" 2>&1 | head -10

echo ""
echo "3️⃣ Codex - Explanation:"
~/codex_work.sh exec "Explain what a variable is in 3 sentences" 2>&1 | head -5
