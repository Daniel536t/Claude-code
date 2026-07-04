#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

CONFIG=~/.fcc/.env

echo "╔══════════════════════════════════════════╗"
echo "║   Working Model Selector                ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Current: $(grep "^MODEL=" $CONFIG | cut -d= -f2)"
echo ""

echo "┌── NVIDIA NIM ──────────────────────────┐"
echo "  1) nvidia_nim/moonshotai/kimi-k2.6     (Fastest)"
echo "  2) nvidia_nim/z-ai/glm-5.2"
echo "  3) nvidia_nim/nvidia/nemotron-3-ultra"
echo "  4) nvidia_nim/deepseek-ai/deepseek-v4"
echo ""
echo "├── Cloudflare ──────────────────────────┤"
echo "  5) cloudflare/zai-org/glm-5.2"
echo ""
echo "├── OpenRouter (FreeTheAi via OpenRouter)┤"
echo "  6) open_router/opc/deepseek-v4-flash-free"
echo "  7) open_router/opc/big-pickle"
echo "  8) open_router/opc/mimo-v2.5-free"
echo ""
echo "├── Sambanova ───────────────────────────┤"
echo "  9) DeepSeek-V3.2"
echo " 10) Meta-Llama-3.3-70B-Instruct"
echo " 11) gemma-4-31B-it"
echo ""
echo "  0) Exit"
echo "  r) Restart proxy"
echo ""
read -p "Select model: " choice

case $choice in
    1) MODEL="nvidia_nim/moonshotai/kimi-k2.6" ;;
    2) MODEL="nvidia_nim/z-ai/glm-5.2" ;;
    3) MODEL="nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b" ;;
    4) MODEL="nvidia_nim/deepseek-ai/deepseek-v4-flash" ;;
    5) MODEL="cloudflare/zai-org/glm-5.2" ;;
    6) MODEL="open_router/opc/deepseek-v4-flash-free" ;;
    7) MODEL="open_router/opc/big-pickle" ;;
    8) MODEL="open_router/opc/mimo-v2.5-free" ;;
    9) MODEL="DeepSeek-V3.2" ;;
    10) MODEL="Meta-Llama-3.3-70B-Instruct" ;;
    11) MODEL="gemma-4-31B-it" ;;
    0) exit 0 ;;
    r) ~/fcc_restart.sh; exit 0 ;;
    *) echo "Invalid"; exit 1 ;;
esac

# Update config
sed -i "s|^MODEL=.*|MODEL=$MODEL|" $CONFIG
echo "✅ Switched to: $MODEL"
read -p "Restart proxy? (y/n): " restart
if [[ $restart == "y" ]]; then
    ~/fcc_restart.sh
fi
