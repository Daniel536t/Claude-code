#!/bin/bash
echo "=== Cleaning Up Stray Files ==="

# Files to move to claude-agent
files_to_move=(
    "agent_server.py"
    "discord_bot_advanced.py"
    "test_discord_standalone.py"
)

for file in "${files_to_move[@]}"; do
    if [ -f ~/$file ]; then
        mv ~/$file ~/claude-agent/backend/ 2>/dev/null
        echo "✅ Moved: $file"
    fi
done

# Files that are scripts - move to scripts
for file in ~/*.sh; do
    if [ -f "$file" ] && [ "$file" != "~/hunter"* ] && [ "$file" != "~/ember"* ] && [ "$file" != "~/virus"* ]; then
        mv "$file" ~/claude-agent/scripts/ 2>/dev/null
        echo "✅ Moved script: $(basename $file)"
    fi
done

# Move workspace
if [ -d ~/fcc_workspace ] && [ ! -L ~/claude-agent/workspace ]; then
    mv ~/fcc_workspace/* ~/claude-agent/workspace/ 2>/dev/null
    echo "✅ Moved workspace files"
fi

# Move logs
if [ -f ~/discord_bot.log ]; then
    mv ~/discord_bot.log ~/claude-agent/logs/discord.log 2>/dev/null
    echo "✅ Moved discord log"
fi

if [ -f ~/agent_server.log ]; then
    mv ~/agent_server.log ~/claude-agent/logs/agent.log 2>/dev/null
    echo "✅ Moved agent log"
fi

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📁 Project structure:"
tree ~/claude-agent -L 2 2>/dev/null || ls -la ~/claude-agent/
