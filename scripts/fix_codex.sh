#!/bin/bash
echo "=== Fixing Codex ==="

# Kill any stuck codex processes
pkill -f codex 2>/dev/null

# Recreate Codex config
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

cat > ~/.codex/auth.json << 'AUTHEOF'
{
  "FCC_CODEX_API_KEY": "freecc"
}
AUTHEOF

echo "✅ Codex config recreated"

# Test
echo ""
echo "Testing Codex:"
fcc-codex exec "Say OK" 2>/dev/null | head -3

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Codex is working!"
else
    echo ""
    echo "❌ Codex still failing. Check logs:"
    tail -20 ~/fcc_logs/fcc.log
fi
