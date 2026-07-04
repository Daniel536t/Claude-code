#!/bin/bash
echo "=== Creating Systemd Service ==="

sudo cat > /etc/systemd/system/claude-agent.service << 'SERVICEEOF'
[Unit]
Description=Claude Code Agent Backend
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/claude-agent/backend
Environment="PATH=/home/ubuntu/claude-agent/backend/venv/bin:/usr/local/bin:/usr/bin:/bin"
ExecStart=/home/ubuntu/claude-agent/backend/venv/bin/python3 /home/ubuntu/claude-agent/backend/agent_server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
SERVICEEOF

sudo systemctl daemon-reload
sudo systemctl enable claude-agent
sudo systemctl start claude-agent

echo "✅ Service created and started"
echo ""
echo "📌 Service commands:"
echo "   sudo systemctl status claude-agent   # Check status"
echo "   sudo systemctl stop claude-agent     # Stop service"
echo "   sudo systemctl start claude-agent    # Start service"
echo "   sudo journalctl -u claude-agent -f   # View logs"
