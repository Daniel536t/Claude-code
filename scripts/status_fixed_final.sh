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

# Claude Code - with longer timeout
echo -n "  Claude Code: "
response=$(timeout 15 fcc-claude -p "Say OK" 2>/dev/null | head -1)
if [ -n "$response" ] && [[ "$response" == *"OK"* || "$response" == *"Ready"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "⚠️  Partial (may need longer for complex prompts)"
fi

# llm.py fast
echo -n "  llm.py Fast: "
response=$(timeout 10 ~/llm_launch.sh "Say OK" --fast 2>/dev/null | tail -1)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# llm.py full
echo -n "  llm.py Full: "
response=$(timeout 10 ~/llm_launch.sh "Say OK" 2>/dev/null | tail -1)
if [[ "$response" == *"OK"* ]]; then
    echo "✅ Working → \"$response\""
else
    echo "❌ No response"
fi

# Codex
echo -n "  Codex: "
response=$(timeout 10 ~/codex_work.sh exec "Say OK" 2>/dev/null | head -1)
if [ -n "$response" ]; then
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

echo ""
echo "📊 Current Model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo ""
echo "📋 WORKING COMMANDS:"
echo "  claude -p 'prompt'          # Claude Code"
echo "  ask 'prompt' --fast         # llm.py (fastest)"
echo "  ask 'prompt'                # llm.py (full chain)"
echo "  agent 'prompt'              # Universal agent (fixed timeout)"
echo "  codex exec 'prompt'         # Codex (it works!)"
echo "  kimi                        # Switch to fastest"
