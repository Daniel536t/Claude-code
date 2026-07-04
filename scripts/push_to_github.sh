#!/bin/bash
echo "=== Pushing to GitHub ==="

cd ~/claude-agent

# Initialize git if not already done
if [ ! -d .git ]; then
    git init
fi

# Add all files
git add .
git commit -m "Initial commit: Claude Code Agent with WebSocket backend"

# Add remote with your token
git remote add origin https://Daniel536t:GITHUB_TOKEN_PLACEHOLDER@github.com/Daniel536t/Claude-code.git

# Push to main branch
git branch -M main
git push -u origin main

echo ""
echo "✅ Code pushed to GitHub!"
echo "📌 Repo: https://github.com/Daniel536t/Claude-code"
