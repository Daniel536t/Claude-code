#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing FCC Proxy with Working Models ==="
echo ""

# Function to test FCC with model
test_fcc_model() {
    local name="$1"
    local model="$2"
    
    echo -e "\033[0;34mTesting: $name\033[0m"
    echo -n "  Model: $model"
    
    # Update config
    sed -i "s|^MODEL=.*|MODEL=$model|" ~/.fcc/.env
    ~/fcc_restart.sh > /dev/null 2>&1
    sleep 2
    
    start=$(date +%s%N)
    response=$(timeout 15 fcc-claude -p "Say OK in one word" 2>/dev/null)
    end=$(date +%s%N)
    duration=$((($end - $start)/1000000))
    
    if [ -n "$response" ]; then
        echo -e " \033[0;32m✅ $duration ms\033[0m"
        echo "  Response: $(echo "$response" | head -c 100)"
    else
        echo -e " \033[0;31m❌ Failed/Timeout\033[0m"
    fi
    echo ""
}

# Test only models that worked in direct tests
test_fcc_model "Kimi K2.6" "nvidia_nim/moonshotai/kimi-k2.6"
test_fcc_model "Nemotron 3 Ultra" "nvidia_nim/nvidia/nemotron-3-ultra-550b-a55b"
test_fcc_model "DeepSeek V4" "nvidia_nim/deepseek-ai/deepseek-v4-flash"
test_fcc_model "DeepSeek V3.2" "DeepSeek-V3.2"

# Switch back to fastest
sed -i 's|^MODEL=.*|MODEL=nvidia_nim/moonshotai/kimi-k2.6|' ~/.fcc/.env
~/fcc_restart.sh > /dev/null 2>&1
echo -e "\033[0;32m✅ Back to fastest: Kimi K2.6\033[0m"
