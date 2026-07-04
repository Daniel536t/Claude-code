#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Provider Speed Test ==="
echo "Testing response times for each provider..."
echo ""

test_model() {
    local name="$1"
    local model="$2"
    echo -n "  $name: "
    start=$(date +%s%N)
    fcc-claude -p "Say 'OK' in 1 word" 2>/dev/null | head -1 > /dev/null
    end=$(date +%s%N)
    diff=$((($end - $start)/1000000))
    echo "${diff}ms"
}

# Test each provider
models=(
    "NVIDIA Kimi K2.6:nvidia_nim/moonshotai/kimi-k2.6"
    "NVIDIA GLM 5.2:nvidia_nim/z-ai/glm-5.2"
    "FreeTheAi DeepSeek:opc/deepseek-v4-flash-free"
    "FreeTheAi Claude:opc/big-pickle"
    "Cloudflare GLM:cloudflare/zai-org/glm-5.2"
    "Sambanova:DeepSeek-V3.2"
)

for entry in "${models[@]}"; do
    IFS=':' read -r name model <<< "$entry"
    echo "Switching to $name..."
    ~/switch_to_model.sh "$model" "$name" > /dev/null 2>&1
    sleep 2
    test_model "$name" "$model"
done

# Switch back to fastest
~/switch_to_model.sh "nvidia_nim/moonshotai/kimi-k2.6" "NVIDIA Kimi K2.6" > /dev/null 2>&1
echo ""
echo "✅ Back to NVIDIA Kimi K2.6 (fastest)"
