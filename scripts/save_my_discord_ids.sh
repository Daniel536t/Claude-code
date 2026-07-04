#!/bin/bash
echo "=== Saving Your Discord IDs ==="

# Your IDs from the URL
SERVER_ID="1522818806911860828"
CHANNEL_ID="1522818806911860831"
BOT_TOKEN="DISCORD_BOT_TOKEN_PLACEHOLDER"

# Save server ID
echo "$SERVER_ID" > ~/.discord_server_id

# Save channel ID
echo "$CHANNEL_ID" > ~/.discord_channel_id

# Save bot token
echo "$BOT_TOKEN" > ~/.discord_token
chmod 600 ~/.discord_token

# Save both IDs in one file
cat > ~/.discord_ids << 'IDEOF'
SERVER_ID=1522818806911860828
CHANNEL_ID=1522818806911860831
IDEOF

echo "✅ IDs saved!"
echo "   Server ID:  $SERVER_ID"
echo "   Channel ID: $CHANNEL_ID"
echo "   Bot Token:  [HIDDEN]"
echo ""
echo "📌 Verify saved:"
echo "   cat ~/.discord_ids"
