#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Fixing FCC API Keys ==="

# Stop FCC
pkill -f fcc-server
sleep 2

# Create clean .env with all required keys
cat > ~/.fcc/.env << 'ENVEOF'
# NVIDIA NIM
NVIDIA_NIM_API_KEY=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
MODEL=nvidia_nim/moonshotai/kimi-k2.6

# Model tier routing
MODEL_OPUS=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b
MODEL_SONNET=nvidia_nim/moonshotai/kimi-k2.6
MODEL_HAIKU=nvidia_nim/deepseek-ai/deepseek-v4-flash

# Sambanova
SAMBANOVA_API_KEY=aa00847f-db17-461e-b725-18984b37a59e

# FreeTheAi
FTA_API_KEY=sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d

# Cloudflare
CLOUDFLARE_API_TOKEN=CLOUDFLARE_TOKEN_PLACEHOLDER
CLOUDFLARE_ACCOUNT_ID=3d595aa9564ce6485743f1c89d9d7065

# Proxy settings
PORT=8082
ANTHROPIC_AUTH_TOKEN=freecc
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
CLAUDE_CODE_AUTO_COMPACT_WINDOW=190000
ENVEOF

echo "✅ Config created"

# Start FCC with explicit env
cd ~
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

echo "✅ FCC restarted with keys"

# Test
echo ""
echo "=== Testing ==="
curl -s http://localhost:8082/v1/models | python3 -m json.tool 2>/dev/null | head -20
echo ""
fcc-claude -p "Say OK in one word" 2>/dev/null | head -3
