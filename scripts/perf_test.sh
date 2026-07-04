#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Performance Test ==="
echo "Testing each model's speed..."
echo ""

test_speed() {
    local name="$1"
    local model="$2"
    
    echo -n "Testing $name... "
    sed -i "s|^MODEL=.*|MODEL=$model|" ~/.fcc/.env
    ~/fcc_working.sh > /dev/null 2>&1
    sleep 2
    
    start=$(date +%s%N)
    response=$(timeout 20 fcc-claude -p "Say OK" 2>/dev/null)
    end=$(date +%s%N)
    duration=$((($end - $start)/1000000))
    
    if [ -n "$response" ]; then
        echo "✅ ${duration}ms"
    else
        echo "❌ Timeout"
    fi
}

test_speed "Kimi K2.6" "nvidia_nim/moonshotai/kimi-k2.6"
test_speed "Sambanova" "DeepSeek-V3.2"
test_speed "Nemotron" "nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b"
test_speed "DeepSeek V4" "nvidia_nim/deepseek-ai/deepseek-v4-flash"

# Back to fastest
sed -i 's|^MODEL=.*|MODEL=nvidia_nim/moonshotai/kimi-k2.6|' ~/.fcc/.env
~/fcc_working.sh > /dev/null 2>&1
echo ""
echo "✅ Back to Kimi K2.6 (fastest)"
