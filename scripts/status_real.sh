#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   ✅ REAL SYSTEM STATUS                ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "📌 Components:"

# FCC Proxy
if pgrep -f fcc-server > /dev/null; then
    echo "  FCC Proxy: ✅ Running"
else
    echo "  FCC Proxy: ❌ Stopped"
fi

# Claude Code
echo -n "  Claude Code: "
response=$(timeout 5 fcc-claude -p "OK" 2>/dev/null | head -1)
if [ -n "$response" ]; then
    echo "✅ Working (response: $response)"
else
    echo "❌ Failed"
fi

# Codex
echo -n "  Codex: "
response=$(timeout 5 ~/codex_work.sh exec "OK" 2>/dev/null | head -1)
if [ -n "$response" ]; then
    echo "✅ Working (response: $response)"
else
    echo "❌ Failed"
fi

# llm.py
echo -n "  llm.py: "
response=$(timeout 5 ~/llm_launch.sh "OK" --fast 2>/dev/null | tail -1)
if [ -n "$response" ]; then
    echo "✅ Working (response: $response)"
else
    echo "❌ Failed"
fi

# FreeTheAi Direct
echo -n "  FreeTheAi: "
response=$(curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"OK"}],"max_tokens":5}' 2>/dev/null | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content','No'))")
if [ -n "$response" ] && [ "$response" != "No" ]; then
    echo "✅ Working (response: $response)"
else
    echo "❌ Failed"
fi

echo ""
echo "📊 Current Model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo ""
echo "📋 Working Commands:"
echo "  fcc-claude -p 'prompt'        # Claude Code"
echo "  ~/codex_work.sh exec 'prompt' # Codex"
echo "  ~/llm_launch.sh 'prompt'      # llm.py"
echo "  ~/agent_fixed.sh 'prompt'     # Universal agent"
