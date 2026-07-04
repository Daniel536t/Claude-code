#!/bin/bash
echo "=== Configuring Discord Bot ==="

# Load your IDs
source ~/.discord_ids 2>/dev/null
TOKEN=$(cat ~/.discord_token 2>/dev/null)

if [ -z "$CHANNEL_ID" ] || [ -z "$TOKEN" ]; then
    echo "❌ Missing IDs or token. Run ~/save_my_discord_ids.sh first"
    exit 1
fi

echo "✅ Channel ID: $CHANNEL_ID"
echo "✅ Token loaded"

# Backup current config
mkdir -p ~/.fcc/backups
cp ~/.fcc/.env ~/.fcc/backups/.env.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null

# Remove old Discord config
sed -i '/DISCORD_/d' ~/.fcc/.env 2>/dev/null
sed -i '/MESSAGING_PLATFORM/d' ~/.fcc/.env 2>/dev/null

# Add Discord config
cat >> ~/.fcc/.env << 'ENVEOF'

# Discord Bot Configuration
DISCORD_BOT_TOKEN=$TOKEN
DISCORD_ALLOWED_CHANNELS=$CHANNEL_ID
DISCORD_ALLOWED_DIRECTORY=/home/ubuntu/fcc_workspace
MESSAGING_PLATFORM=discord
ENVEOF

echo "✅ Discord config added to ~/.fcc/.env"

# Create workspace
mkdir -p ~/fcc_workspace

echo ""
echo "🔄 Restarting FCC..."
pkill -f fcc-server 2>/dev/null
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ DISCORD BOT IS READY!              ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "📌 Channel: $CHANNEL_ID"
echo "📌 Workspace: ~/fcc_workspace"
echo ""
echo "🎮 GO TO YOUR DISCORD CHANNEL AND TYPE A MESSAGE!"
echo "   The bot will respond using Claude Code."
echo ""
echo "📊 Check status: discord-status"
echo "📊 Watch logs: discord-logs"
