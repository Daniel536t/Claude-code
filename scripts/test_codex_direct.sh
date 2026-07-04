#!/bin/bash
echo "=== Testing Codex Without FCC ==="

# Try Codex with OpenAI (if you have a key)
# For now, just test basic functionality
echo "1️⃣ Codex help:"
codex --help 2>&1 | head -10

echo ""
echo "2️⃣ Codex version:"
codex --version

echo ""
echo "3️⃣ Codex exec help:"
codex exec --help 2>&1 | head -10

echo ""
echo "4️⃣ Check if Codex can run:"
echo "Say OK" | timeout 5 codex exec 2>&1 | head -5
