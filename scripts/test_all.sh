#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   🧪 TESTING ALL SYSTEMS               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# Function to test and show results
test_system() {
    local name="$1"
    local cmd="$2"
    local expected="$3"
    
    echo -n "📌 $name: "
    result=$(eval "$cmd" 2>/dev/null | head -1)
    
    if [[ "$result" == *"$expected"* ]]; then
        echo "✅ PASS"
    elif [ -z "$result" ]; then
        echo "⚠️  No output"
    else
        echo "❌ FAIL - Got: $result"
    fi
}

# Test each system
test_system "FCC Proxy" "curl -s http://localhost:8082/health | grep -o healthy" "healthy"
test_system "Claude Code" "fcc-claude -p OK 2>/dev/null | head -1" "OK"
test_system "Codex" "~/codex_work.sh exec OK 2>/dev/null | head -1" "OK"
test_system "llm.py Fast" "~/llm_launch.sh OK --fast 2>/dev/null | tail -1" "OK"
test_system "llm.py Full" "~/llm_launch.sh OK 2>/dev/null | tail -1" "OK"
test_system "FreeTheAi Direct" "curl -s -X POST https://api.freetheai.xyz/v1/chat/completions -H 'Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d' -H 'Content-Type: application/json' -d '{\"model\":\"vova/gemini-3.5-flash\",\"messages\":[{\"role\":\"user\",\"content\":\"OK\"}],\"max_tokens\":5}' 2>/dev/null | python3 -c 'import sys,json; print(json.load(sys.stdin).get(\"choices\",[{}])[0].get(\"message\",{}).get(\"content\",\"No\"))'" "OK"

echo ""
echo "📊 Current model: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo ""
echo "✅ Test complete!"
