#!/bin/bash
echo "=== Reinstalling FCC with Messaging Support ==="

# Stop FCC
pkill -f fcc-server 2>/dev/null

# Reinstall FCC with messaging extras
echo "Reinstalling Free Claude Code with messaging..."
curl -fsSL "https://github.com/Alishahryar1/free-claude-code/blob/main/scripts/install.sh?raw=1" | sh -s -- --extras messaging

# Check if messaging was installed
if [ -d ~/.local/share/uv/tools/free-claude-code/lib/python3.14/site-packages/messaging ]; then
    echo "✅ Messaging module installed"
else
    echo "⚠️  Messaging module not found - trying alternative install..."
    # Alternative: install via uv
    uv tool install free-claude-code --extra messaging 2>/dev/null || echo "Manual install needed"
fi

echo ""
echo "🔄 Starting FCC..."
export $(cat ~/.fcc/.env | grep -v '^#' | xargs)
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 5

echo ""
echo "📊 Checking for Discord initialization:"
tail -50 ~/fcc_logs/fcc.log | grep -i "discord\|messaging"
