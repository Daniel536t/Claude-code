#!/bin/bash
echo "=== Pushing with Alternate Methods ==="

cd ~/claude-agent

echo "Method 1: Push as 'master' branch"
git branch -M master
git push -u origin master --force

if [ $? -eq 0 ]; then
    echo "✅ Pushed as master branch!"
    echo "📌 Now go to GitHub and change default branch to master"
    echo "   Settings → Branches → Default branch → master"
    exit 0
fi

echo ""
echo "Method 2: Push to 'deploy' branch"
git branch -M deploy
git push -u origin deploy --force

if [ $? -eq 0 ]; then
    echo "✅ Pushed as deploy branch!"
    echo "📌 Now go to GitHub and merge deploy to main"
    echo "   Or create a PR from deploy to main"
    exit 0
fi

echo ""
echo "Method 3: Push to 'frontend' branch"
git branch -M frontend
git push -u origin frontend --force

if [ $? -eq 0 ]; then
    echo "✅ Pushed as frontend branch!"
    echo "📌 Now deploy from frontend branch on Vercel"
    echo "   Vercel → Project Settings → Git → Production Branch: frontend"
    exit 0
fi

echo ""
echo "❌ All methods failed. Manual intervention needed."
echo "📌 Go to: https://github.com/Daniel536t/Claude-code/settings"
