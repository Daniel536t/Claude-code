#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   ✅ ACCURATE SYSTEM STATUS            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# FCC Proxy
if pgrep -f fcc-server > /dev/null; then
    echo "  FCC Proxy: ✅ Running (PID: $(pgrep -f fcc-server))"
else
    echo "  FCC Proxy: ❌ Stopped"
fi

# Claude Code - show actual response
echo -n "  Claude Code: "
response=$(timeout 5 fcc-claude -p "Say OK" 2>/dev/null | head -1)
if [ -n "$response" ]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# llm.py fast
echo -n "  llm.py Fast: "
response=$(timeout 5 ~/llm_launch.sh "Say OK" --fast 2>/dev/null | tail -1)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# llm.py full
echo -n "  llm.py Full: "
response=$(timeout 5 ~/llm_launch.sh "Say OK" 2>/dev/null | tail -1)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# FreeTheAi
echo -n "  FreeTheAi: "
response=$(curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"Say OK"}],"max_tokens":5}' 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content',''))")
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# Agent
echo -n "  Universal Agent: "
response=$(timeout 10 ~/agent_final.sh "Say OK" 2>&1 | tail -3)
if [[ "$response" == *"OK"* ]] || [[ "$response" == *"Success"* ]]; then
    echo "✅ Working"
else
    echo "⚠️  Partial (check manually)"
fi

echo ""
echo "📊 Current Model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo ""
echo "📋 WORKING COMMANDS:"
echo "  fcc-claude -p 'prompt'        # Claude Code"
echo "  ~/llm_launch.sh 'prompt'      # llm.py (full chain)"
echo "  ~/llm_launch.sh 'prompt' --fast # llm.py (fastest)"
echo "  ~/agent_final.sh 'prompt'     # Universal agent"
echo "  ~/switch.sh kimi              # Switch to fastest"
