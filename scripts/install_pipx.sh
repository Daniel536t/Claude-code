#!/bin/bash
echo "=== Installing pipx and aiohttp ==="

# Install pipx
sudo apt update
sudo apt install -y pipx
pipx ensurepath

# Install aiohttp using pipx
pipx install aiohttp 2>/dev/null || pipx install --include-deps aiohttp

# Or install in user space with --break-system-packages
python3 -m pip install --user --break-system-packages aiohttp

# Verify
python3 -c "import aiohttp; print('✅ aiohttp installed successfully')" 2>/dev/null || echo "❌ Still not installed"

echo ""
echo "Testing llm.py:"
python3 ~/llm.py "Say OK" --fast 2>/dev/null | head -3
