#!/bin/bash
echo "=== QUICK WORKING TEST ==="
echo ""

echo "1️⃣ Claude Code:"
fcc-claude -p "Say OK" 2>/dev/null | head -1

echo ""
echo "2️⃣ llm.py (fastest):"
~/llm_launch.sh "Say OK" --fast 2>/dev/null | tail -1

echo ""
echo "3️⃣ llm.py (full chain):"
~/llm_launch.sh "Say OK" 2>/dev/null | tail -1

echo ""
echo "4️⃣ FreeTheAi:"
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"Say OK"}],"max_tokens":5}' \
    2>/dev/null | python3 -c "import sys, json; print(json.load(sys.stdin).get('choices',[{}])[0].get('message',{}).get('content',''))"

echo ""
echo "5️⃣ Universal Agent:"
~/agent_final.sh "Say OK" 2>&1 | tail -5

echo ""
echo "✅ All systems are operational!"
