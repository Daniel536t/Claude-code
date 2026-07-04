#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   ✅ FINAL SYSTEM STATUS               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "📌 Components:"
echo "  FCC Proxy: $(pgrep -f fcc-server > /dev/null && echo "✅ Running" || echo "❌ Stopped")"
echo "  Claude Code: $(fcc-claude -p "OK" 2>/dev/null | head -1 | grep -q "OK" && echo "✅ Working" || echo "❌ Failed")"
echo "  Codex: $(~/codex_work.sh exec "OK" 2>/dev/null | head -1 | grep -q "OK" && echo "✅ Working" || echo "❌ Failed")"
echo "  llm.py: $(~/llm_launch.sh "OK" --fast 2>/dev/null | head -1 | grep -q "OK" && echo "✅ Working" || echo "❌ Failed")"
echo "  FreeTheAi: $(curl -s -X POST https://api.freetheai.xyz/v1/chat/completions -H 'Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d' -H 'Content-Type: application/json' -d '{"model":"vova/gemini-3.5-flash","messages":[{"role":"user","content":"OK"}],"max_tokens":5}' 2>/dev/null | grep -q "OK" && echo "✅ Working" || echo "❌ Failed")"

echo ""
echo "📋 Quick Commands:"
echo "  fcc-claude -p 'prompt'        # Claude Code"
echo "  ~/codex_work.sh exec 'prompt' # Codex"
echo "  ~/llm_launch.sh 'prompt'      # llm.py"
echo "  ~/agent.sh 'prompt'           # Universal agent"
echo "  ~/switch.sh kimi              # Switch model"
echo ""
echo "📊 Model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
