#!/bin/bash
echo "=== Checking File Locations ==="

echo "1️⃣ Looking for agent_server.py:"
find ~ -name "agent_server.py" 2>/dev/null

echo ""
echo "2️⃣ Looking for discord_bot_advanced.py:"
find ~ -name "discord_bot_advanced.py" 2>/dev/null

echo ""
echo "3️⃣ Contents of claude-agent:"
ls -la ~/claude-agent/
ls -la ~/claude-agent/backend/ 2>/dev/null || echo "  backend/ directory exists but empty"

echo ""
echo "4️⃣ Stray Python files in home:"
ls ~/*.py 2>/dev/null | grep -v "hunter\|ember\|virus"
