#!/bin/bash
echo "=== Complete Setup ==="

# 1. Install pipx and aiohttp
~/setup_venv.sh

# 2. Fix FCC
~/fix_fcc_clean.sh

# 3. Test everything
~/final_working_test.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "📌 Commands:"
echo "  fcc-claude -p 'prompt'     # Claude Code"
echo "  ~/llm_launch.sh 'prompt'   # Full fallback"
echo "  ~/llm_launch.sh --fast     # Fastest only"
echo "  ~/switch.sh kimi           # Switch to fastest"
echo "  ~/status.sh                # Check status"
