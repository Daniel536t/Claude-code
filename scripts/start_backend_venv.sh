#!/bin/bash
echo "=== Starting Backend with Virtual Environment ==="

cd ~/claude-agent/backend

# Activate venv and start
source venv/bin/activate
nohup python3 agent_server.py > ../logs/agent.log 2>&1 &

sleep 3

if pgrep -f agent_server.py > /dev/null; then
    echo "✅ Backend running on port 8000"
    echo "📌 API: http://localhost:8000"
    echo "📌 WebSocket: ws://localhost:8000/ws/{session_id}"
    echo "📊 Logs: tail -f ~/claude-agent/logs/agent.log"
else
    echo "❌ Backend failed to start"
    echo "Logs:"
    tail -20 ../logs/agent.log
fi
