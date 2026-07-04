#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Debugging FCC ==="
echo ""

echo "1️⃣ Check FCC process:"
pgrep -la fcc-server || echo "No FCC process running"
echo ""

echo "2️⃣ Check config:"
echo "  MODEL: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
echo "  MODEL_OPUS: $(grep "^MODEL_OPUS=" ~/.fcc/.env | cut -d= -f2)"
echo "  MODEL_SONNET: $(grep "^MODEL_SONNET=" ~/.fcc/.env | cut -d= -f2)"
echo "  MODEL_HAIKU: $(grep "^MODEL_HAIKU=" ~/.fcc/.env | cut -d= -f2)"
echo ""

echo "3️⃣ Check logs (last 10):"
tail -10 ~/fcc_logs/fcc.log 2>/dev/null || echo "No logs"
echo ""

echo "4️⃣ Test health endpoint:"
curl -s -w "\nHTTP: %{http_code}\n" http://localhost:8082/health || echo "❌ Health endpoint failed"
echo ""

echo "5️⃣ Test models endpoint:"
curl -s http://localhost:8082/v1/models | python3 -m json.tool 2>/dev/null | head -20 || echo "❌ Models endpoint failed"
echo ""

echo "6️⃣ Test FCC with simple prompt:"
timeout 10 fcc-claude -p "Hi" 2>&1 | head -5
