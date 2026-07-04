#!/bin/bash
echo "=== Creating FCC Workspace for Discord ==="

# Create workspace directory
mkdir -p ~/fcc_workspace
mkdir -p ~/fcc_workspace/projects
mkdir -p ~/fcc_workspace/temp

echo "✅ Workspace created at: ~/fcc_workspace"

# Create a welcome file
cat > ~/fcc_workspace/README.md << 'WELCOME'
# FCC Discord Bot Workspace

This directory is used by the FCC Discord bot for:
- Running Claude Code/Codex sessions
- Storing project files
- Temporary workspace for tasks

**Safe to delete any files here when done.**

Voice notes will be processed here.
WELCOME

echo "✅ Welcome file created"
echo ""
echo "📋 Allowed Directory for Discord bot: /home/ubuntu/fcc_workspace"
