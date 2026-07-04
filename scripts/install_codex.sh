#!/bin/bash
echo "=== Installing Codex ==="

# Check if Codex is installed
if command -v codex &> /dev/null; then
    echo "✅ Codex already installed"
    codex --version
else
    echo "Installing Codex..."
    npm install -g @openai/codex
    echo "✅ Codex installed"
fi

# Create Codex config for FCC
mkdir -p ~/.codex

cat > ~/.codex/config.toml << 'CONFIGEOF'
model_provider = "fcc"
model = "nvidia_nim/moonshotai/kimi-k2.6"

[model_providers.fcc]
name = "Free Claude Code"
base_url = "http://127.0.0.1:8082/v1"
env_key = "FCC_CODEX_API_KEY"
wire_api = "responses"
CONFIGEOF

echo "✅ Codex config created"

# Create Codex auth
cat > ~/.codex/auth.json << 'AUTHEOF'
{
  "FCC_CODEX_API_KEY": "freecc"
}
AUTHEOF

echo "✅ Codex auth configured"

# Test Codex
echo ""
echo "Testing Codex..."
fcc-codex exec "Say OK in one word" 2>/dev/null | head -5
