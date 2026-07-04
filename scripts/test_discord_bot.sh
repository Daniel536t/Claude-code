#!/bin/bash
echo "=== Testing Discord Bot ==="

# Check configuration
echo ""
echo "1️⃣ Configuration Check:"
if [ -f ~/.discord_ids ]; then
    source ~/.discord_ids
    echo "   ✅ Channel ID: $CHANNEL_ID"
else
    echo "   ❌ No IDs found"
fi

if [ -f ~/.discord_token ]; then
    echo "   ✅ Bot token saved"
else
    echo "   ❌ No token found"
fi

# Check FCC
echo ""
echo "2️⃣ FCC Status:"
if pgrep -f fcc-server > /dev/null; then
    echo "   ✅ FCC Proxy Running"
else
    echo "   ❌ FCC Not Running - run: restart"
fi

# Check logs for Discord
echo ""
echo "3️⃣ Recent Discord Activity:"
tail -20 ~/fcc_logs/fcc.log | grep -i "discord\|messaging" || echo "   No Discord activity yet (send a message in Discord!)"

echo ""
echo "📌 Next Steps:"
echo "   1. Go to your Discord channel"
echo "   2. Type: /stop  (to see if bot responds)"
echo "   3. Type any message - the bot should run Claude Code!"
echo "   4. Check logs: discord-logs"
