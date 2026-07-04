#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   Ultimate Working Models               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

echo -e "\033[0;32m⚡ FAST WORKING MODELS:\033[0m"
echo "  1) nvidia_nim/moonshotai/kimi-k2.6        (NVIDIA Kimi - FASTEST)"
echo "  2) nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b (NVIDIA Nemotron)"
echo "  3) nvidia_nim/deepseek-ai/deepseek-v4-flash (NVIDIA DeepSeek)"
echo "  4) DeepSeek-V3.2                          (Sambanova)"
echo ""

echo -e "\033[0;33m🐢 SLOW BUT WORKING:\033[0m"
echo "  5) nvidia_nim/z-ai/glm-5.2               (NVIDIA GLM - 15-45s)"
echo "  6) cloudflare/zai-org/glm-5.2            (Cloudflare - 15-45s)"
echo ""

echo -e "\033[0;31m❌ NOT WORKING:\033[0m"
echo "  - vova/* (FreeTheAi internal)"
echo "  - opc/* (FreeTheAi internal)"
echo "  - glm/* (FreeTheAi internal)"
echo ""

echo -e "\033[0;34mQuick switch commands:\033[0m"
echo "  ~/quick_switch_working.sh kimi"
echo "  ~/quick_switch_working.sh nemotron"
echo "  ~/quick_switch_working.sh deepseek"
echo "  ~/quick_switch_working.sh samba"
