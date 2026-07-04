#!/bin/bash
echo "=== Starting Discord Bot ==="

# Kill any existing bot processes
pkill -f discord_bot_standalone.py 2>/dev/null

# Start the bot in background
nohup python3 ~/discord_bot_standalone.py > ~/discord_bot.log 2>&1 &

sleep 3

# Check if it's running
if pgrep -f discord_bot_standalone.py > /dev/null; then
    echo "✅ Discord bot running (PID: $(pgrep -f discord_bot_standalone.py))"
    echo "📊 Logs: tail -f ~/discord_bot.log"
    echo "📌 Go to Discord and send a message!"
else
    echo "❌ Bot failed to start. Check logs:"
    tail -20 ~/discord_bot.log
fi
