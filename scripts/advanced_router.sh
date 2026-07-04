#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

CONFIG=~/.fcc/.env

echo "╔══════════════════════════════════════════╗"
echo "║   Advanced Model Tier Router            ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Current configuration:"
echo "  MODEL       : $(grep "^MODEL=" $CONFIG | cut -d= -f2)"
echo "  MODEL_OPUS  : $(grep "^MODEL_OPUS=" $CONFIG | cut -d= -f2)"
echo "  MODEL_SONNET: $(grep "^MODEL_SONNET=" $CONFIG | cut -d= -f2)"
echo "  MODEL_HAIKU : $(grep "^MODEL_HAIKU=" $CONFIG | cut -d= -f2)"
echo ""
echo "Select a preset:"
echo "  1) All NVIDIA NIM (Fastest)"
echo "  2) All FreeTheAi (Community)"
echo "  3) Mixed: Opus→Claude, Sonnet→Gemini, Haiku→DeepSeek"
echo "  4) Mixed: Opus→GLM, Sonnet→Nemotron, Haiku→Kimi"
echo "  5) Custom: Cloudflare for all"
echo "  6) Custom: Sambanova for all"
echo "  0) Exit"
echo ""
read -p "Enter choice: " choice

case $choice in
    1)
        echo "Setting all tiers to NVIDIA NIM..."
        sed -i "s|^MODEL=.*|MODEL=nvidia_nim/moonshotai/kimi-k2.6|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=nvidia_nim/z-ai/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=nvidia_nim/deepseek-ai/deepseek-v4-flash|" $CONFIG
        ;;
    2)
        echo "Setting all tiers to FreeTheAi..."
        sed -i "s|^MODEL=.*|MODEL=vova/claude-opus-4-8|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=vova/claude-opus-4-8|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=vova/claude-sonnet-4-6|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=vova/gemini-3.5-flash|" $CONFIG
        ;;
    3)
        echo "Mixed: Opus→Claude, Sonnet→Gemini, Haiku→DeepSeek..."
        sed -i "s|^MODEL=.*|MODEL=vova/claude-opus-4-8|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=vova/claude-opus-4-8|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=vova/gemini-3.5-flash|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=opc/deepseek-v4-flash-free|" $CONFIG
        ;;
    4)
        echo "Mixed: Opus→GLM, Sonnet→Nemotron, Haiku→Kimi..."
        sed -i "s|^MODEL=.*|MODEL=nvidia_nim/z-ai/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=nvidia_nim/z-ai/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=nvidia_nim/moonshotai/kimi-k2.6|" $CONFIG
        ;;
    5)
        echo "Setting all tiers to Cloudflare GLM 5.2..."
        sed -i "s|^MODEL=.*|MODEL=cloudflare/zai-org/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=cloudflare/zai-org/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=cloudflare/zai-org/glm-5.2|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=cloudflare/zai-org/glm-5.2|" $CONFIG
        ;;
    6)
        echo "Setting all tiers to Sambanova DeepSeek..."
        sed -i "s|^MODEL=.*|MODEL=DeepSeek-V3.2|" $CONFIG
        sed -i "s|^MODEL_OPUS=.*|MODEL_OPUS=DeepSeek-V3.2|" $CONFIG
        sed -i "s|^MODEL_SONNET=.*|MODEL_SONNET=DeepSeek-V3.2|" $CONFIG
        sed -i "s|^MODEL_HAIKU=.*|MODEL_HAIKU=DeepSeek-V3.2|" $CONFIG
        ;;
    0)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "✅ Configuration updated!"
echo ""
echo "New configuration:"
echo "  MODEL       : $(grep "^MODEL=" $CONFIG | cut -d= -f2)"
echo "  MODEL_OPUS  : $(grep "^MODEL_OPUS=" $CONFIG | cut -d= -f2)"
echo "  MODEL_SONNET: $(grep "^MODEL_SONNET=" $CONFIG | cut -d= -f2)"
echo "  MODEL_HAIKU : $(grep "^MODEL_HAIKU=" $CONFIG | cut -d= -f2)"
echo ""
read -p "Restart proxy now? (y/n): " restart
if [[ $restart == "y" || $restart == "Y" ]]; then
    ~/fcc_restart.sh
fi
