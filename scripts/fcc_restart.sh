#!/bin/bash
# Quick restart script for FCC proxy
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "🔄 Restarting FCC Proxy..."
pkill -f fcc-server 2>/dev/null
sleep 2
fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

if pgrep -f fcc-server > /dev/null; then
    echo "✅ Proxy restarted successfully"
    echo "📊 Admin UI: http://127.0.0.1:8082/admin"
else
    echo "❌ Failed to restart. Check: tail -20 ~/fcc_logs/fcc.log"
fi
