#!/bin/bash
echo "=== Creating Project Structure ==="

# Create main project directory
mkdir -p ~/claude-agent
cd ~/claude-agent

# Create subdirectories
mkdir -p backend
mkdir -p frontend
mkdir -p scripts
mkdir -p logs
mkdir -p workspace
mkdir -p config

# Move backend files
mv ~/agent_server.py ~/claude-agent/backend/ 2>/dev/null
mv ~/discord_bot_advanced.py ~/claude-agent/backend/ 2>/dev/null

# Move scripts
mv ~/*.sh ~/claude-agent/scripts/ 2>/dev/null

# Move config files
mv ~/.fcc ~/claude-agent/config/fcc 2>/dev/null
mv ~/.codex ~/claude-agent/config/codex 2>/dev/null

# Move logs
mv ~/fcc_logs ~/claude-agent/logs/fcc 2>/dev/null
mv ~/discord_bot.log ~/claude-agent/logs/discord.log 2>/dev/null
mv ~/agent_server.log ~/claude-agent/logs/agent.log 2>/dev/null

# Move workspace
mv ~/fcc_workspace/* ~/claude-agent/workspace/ 2>/dev/null

# Create symlinks for easy access
ln -sf ~/claude-agent/backend/agent_server.py ~/agent_server.py
ln -sf ~/claude-agent/backend/discord_bot_advanced.py ~/discord_bot_advanced.py

echo "✅ Project structure created at ~/claude-agent"
echo ""
echo "📁 Structure:"
tree ~/claude-agent -L 2 2>/dev/null || ls -la ~/claude-agent/
