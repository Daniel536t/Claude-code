#!/bin/bash
echo "=== Starting Agent Backend ==="

cd ~/claude-agent/backend

# Kill any existing server
pkill -f agent_server.py 2>/dev/null

# Start the server
nohup python3 agent_server.py > ../logs/agent.log 2>&1 &

sleep 3

if pgrep -f agent_server.py > /dev/null; then
    echo "✅ Backend running on port 8000"
    echo "📌 API: http://localhost:8000"
    echo "📌 WebSocket: ws://localhost:8000/ws/{session_id}"
    echo "📊 Logs: tail -f ~/claude-agent/logs/agent.log"
else
    echo "❌ Backend failed to start"
    tail -20 ../logs/agent.log
fi
