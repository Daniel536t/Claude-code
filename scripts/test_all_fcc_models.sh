#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing All FCC Working Models ==="
echo ""

test_model() {
    local name="$1"
    local model="$2"
    
    echo -n "Testing $name... "
    sed -i "s|^MODEL=.*|MODEL=$model|" ~/.fcc/.env
    ~/fcc_working.sh > /dev/null 2>&1
    sleep 2
    
    start=$(date +%s%N)
    response=$(timeout 15 fcc-claude -p "Say OK in one word" 2>/dev/null)
    end=$(date +%s%N)
    duration=$((($end - $start)/1000000))
    
    if [ -n "$response" ]; then
        echo "✅ ${duration}ms - $response"
    else
        echo "❌ Failed/Timeout"
    fi
}

test_model "Kimi K2.6" "nvidia_nim/moonshotai/kimi-k2.6"
test_model "Nemotron" "nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b"
test_model "DeepSeek V4 Flash" "nvidia_nim/deepseek-ai/deepseek-v4-flash"
test_model "DeepSeek V4 Pro" "nvidia_nim/deepseek-ai/deepseek-v4-pro"
test_model "GLM 5.2" "nvidia_nim/z-ai/glm-5.2"

# Back to fastest
~/switch.sh kimi > /dev/null 2>&1
echo ""
echo "✅ Back to Kimi K2.6"
