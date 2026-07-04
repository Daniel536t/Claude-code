#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   FINAL WORKING TEST                   ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "1️⃣ FCC (Claude Code CLI):"
fcc-claude -p "Say OK" 2>/dev/null | head -1

echo ""
echo "2️⃣ llm.py fast mode:"
~/llm_launch.sh "Say OK" --fast 2>/dev/null | tail -1

echo ""
echo "3️⃣ llm.py full fallback:"
~/llm_launch.sh "Say OK" 2>&1 | tail -1

echo ""
echo "4️⃣ FreeTheAi direct:"
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"Say OK"}],"max_tokens":5}' \
    2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content','No response'))"

echo ""
echo "✅ All done!"
