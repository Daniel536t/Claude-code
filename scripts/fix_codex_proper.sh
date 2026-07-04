#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Fixing Codex Properly ==="

# Kill any stuck processes
pkill -f codex 2>/dev/null
pkill -f fcc-codex 2>/dev/null

# Recreate Codex directory
mkdir -p ~/.codex

# Create proper config.toml
cat > ~/.codex/config.toml << 'CONFIGEOF'
model_provider = "fcc"
model = "nvidia_nim/moonshotai/kimi-k2.6"

[model_providers.fcc]
name = "Free Claude Code"
base_url = "http://127.0.0.1:8082/v1"
env_key = "FCC_CODEX_API_KEY"
wire_api = "responses"
CONFIGEOF

# Create auth.json
cat > ~/.codex/auth.json << 'AUTHEOF'
{
  "FCC_CODEX_API_KEY": "freecc"
}
AUTHEOF

echo "✅ Config files created"

# Ensure FCC_CODEX_API_KEY is set in environment
export FCC_CODEX_API_KEY="freecc"

echo ""
echo "Testing Codex directly (not through FCC launcher):"
cd ~
timeout 10 codex exec "Say OK" 2>&1 | head -5

echo ""
echo "Testing through fcc-codex launcher:"
timeout 10 fcc-codex exec "Say OK" 2>&1 | head -5
