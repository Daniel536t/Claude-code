#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

CONFIG=~/.fcc/.env

# Fast models list
declare -A MODELS
MODELS["kimi"]="nvidia_nim/moonshotai/kimi-k2.6|NVIDIA Kimi K2.6 ⚡ (2s)"
MODELS["nemotron"]="nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b|NVIDIA Nemotron 3 Ultra ⚡ (1.3s)"
MODELS["deepseek"]="nvidia_nim/deepseek-ai/deepseek-v4-flash|NVIDIA DeepSeek V4 🐢 (15s)"
MODELS["samba"]="DeepSeek-V3.2|Sambanova DeepSeek V3.2 ⚡ (1s)"
MODELS["glm"]="nvidia_nim/z-ai/glm-5.2|NVIDIA GLM 5.2 🐢 (slow)"
MODELS["cloudflare"]="cloudflare/zai-org/glm-5.2|Cloudflare GLM 5.2 🐢 (slow)"

if [ -z "$1" ]; then
    echo "Usage: $0 [kimi|nemotron|deepseek|samba|glm|cloudflare]"
    echo ""
    echo "Available models:"
    for key in "${!MODELS[@]}"; do
        IFS='|' read -r model desc <<< "${MODELS[$key]}"
        echo "  $key → $desc"
    done
    echo ""
    echo "Current: $(grep "^MODEL=" $CONFIG | cut -d= -f2)"
    exit 1
fi

if [ -z "${MODELS[$1]}" ]; then
    echo "❌ Unknown model: $1"
    exit 1
fi

IFS='|' read -r model desc <<< "${MODELS[$1]}"
echo "🔄 Switching to: $desc"
echo "📦 Model: $model"

sed -i "s|^MODEL=.*|MODEL=$model|" $CONFIG

# If it's a FreeTheAi model, also update FTA_MODEL
if [[ $model == vova/* ]] || [[ $model == opc/* ]] || [[ $model == glm/* ]]; then
    sed -i "s|^FTA_MODEL=.*|FTA_MODEL=$model|" $CONFIG
fi

~/fcc_working.sh > /dev/null 2>&1
echo "✅ Switched to: $desc"
echo ""
echo "Test with: fcc-claude -p 'What model are you?'"
