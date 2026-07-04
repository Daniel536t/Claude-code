#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   Testing Both Systems                 ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "1️⃣ Testing FCC (Claude Code CLI):"
echo "Prompt: 'Say OK in one word'"
response=$(fcc-claude -p "Say OK in one word" 2>/dev/null | head -3)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ FCC Working: $response"
else
    echo "❌ FCC Failed: $response"
fi

echo ""
echo "2️⃣ Testing llm.py (Full fallback chain):"
echo "Prompt: 'Say OK in one word'"
response=$(timeout 30 python3 ~/llm.py "Say OK in one word" 2>&1)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ llm.py Working: $response"
else
    echo "❌ llm.py Failed (may be timeout): $response"
fi

echo ""
echo "3️⃣ Testing llm.py fast mode:"
response=$(python3 ~/llm.py "Say OK" --fast 2>/dev/null)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Fast mode Working: $response"
else
    echo "❌ Fast mode Failed: $response"
fi

echo ""
echo "4️⃣ Current FCC config:"
grep "^MODEL=" ~/.fcc/.env
echo ""
echo "Proxy status:"
pgrep -f fcc-server && echo "✅ Running" || echo "❌ Stopped"
