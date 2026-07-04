#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   ✅ FINAL WORKING MODELS               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo "⚡ FASTEST (Use these):"
echo "  1) nvidia_nim/moonshotai/kimi-k2.6              (~5.5s) ⚡⚡⚡"
echo "  2) nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b (~5.4s) ⚡⚡"
echo "  3) nvidia_nim/deepseek-ai/deepseek-v4-flash     (~7.4s) ⚡"
echo ""

echo "🐢 SLOW (Avoid unless needed):"
echo "  4) nvidia_nim/z-ai/glm-5.2                      (~15s+) 🐢"
echo "  5) cloudflare/zai-org/glm-5.2                   (~20s+) 🐢"
echo ""

echo "❌ NOT WORKING WITH FCC:"
echo "  - DeepSeek-V3.2 (Sambanova - needs prefix)"
echo "  - vova/* (FreeTheAi internal)"
echo "  - opc/* (FreeTheAi internal)"
echo ""

echo "📌 Quick Commands:"
echo "  ~/switch_model_fast.sh kimi       # Best overall"
echo "  ~/switch_model_fast.sh nemotron   # Also fast"
echo "  ~/switch_model_fast.sh deepseek   # Slower but works"
echo ""
echo "📌 Use Claude:"
echo "  fcc-claude -p 'Your prompt'"
echo "  fcc-claude                        # Interactive"
echo ""
echo "📌 Current model:"
grep "^MODEL=" ~/.fcc/.env | cut -d= -f2
