#!/bin/bash
echo "=== Setting up Virtual Environment ==="

# Create virtual environment
cd ~
python3 -m venv llm_venv

# Activate and install dependencies
source ~/llm_venv/bin/activate
pip install aiohttp

# Create launcher script
cat > ~/llm_launch.sh << 'LAUNCHER'
#!/bin/bash
source ~/llm_venv/bin/activate
python3 ~/llm.py "$@"
LAUNCHER

chmod +x ~/llm_launch.sh

echo "✅ Virtual environment created"
echo "✅ aiohttp installed"
echo ""

# Test
~/llm_launch.sh "Say OK" --fast 2>/dev/null | head -3
