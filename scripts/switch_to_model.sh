#!/bin/bash
# Usage: ~/switch_to_model.sh "model_slug" "description"

if [ -z "$1" ]; then
    echo "Usage: $0 \"model_slug\" \"description\""
    echo ""
    echo "FreeTheAi models:"
    echo "  opc/deepseek-v4-flash-free"
    echo "  opc/big-pickle"
    echo "  vova/claude-opus-4-8"
    echo "  vova/claude-sonnet-4-6"
    echo "  vova/gemini-3.5-flash"
    echo "  vova/glm-5.2"
    echo "  glm/glm-5.2"
    echo "  kai/openrouter/free"
    echo ""
    echo "NVIDIA NIM:"
    echo "  nvidia_nim/moonshotai/kimi-k2.6"
    echo "  nvidia_nim/z-ai/glm-5.2"
    echo "  nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b"
    echo ""
    echo "Cloudflare:"
    echo "  cloudflare/zai-org/glm-5.2"
    exit 1
fi

export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

MODEL="$1"
DESC="${2:-$1}"

echo "🔄 Switching to: $DESC"
echo "📦 Model: $MODEL"

# Backup
mkdir -p ~/.fcc/backups
cp ~/.fcc/.env ~/.fcc/backups/.env.backup.$(date +%Y%m%d_%H%M%S) 2>/dev/null

# Update MODEL with proper escaping (using | as delimiter)
sed -i "s|^MODEL=.*|MODEL=$MODEL|" ~/.fcc/.env

# If it's a FreeTheAi model, also update FTA_MODEL
if [[ $MODEL == opc/* ]] || [[ $MODEL == vova/* ]] || [[ $MODEL == glm/* ]] || [[ $MODEL == bbl/* ]] || [[ $MODEL == kai/* ]] || [[ $MODEL == olm/* ]]; then
    sed -i "s|^FTA_MODEL=.*|FTA_MODEL=$MODEL|" ~/.fcc/.env
    echo "✅ Also set as FTA_MODEL"
fi

# Restart
~/fcc_restart.sh
