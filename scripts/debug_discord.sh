#!/bin/bash
echo "=== Debugging Discord Bot ==="
echo ""

echo "1️⃣ Check FCC process:"
pgrep -f fcc-server && echo "✅ FCC Running" || echo "❌ FCC Not Running"

echo ""
echo "2️⃣ Check Discord config in FCC:"
grep -E "DISCORD|MESSAGING" ~/.fcc/.env || echo "❌ No Discord config found"

echo ""
echo "3️⃣ Check if Discord bot initialized:"
grep -i "discord\|messaging" ~/fcc_logs/fcc.log | tail -10 || echo "No Discord logs found"

echo ""
echo "4️⃣ Check for errors:"
grep -i "error\|fail" ~/fcc_logs/fcc.log | tail -5 || echo "No errors"

echo ""
echo "5️⃣ Check full FCC log:"
tail -20 ~/fcc_logs/fcc.log
