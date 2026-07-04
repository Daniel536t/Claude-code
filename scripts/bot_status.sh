#!/bin/bash
echo "=== Discord Bot Status ==="

# Check if bot is running
if pgrep -f discord_bot_standalone.py > /dev/null; then
    echo "✅ Bot running (PID: $(pgrep -f discord_bot_standalone.py))"
else
    echo "❌ Bot not running"
fi

echo ""
echo "📊 Recent bot activity:"
tail -20 ~/discord_bot.log 2>/dev/null || echo "No logs yet"

echo ""
echo "📌 Test commands:"
echo "   Go to Discord and type: Hello"
echo "   The bot should respond with Claude Code!"
