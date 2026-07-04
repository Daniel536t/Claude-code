#!/bin/bash
echo "=== Fixing FCC Codex Endpoint ==="

# The 401 error means the /v1/responses endpoint needs auth
# Let's test with proper authentication

echo "1️⃣ Test with auth token:"
curl -s -X POST http://localhost:8082/v1/responses \
  -H "Authorization: Bearer freecc" \
  -H "Content-Type: application/json" \
  -d '{"model":"nvidia_nim/moonshotai/kimi-k2.6","input":"Say OK"}' 2>&1 | head -20

echo ""
echo "2️⃣ Check if auth token is correct:"
grep "^ANTHROPIC_AUTH_TOKEN=" ~/.fcc/.env

echo ""
echo "3️⃣ Check FCC config for Codex:"
grep -i "codex\|responses" ~/.fcc/.env 2>/dev/null || echo "No Codex-specific config"
