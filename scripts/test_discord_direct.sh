#!/bin/bash
echo "=== Testing Discord Bot Directly ==="

# Check if Discord module is available
echo "1️⃣ Checking discord.py:"
python3 -c "import discord; print('✅ discord.py available')" 2>/dev/null || echo "❌ discord.py not available"

# Check FCC messaging
echo ""
echo "2️⃣ Checking FCC messaging:"
grep -i "messaging" ~/fcc_logs/fcc.log | tail -5 || echo "No messaging logs"

# Check for bot connection
echo ""
echo "3️⃣ Looking for Discord bot connection:"
grep -i "discord.*connect\|discord.*started" ~/fcc_logs/fcc.log | tail -5 || echo "Bot not connected"

echo ""
echo "📌 Manual test:"
echo "   Go to your Discord channel and type: /ping"
echo "   If the bot responds, it's working!"
echo ""
echo "📌 If still not working:"
echo "   1. Make sure bot is invited to server"
echo "   2. Check token is valid in Developer Portal"
echo "   3. Make sure MESSAGE CONTENT INTENT is enabled"
echo "   4. Check channel ID is correct: 1522818806911860831"
