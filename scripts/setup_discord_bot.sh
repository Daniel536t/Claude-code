#!/bin/bash
echo "╔══════════════════════════════════════════╗"
echo "║   Discord Bot Setup for FCC            ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "📋 Prerequisites:"
echo "  1. Create a Discord bot at: https://discord.com/developers/applications"
echo "  2. Enable 'Message Content Intent' in bot settings"
echo "  3. Invite bot to your server"
echo "  4. Get your bot token"
echo "  5. Get your channel ID (right-click channel → Copy ID)"
echo ""

# Check if FCC messaging is installed
echo "Checking FCC messaging dependencies..."
if pip3 show discord.py 2>/dev/null | grep -q "discord.py"; then
    echo "✅ discord.py installed"
else
    echo "⚠️  discord.py not found. Installing..."
    pip3 install discord.py --break-system-packages 2>/dev/null || \
    pipx install discord.py 2>/dev/null || \
    echo "⚠️  Please install discord.py manually: pip install discord.py"
fi

echo ""
echo "📝 Next steps:"
echo "  1. Configure FCC Admin UI: http://127.0.0.1:8082/admin"
echo "  2. Go to 'Messaging' section"
echo "  3. Set 'Messaging Platform' to 'discord'"
echo "  4. Paste your Discord Bot Token"
echo "  5. Add your Allowed Discord Channel IDs"
echo "  6. Set 'Allowed Directory' (e.g., /home/ubuntu/fcc_workspace)"
echo "  7. Click 'Validate', then 'Apply'"
echo "  8. Restart FCC server: restart"
echo ""
echo "📌 After setup:"
echo "  - /stop - Cancel a task"
echo "  - /clear - Reset sessions"
echo "  - /stats - Show session state"
echo "  - Voice notes supported (with --voice-nim or --voice-local)"
