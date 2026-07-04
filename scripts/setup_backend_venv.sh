#!/bin/bash
echo "=== Setting up Backend Virtual Environment ==="

cd ~/claude-agent/backend

# Create virtual environment
python3 -m venv venv

# Activate and install dependencies
source venv/bin/activate
pip install fastapi uvicorn websockets python-multipart

echo "✅ Virtual environment created"
echo ""

# Create start script that uses the venv
cat > ~/claude-agent/backend/start.sh << 'STARTEOF'
#!/bin/bash
cd ~/claude-agent/backend
source venv/bin/activate
python3 agent_server.py
STARTEOF

chmod +x ~/claude-agent/backend/start.sh

# Create background start script
cat > ~/start_backend_venv.sh << 'STARTBGEOF'
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
STARTBGEOF

chmod +x ~/start_backend_venv.sh

echo "✅ Start scripts created"
echo ""
echo "📌 To start backend: ~/start_backend_venv.sh"
echo "📌 To run interactively: ~/claude-agent/backend/start.sh"
