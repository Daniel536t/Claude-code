#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Debugging Codex ==="
echo ""

echo "1️⃣ Check Codex installation:"
which codex
codex --version 2>&1

echo ""
echo "2️⃣ Check Codex config:"
cat ~/.codex/config.toml 2>/dev/null || echo "No config found"

echo ""
echo "3️⃣ Check Codex auth:"
cat ~/.codex/auth.json 2>/dev/null || echo "No auth found"

echo ""
echo "4️⃣ Test Codex with simple command:"
timeout 10 codex exec "Say OK" 2>&1 | head -10

echo ""
echo "5️⃣ Test fcc-codex launcher:"
timeout 10 fcc-codex exec "Say OK" 2>&1 | head -10

echo ""
echo "6️⃣ Check FCC proxy Codex endpoint:"
curl -s -X POST http://localhost:8082/v1/responses \
  -H "Content-Type: application/json" \
  -d '{"model":"nvidia_nim/moonshotai/kimi-k2.6","input":"Say OK"}' 2>&1 | head -10

echo ""
echo "7️⃣ Check FCC logs:"
tail -20 ~/fcc_logs/fcc.log
