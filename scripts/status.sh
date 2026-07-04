#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   System Status (Including Codex)      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "📌 FCC Proxy:"
if pgrep -f fcc-server > /dev/null; then
    echo "  ✅ Running (PID: $(pgrep -f fcc-server))"
    echo "  Model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
else
    echo "  ❌ Stopped"
fi

echo ""
echo "📌 Claude Code CLI:"
fcc-claude -p "OK" 2>/dev/null | head -1 | grep -q "OK" && echo "  ✅ Working" || echo "  ❌ Failed"

echo ""
echo "📌 Codex CLI:"
fcc-codex exec "OK" 2>/dev/null | head -1 | grep -q "OK" && echo "  ✅ Working" || echo "  ❌ Failed"

echo ""
echo "📌 llm.py:"
~/llm_launch.sh "OK" --fast 2>/dev/null | head -1 | grep -q "OK" && echo "  ✅ Working" || echo "  ❌ Failed"

echo ""
echo "📌 FreeTheAi Direct:"
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"OK"}],"max_tokens":5}' 2>/dev/null | grep -q "OK" && echo "  ✅ Working" || echo "  ❌ Failed"

echo ""
echo "📊 Quick commands:"
echo "  fcc-claude -p 'prompt'           # Claude Code"
echo "  fcc-codex exec 'prompt'          # Codex"
echo "  ~/llm_launch.sh 'prompt'         # llm.py"
echo "  ~/switch.sh kimi                 # Switch model"
echo "  ~/compare_agents.sh              # Compare agents"
