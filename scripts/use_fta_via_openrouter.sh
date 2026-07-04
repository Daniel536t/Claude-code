#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Setting up FreeTheAi via OpenRouter ==="
echo ""

# Your FreeTheAi key works with OpenRouter too!
OPENROUTER_KEY="sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d"

# Test directly with OpenRouter API
echo "1️⃣ Testing OpenRouter with FreeTheAi models..."
curl -s -X POST https://openrouter.ai/api/v1/chat/completions \
    -H "Authorization: Bearer $OPENROUTER_KEY" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "opc/deepseek-v4-flash-free",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -m json.tool 2>/dev/null | grep -A2 "content" | head -3

echo ""
echo "2️⃣ Configuring FCC to use OpenRouter..."
mkdir -p ~/.fcc/backups
cp ~/.fcc/.env ~/.fcc/backups/.env.openrouter.$(date +%Y%m%d_%H%M%S)

# Update .env with OpenRouter config
cat > ~/.fcc/.env << 'ENVEOF'
# NVIDIA NIM (Primary - Fastest)
NVIDIA_NIM_API_KEY=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
MODEL=nvidia_nim/moonshotai/kimi-k2.6

# OpenRouter (For FreeTheAi models)
OPENROUTER_API_KEY=sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d

# Tier routing - use OpenRouter for different tiers
MODEL_OPUS=open_router/opc/deepseek-v4-flash-free
MODEL_SONNET=open_router/opc/big-pickle
MODEL_HAIKU=open_router/opc/mimo-v2.5-free

# Proxy settings
PORT=8082
ANTHROPIC_AUTH_TOKEN=freecc
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
CLAUDE_CODE_AUTO_COMPACT_WINDOW=190000
ENVEOF

echo "✅ Config updated with OpenRouter"
echo ""
echo "3️⃣ Restarting FCC..."
~/fcc_working.sh > /dev/null 2>&1
sleep 2

echo "4️⃣ Testing OpenRouter models through FCC..."
echo ""
echo "Testing OpenRouter DeepSeek V4 Flash..."
sed -i 's|^MODEL=.*|MODEL=open_router/opc/deepseek-v4-flash-free|' ~/.fcc/.env
~/fcc_working.sh > /dev/null 2>&1
sleep 2
fcc-claude -p "Say OK in one word" 2>/dev/null

echo ""
echo "Testing OpenRouter Big Pickle..."
sed -i 's|^MODEL=.*|MODEL=open_router/opc/big-pickle|' ~/.fcc/.env
~/fcc_working.sh > /dev/null 2>&1
sleep 2
fcc-claude -p "Say OK in one word" 2>/dev/null

# Switch back to fastest
~/switch.sh kimi > /dev/null 2>&1
echo ""
echo "✅ Back to Kimi K2.6 (fastest)"
