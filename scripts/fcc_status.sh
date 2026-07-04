#!/bin/bash
export PATH="$HOME/.local/bin:$PATH"

echo "=== 🔍 FCC Status ==="
echo ""
echo "Process:"
pgrep -la fcc-server || echo "❌ Not running"
echo ""
echo "Last 10 log lines:"
tail -10 ~/fcc_logs/fcc.log 2>/dev/null || echo "No logs"
echo ""
echo "Config:"
grep "^MODEL=" ~/.fcc/.env || echo "No config"
