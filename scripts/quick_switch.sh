#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

case "$1" in
    kimi|nim|default)
        ~/switch_to_model.sh "nvidia_nim/moonshotai/kimi-k2.6" "NVIDIA Kimi K2.6"
        ;;
    glm52|glm)
        ~/switch_to_model.sh "nvidia_nim/z-ai/glm-5.2" "NVIDIA GLM 5.2"
        ;;
    nemotron)
        ~/switch_to_model.sh "nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b" "NVIDIA Nemotron"
        ;;
    fta|free)
        ~/switch_to_model.sh "opc/deepseek-v4-flash-free" "FreeTheAi DeepSeek"
        ;;
    fta_opus)
        ~/switch_to_model.sh "vova/claude-opus-4-8" "FreeTheAi Claude Opus"
        ;;
    fta_gemini)
        ~/switch_to_model.sh "vova/gemini-3.5-flash" "FreeTheAi Gemini"
        ;;
    cloudflare|cf)
        ~/switch_to_model.sh "cloudflare/zai-org/glm-5.2" "Cloudflare GLM 5.2"
        ;;
    samba|sn)
        ~/switch_to_model.sh "DeepSeek-V3.2" "Sambanova DeepSeek"
        ;;
    *)
        echo "Usage: $0 [kimi|glm52|nemotron|fta|fta_opus|fta_gemini|cloudflare|samba]"
        echo ""
        echo "Examples:"
        echo "  $0 kimi          # NVIDIA Kimi K2.6 (fastest)"
        echo "  $0 glm52         # NVIDIA GLM 5.2"
        echo "  $0 fta           # FreeTheAi DeepSeek"
        echo "  $0 fta_opus      # FreeTheAi Claude Opus 4.8"
        echo "  $0 cloudflare    # Cloudflare GLM 5.2"
        echo "  $0 samba         # Sambanova DeepSeek"
        ;;
esac
