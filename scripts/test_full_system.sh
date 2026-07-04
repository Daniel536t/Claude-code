#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing Full System ==="
echo ""

echo "1️⃣ Testing FCC + NVIDIA NIM (Claude Code):"
fcc-claude -p "What model are you?" 2>/dev/null | head -3

echo ""
echo "2️⃣ Testing llm.py with fallback chain:"
python3 ~/llm.py "What model are you using?" 2>&1 | grep -E "(🔄|📝|Response)" | head -10

echo ""
echo "3️⃣ Testing llm.py fast mode:"
python3 ~/llm.py "Say OK" --fast 2>/dev/null

echo ""
echo "4️⃣ Testing specific providers:"
echo "  - Using NVIDIA Kimi: python3 ~/llm.py 'Hello' --fast"
echo "  - Using fallback chain: python3 ~/llm.py 'Hello'"
echo "  - Interactive: python3 -i -c 'from llm import llm; asyncio.run(llm(user=\"Hello\"))'"
