#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing FreeTheAi Models via OpenRouter ==="
echo ""

models=(
    "open_router/opc/deepseek-v4-flash-free|DeepSeek V4 Flash"
    "open_router/opc/big-pickle|Big Pickle"
    "open_router/opc/mimo-v2.5-free|Mimo V2.5"
    "open_router/opc/nemotron-3-ultra-free|Nemotron 3 Ultra"
    "open_router/opc/north-mini-code-free|North Mini Code"
    "open_router/vova/claude-opus-4-8|Claude Opus 4.8"
    "open_router/vova/claude-sonnet-4-6|Claude Sonnet 4.6"
    "open_router/vova/gemini-3.5-flash|Gemini 3.5 Flash"
)

for entry in "${models[@]}"; do
    IFS='|' read -r model name <<< "$entry"
    echo -n "Testing $name... "
    sed -i "s|^MODEL=.*|MODEL=$model|" ~/.fcc/.env
    ~/fcc_working.sh > /dev/null 2>&1
    sleep 2
    
    response=$(timeout 15 fcc-claude -p "Say OK in one word" 2>/dev/null)
    if [ -n "$response" ]; then
        echo "✅ Working - $response"
    else
        echo "❌ Failed/Timeout"
    fi
done

# Back to fastest
~/switch.sh kimi > /dev/null 2>&1
echo ""
echo "✅ Back to Kimi K2.6"
