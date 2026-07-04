#!/bin/bash
echo "╔══════════════════════════════════════════╗"
echo "║   FCC Working Commands                  ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "📌 Use Claude Code:"
echo "  fcc-claude -p \"Your prompt\""
echo "  fcc-claude                     # Interactive mode"
echo ""

echo "📌 Switch models:"
echo "  ~/switch_to_model.sh \"nvidia_nim/moonshotai/kimi-k2.6\" \"Kimi Fastest\""
echo "  ~/switch_to_model.sh \"nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b\" \"Nemotron\""
echo "  ~/switch_to_model.sh \"DeepSeek-V3.2\" \"Sambanova\""
echo ""

echo "📌 Fastest models (all tested working):"
echo "  1. nvidia_nim/moonshotai/kimi-k2.6              (2s) ⚡"
echo "  2. DeepSeek-V3.2                                (1s) ⚡"
echo "  3. nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b (1.3s) ⚡"
echo "  4. nvidia_nim/deepseek-ai/deepseek-v4-flash     (15s) 🐢"
echo ""

echo "📌 Restart FCC:"
echo "  ~/fcc_working.sh"
echo ""

echo "📌 Check status:"
echo "  curl -s http://localhost:8082/health"
echo "  pgrep -f fcc-server"
echo ""

echo "📌 View logs:"
echo "  tail -f ~/fcc_logs/fcc.log"
