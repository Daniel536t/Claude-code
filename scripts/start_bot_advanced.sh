#!/bin/bash
echo "=== Starting Advanced Discord Bot ==="

# Kill any existing bots
pkill -f discord_bot_advanced.py 2>/dev/null
pkill -f discord_bot_standalone.py 2>/dev/null

# Start advanced bot
nohup python3 ~/discord_bot_advanced.py > ~/discord_bot.log 2>&1 &

sleep 3

if pgrep -f discord_bot_advanced.py > /dev/null; then
    echo "✅ Advanced bot running (PID: $(pgrep -f discord_bot_advanced.py))"
    echo ""
    echo "📌 Commands now available:"
    echo "   /model        - Show current model"
    echo "   /model kimi   - Switch to Kimi K2.6"
    echo "   /model glm    - Switch to GLM 5.2"
    echo "   /status       - Show bot status"
    echo "   /stop         - Cancel active task"
    echo ""
    echo "📊 Logs: tail -f ~/discord_bot.log"
else
    echo "❌ Bot failed to start"
    tail -20 ~/discord_bot.log
fi
