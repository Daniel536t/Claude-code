#!/bin/bash
echo "=== Checking Bot Token Format ==="

TOKEN=$(cat ~/.discord_token 2>/dev/null)

if [ -z "$TOKEN" ]; then
    echo "❌ No token saved"
    echo ""
    echo "📌 Go to: https://discord.com/developers/applications/1522816547842953257/bot"
    echo "   Click 'Reset Token' and copy the new token"
    echo ""
    echo "   Then save it:"
    echo "   echo 'YOUR_NEW_TOKEN' > ~/.discord_token"
else
    echo "✅ Token saved: ${TOKEN:0:20}..."
    echo ""
    echo "📌 Token format should look like:"
TOKEN_PLACEHOLDER
    echo ""
    echo "⚠️  If the bot still doesn't work, the token may have been regenerated."
    echo "   Get a new token from the Developer Portal."
fi
