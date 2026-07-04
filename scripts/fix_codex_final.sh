#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Fixing Codex ==="

# Kill any stuck processes
pkill -f codex 2>/dev/null
pkill -f fcc-codex 2>/dev/null

# Create working alias/script
cat > ~/codex_work.sh << 'CODEXEOF'
#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
export FCC_CODEX_API_KEY="freecc"

# Use Codex with skip flag and proper config
codex \
  --skip-git-repo-check \
  -c 'model_provider="fcc"' \
  -c 'model_providers.fcc.name="Free Claude Code"' \
  -c 'model_providers.fcc.base_url="http://127.0.0.1:8082/v1"' \
  -c 'model_providers.fcc.env_key="FCC_CODEX_API_KEY"' \
  -c 'model_providers.fcc.wire_api="responses"' \
  "$@"
CODEXEOF

chmod +x ~/codex_work.sh

echo "✅ Codex wrapper created: ~/codex_work.sh"

# Test it
echo ""
echo "Testing Codex:"
~/codex_work.sh exec "Say OK" 2>&1 | head -5
