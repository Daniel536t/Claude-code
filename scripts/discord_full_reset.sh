#!/bin/bash
echo "=== Full Discord Reset ==="

# Stop FCC
pkill -f fcc-server 2>/dev/null

# Backup
mkdir -p ~/.fcc/backups
cp ~/.fcc/.env ~/.fcc/backups/.env.full_backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null

# Create fresh .env with all configs
cat > ~/.fcc/.env << 'ENVEOF'
# NVIDIA NIM
NVIDIA_NIM_API_KEY=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
MODEL=nvidia_nim/moonshotai/kimi-k2.6
MODEL_OPUS=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b
MODEL_SONNET=nvidia_nim/moonshotai/kimi-k2.6
MODEL_HAIKU=nvidia_nim/deepseek-ai/deepseek-v4-flash

# Sambanova
SAMBANOVA_API_KEY=aa00847f-db17-461e-b725-18984b37a59e

# FreeTheAi
FTA_API_KEY=sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d

# Proxy settings
PORT=8082
ANTHROPIC_AUTH_TOKEN=freecc
CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY=1
CLAUDE_CODE_AUTO_COMPACT_WINDOW=190000

# Discord Bot Configuration
DISCORD_BOT_TOKEN=DISCORD_BOT_TOKEN_PLACEHOLDER
DISCORD_ALLOWED_CHANNELS=1522818806911860831
DISCORD_ALLOWED_DIRECTORY=/home/ubuntu/fcc_workspace
MESSAGING_PLATFORM=discord
ENVEOF

# Create workspace
mkdir -p ~/fcc_workspace

echo "✅ Fresh config created"
echo ""
echo "📌 Config:"
grep -E "MODEL=|DISCORD|CHANNEL" ~/.fcc/.env

echo ""
echo "🔄 Starting FCC..."
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 5

echo ""
echo "✅ FCC Started"
echo ""
echo "📊 Check logs for Discord:"
tail -50 ~/fcc_logs/fcc.log | grep -i "discord\|messaging" || echo "  Checking bot connection..."
echo ""
echo "📌 Now go to Discord and send a message!"
echo "   If it works, you'll see activity in logs."
