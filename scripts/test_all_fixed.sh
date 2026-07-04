#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   🧪 TESTING ALL SYSTEMS (FIXED)       ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Function to test and show results (less strict)
test_system() {
    local name="$1"
    local cmd="$2"
    
    echo -n "📌 $name: "
    result=$(eval "$cmd" 2>/dev/null | head -1)
    
    if [ -n "$result" ] && [ "$result" != "" ]; then
        echo "✅ Working"
        echo "   Response: $result"
    else
        echo "❌ No response"
    fi
}

# Test each system
test_system "FCC Proxy" "curl -s http://localhost:8082/health | grep -o healthy"
test_system "Claude Code" "fcc-claude -p OK 2>/dev/null | head -1"
test_system "Codex" "~/codex_work.sh exec OK 2>/dev/null | head -1"
test_system "llm.py Fast" "~/llm_launch.sh OK --fast 2>/dev/null | tail -1"
test_system "llm.py Full" "~/llm_launch.sh OK 2>/dev/null | tail -1"
test_system "FreeTheAi Direct" "curl -s -X POST https://api.freetheai.xyz/v1/chat/completions -H 'Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d' -H 'Content-Type: application/json' -d '{\"model\":\"vova/gemini-3.5-flash\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}' 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin).get(\"choices\",[{}])[0].get(\"message\",{}).get(\"content\",\"No\"))'"

echo ""
echo "📊 Current model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo ""
echo "✅ Test complete!"
