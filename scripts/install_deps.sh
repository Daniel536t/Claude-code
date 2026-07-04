#!/bin/bash
echo "=== Installing Python Dependencies ==="

# Install aiohttp
pip3 install aiohttp --user 2>/dev/null || pip install aiohttp --user

# Verify installation
python3 -c "import aiohttp; print('✅ aiohttp installed successfully')"

echo ""
echo "Testing llm.py now:"
python3 ~/llm.py "Say OK in one word" --fast 2>/dev/null | head -3
