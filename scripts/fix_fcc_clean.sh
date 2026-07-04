#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Cleaning FCC Config ==="

# Stop FCC
pkill -f fcc-server 2>/dev/null
sleep 2

# Create clean config - ONLY NVIDIA NIM
cat > ~/.fcc/.env << 'ENVEOF'
# NVIDIA NIM (Primary - Fastest)
NVIDIA_NIM_API_KEY=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
MODEL=nvidia_nim/moonshotai/kimi-k2.6

# Model tier routing (all using NVIDIA NIM)
MODEL_OPUS=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b
MODEL_SONNET=nvidia_nim/moonshotai/kimi-k2.6
MODEL_HAIKU=nvidia_nim/deepseek-ai/deepseek-v4-flash

# Proxy settings
PORT=8082
ANTHROPIC_AUTH_TOKEN=freecc
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
CLAUDE_CODE_AUTO_COMPACT_WINDOW=190000
ENVEOF

echo "✅ Clean config created"

# Start FCC
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

echo "✅ FCC restarted with clean config"

# Test
echo ""
echo "Testing FCC:"
curl -s http://localhost:8082/health
echo ""
fcc-claude -p "Say OK in one word" 2>/dev/null | head -3
