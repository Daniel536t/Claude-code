#!/bin/bash
echo "=== Fixing Discord Config ==="

# Your IDs
SERVER_ID="1522818806911860828"
CHANNEL_ID="1522818806911860831"
BOT_TOKEN="DISCORD_BOT_TOKEN_PLACEHOLDER"

# Stop FCC
pkill -f fcc-server 2>/dev/null

# Clean config
mkdir -p ~/.fcc/backups
cp ~/.fcc/.env ~/.fcc/backups/.env.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null

# Remove old Discord config
sed -i '/DISCORD_/d' ~/.fcc/.env 2>/dev/null
sed -i '/MESSAGING_PLATFORM/d' ~/.fcc/.env 2>/dev/null

# Add clean Discord config
cat >> ~/.fcc/.env << 'ENVEOF'

# Discord Bot Configuration
DISCORD_BOT_TOKEN=DISCORD_BOT_TOKEN_PLACEHOLDER
DISCORD_ALLOWED_CHANNELS=1522818806911860831
DISCORD_ALLOWED_DIRECTORY=/home/ubuntu/fcc_workspace
MESSAGING_PLATFORM=discord
ENVEOF

# Create workspace
mkdir -p ~/fcc_workspace

echo "✅ Config fixed"
echo ""
echo "📌 Config contents:"
grep -E "DISCORD|MESSAGING" ~/.fcc/.env

echo ""
echo "🔄 Starting FCC..."
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 5

echo ""
echo "✅ FCC Restarted"
echo ""
echo "📊 Check logs:"
tail -30 ~/fcc_logs/fcc.log | grep -i "discord\|messaging"
