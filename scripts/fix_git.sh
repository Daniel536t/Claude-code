#!/bin/bash
echo "=== Fixing Git Repository ==="

cd ~/claude-agent

# Remove the problematic .tmp directory
rm -rf config/codex/.tmp/

# Remove git cache and reinitialize
rm -rf .git

# Reinitialize git
git init

# Add .gitignore to exclude temp files
cat > .gitignore << 'GITIGNORE'
# Python
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
*.log

# Node
node_modules/
build/
dist/
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Project specific
logs/
workspace/
config/fcc/
config/codex/.tmp/
*.tmp
GITIGNORE

# Add all files
git add .
git commit -m "Initial commit: Claude Code Agent with WebSocket backend"

# Set default branch to main
git branch -M main

# Add remote
git remote add origin https://Daniel536t:GITHUB_TOKEN_PLACEHOLDER@github.com/Daniel536t/Claude-code.git

# Push
git push -u origin main --force

echo ""
echo "✅ Code pushed to GitHub!"
echo "📌 Repo: https://github.com/Daniel536t/Claude-code"
