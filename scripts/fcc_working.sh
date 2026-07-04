#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Kill existing
pkill -f fcc-server 2>/dev/null
sleep 2

# Source keys
set -a
source ~/.fcc/.env
set +a

# Start
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

echo "✅ FCC Running"
echo "📊 Admin: http://127.0.0.1:8082/admin"

# Quick test
echo ""
echo "Test:"
curl -s http://localhost:8082/health
echo ""
fcc-claude -p "Say OK in 2 words" 2>/dev/null
