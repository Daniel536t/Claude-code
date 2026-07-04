#!/bin/bash
echo "=== Cleaning Up Home Directory ==="

# Move all scripts to claude-agent/scripts
for file in ~/*.sh; do
    if [ -f "$file" ] && [ "$file" != "~/hunter"* ] && [ "$file" != "~/ember"* ] && [ "$file" != "~/virus"* ]; then
        basename=$(basename "$file")
        mv "$file" ~/claude-agent/scripts/ 2>/dev/null
        echo "✅ Moved: $basename"
    fi
done

# Move Python files
for file in ~/*.py; do
    if [ -f "$file" ] && [ "$file" != "~/hunter"* ] && [ "$file" != "~/ember"* ]; then
        basename=$(basename "$file")
        mv "$file" ~/claude-agent/ 2>/dev/null
        echo "✅ Moved: $basename"
    fi
done

# Remove empty directories (keep hunter, ember, virus)
rm -rf ~/fcc_workspace 2>/dev/null
rm -rf ~/llm_venv 2>/dev/null

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "📌 Remaining files in home:"
ls -la ~/ | grep -v "claude-agent\|hunter\|ember\|virus\|\.bash"
