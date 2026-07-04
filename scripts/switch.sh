#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

case "$1" in
    kimi|fast|1)
        sed -i 's|^MODEL=.*|MODEL=nvidia_nim/moonshotai/kimi-k2.6|' ~/.fcc/.env
        echo "✅ Kimi K2.6 (fastest) ⚡⚡⚡"
        ;;
    nemotron|2)
        sed -i 's|^MODEL=.*|MODEL=nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b|' ~/.fcc/.env
        echo "✅ Nemotron 3 Ultra ⚡⚡"
        ;;
    deepseek|3)
        sed -i 's|^MODEL=.*|MODEL=nvidia_nim/deepseek-ai/deepseek-v4-flash|' ~/.fcc/.env
        echo "✅ DeepSeek V4 Flash ⚡"
        ;;
    deepseek-pro|4)
        sed -i 's|^MODEL=.*|MODEL=nvidia_nim/deepseek-ai/deepseek-v4-pro|' ~/.fcc/.env
        echo "✅ DeepSeek V4 Pro ⚡⚡ (NEW!)"
        ;;
    glm|5)
        sed -i 's|^MODEL=.*|MODEL=nvidia_nim/z-ai/glm-5.2|' ~/.fcc/.env
        echo "⚠️  GLM 5.2 (slow - 15s+) 🐢"
        ;;
    cloudflare|cf|6)
        sed -i 's|^MODEL=.*|MODEL=cloudflare/zai-org/glm-5.2|' ~/.fcc/.env
        echo "⚠️  Cloudflare GLM (slow - 20s+) 🐢"
        ;;
    status|s)
        echo "Current: $(grep "^MODEL=" ~/.fcc/.env | cut -d= -f2)"
        echo "Proxy: $(pgrep -f fcc-server > /dev/null && echo "✅ Running" || echo "❌ Stopped")"
        ;;
    list|l)
        echo "Available models:"
        echo "  kimi         - Kimi K2.6 (fastest) ⚡⚡⚡"
        echo "  nemotron     - Nemotron 3 Ultra ⚡⚡"
        echo "  deepseek     - DeepSeek V4 Flash ⚡"
        echo "  deepseek-pro - DeepSeek V4 Pro ⚡⚡ (NEW!)"
        echo "  glm          - GLM 5.2 (slow) 🐢"
        echo "  cloudflare   - Cloudflare GLM (slow) 🐢"
        echo "  status       - Show current model"
        ;;
    *)
        echo "Usage: ~/switch.sh [kimi|nemotron|deepseek|deepseek-pro|glm|cloudflare|status|list]"
        echo ""
        echo "  kimi         - Kimi K2.6 (fastest) ⚡⚡⚡"
        echo "  nemotron     - Nemotron 3 Ultra ⚡⚡"
        echo "  deepseek     - DeepSeek V4 Flash ⚡"
        echo "  deepseek-pro - DeepSeek V4 Pro ⚡⚡ (NEW!)"
        echo "  glm          - GLM 5.2 (slow) 🐢"
        echo "  cloudflare   - Cloudflare GLM (slow) 🐢"
        echo "  status       - Show current model"
        return 0
        ;;
esac

# Restart proxy
~/fcc_working.sh > /dev/null 2>&1
echo "✅ Proxy restarted"
echo ""
echo "Test: fcc-claude -p 'Hello'"
