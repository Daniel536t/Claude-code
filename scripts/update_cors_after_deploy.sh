#!/bin/bash
echo "=== Update CORS After Vercel Deploy ==="

read -p "Enter your Vercel app URL (e.g., my-app.vercel.app): " VERCEL_URL

if [ -z "$VERCEL_URL" ]; then
    echo "❌ No URL provided"
    exit 1
fi

echo "📌 Updating CORS for: https://$VERCEL_URL"

cd ~/claude-agent/backend

# Backup
cp agent_server.py agent_server.py.backup.$(date +%Y%m%d_%H%M%S)

# Update CORS
sed -i "s|ALLOWED_ORIGINS = \[|ALLOWED_ORIGINS = [\n    \"https://$VERCEL_URL\",|" agent_server.py

echo "✅ CORS updated"
echo ""
echo "🔄 Restarting backend..."
pkill -f agent_server.py
~/start_backend_venv.sh

echo ""
echo "✅ Done! Your app should now work with CORS."
