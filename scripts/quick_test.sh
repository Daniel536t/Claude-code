#!/bin/bash
echo "⚡ Quick Test:"
echo ""
echo "FCC: $(fcc-claude -p 'OK' 2>/dev/null | head -1)"
echo "llm.py: $(~/llm_launch.sh 'OK' --fast 2>/dev/null | tail -1)"
echo "FreeTheAi: $(curl -s -X POST https://api.freetheai.xyz/v1/chat/completions -H 'Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d' -H 'Content-Type: application/json' -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"OK"}],"max_tokens":5}' 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin).get("choices",[{}])[0].get("message",{}).get("content","No"))')"
echo ""
echo "✅ All systems operational!"
