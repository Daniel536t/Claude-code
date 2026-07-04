#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

case "$1" in
    deepseek|ds)
        MODEL="open_router/opc/deepseek-v4-flash-free"
        DESC="OpenRouter - DeepSeek V4 Flash"
        ;;
    bigpickle|bp)
        MODEL="open_router/opc/big-pickle"
        DESC="OpenRouter - Big Pickle"
        ;;
    mimo|mm)
        MODEL="open_router/opc/mimo-v2.5-free"
        DESC="OpenRouter - Mimo V2.5"
        ;;
    nemotron|nt)
        MODEL="open_router/opc/nemotron-3-ultra-free"
        DESC="OpenRouter - Nemotron 3 Ultra"
        ;;
    north|no)
        MODEL="open_router/opc/north-mini-code-free"
        DESC="OpenRouter - North Mini Code"
        ;;
    vova_opus|vo)
        MODEL="open_router/vova/claude-opus-4-8"
        DESC="OpenRouter - Claude Opus 4.8"
        ;;
    vova_sonnet|vs)
        MODEL="open_router/vova/claude-sonnet-4-6"
        DESC="OpenRouter - Claude Sonnet 4.6"
        ;;
    vova_gemini|vg)
        MODEL="open_router/vova/gemini-3.5-flash"
        DESC="OpenRouter - Gemini 3.5 Flash"
        ;;
    vova_glm|vglm)
        MODEL="open_router/vova/glm-5.2"
        DESC="OpenRouter - GLM 5.2"
        ;;
    list|l)
        echo "Available OpenRouter models:"
        echo "  deepseek   - DeepSeek V4 Flash"
        echo "  bigpickle  - Big Pickle"
        echo "  mimo       - Mimo V2.5"
        echo "  nemotron   - Nemotron 3 Ultra"
        echo "  north      - North Mini Code"
        echo "  vova_opus  - Claude Opus 4.8"
        echo "  vova_sonnet - Claude Sonnet 4.6"
        echo "  vova_gemini - Gemini 3.5 Flash"
        echo "  vova_glm   - GLM 5.2"
        return 0
        ;;
    *)
        echo "Usage: ~/switch_openrouter.sh [deepseek|bigpickle|mimo|nemotron|north|vova_opus|vova_sonnet|vova_gemini|vova_glm|list]"
        echo ""
        echo "  deepseek   - DeepSeek V4 Flash"
        echo "  bigpickle  - Big Pickle"
        echo "  mimo       - Mimo V2.5"
        echo "  nemotron   - Nemotron 3 Ultra"
        echo "  north      - North Mini Code"
        echo "  vova_opus  - Claude Opus 4.8"
        echo "  vova_sonnet - Claude Sonnet 4.6"
        echo "  vova_gemini - Gemini 3.5 Flash"
        echo "  vova_glm   - GLM 5.2"
        echo "  list       - Show all models"
        return 0
        ;;
esac

echo "🔄 Switching to: $DESC"
sed -i "s|^MODEL=.*|MODEL=$MODEL|" ~/.fcc/.env
~/fcc_working.sh > /dev/null 2>&1
echo "✅ Switched to: $DESC"
echo ""
echo "Test: fcc-claude -p 'What model are you?'"
