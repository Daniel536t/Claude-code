#!/bin/bash

echo "=== Launching FCC with API Keys ==="

# Kill existing
pkill -f fcc-server 2>/dev/null
sleep 2

# Export all keys from .env
set -a
source ~/.fcc/.env
set +a

# Launch
nohup fcc-server > ~/fcc_logs/fcc.log 2>&1 &
sleep 3

echo "✅ FCC started with environment variables"
echo "Testing..."

# Test
curl -s http://localhost:8082/v1/models | head -20
echo ""
fcc-claude -p "Hello" | head -3
