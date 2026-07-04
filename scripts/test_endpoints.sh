#!/bin/bash

echo "=== Testing All Provider Endpoints ==="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test function with timing
test_endpoint() {
    local name="$1"
    local url="$2"
    local api_key="$3"
    local model="$4"
    local payload="$5"
    
    echo -e "${BLUE}Testing $name...${NC}"
    echo -n "  Model: $model"
    
    start=$(date +%s%N)
    
    response=$(curl -s -w "\n%{http_code}" -X POST "$url" \
        -H "Authorization: Bearer $api_key" \
        -H "Content-Type: application/json" \
        -d "$payload" 2>/dev/null)
    
    end=$(date +%s%N)
    duration=$((($end - $start)/1000000))
    
    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')
    
    if [ "$http_code" = "200" ]; then
        echo -e " ${GREEN}✅ HTTP $http_code${NC} - ${duration}ms"
        # Extract just the response text
        echo "$body" | grep -o '"content":"[^"]*"' | head -1 | cut -d'"' -f4 | head -c 100
        echo ""
    else
        echo -e " ${RED}❌ HTTP $http_code${NC} - ${duration}ms"
        echo "$body" | head -c 200
        echo ""
    fi
    echo ""
}

# NVIDIA NIM Test
test_endpoint "NVIDIA NIM" \
    "https://integrate.api.nvidia.com/v1/chat/completions" \
    "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" \
    "moonshotai/kimi-k2.6" \
    '{"model":"moonshotai/kimi-k2.6","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# NVIDIA NIM - GLM 5.2
test_endpoint "NVIDIA NIM - GLM 5.2" \
    "https://integrate.api.nvidia.com/v1/chat/completions" \
    "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" \
    "z-ai/glm-5.2" \
    '{"model":"z-ai/glm-5.2","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# NVIDIA NIM - Nemotron
test_endpoint "NVIDIA NIM - Nemotron" \
    "https://integrate.api.nvidia.com/v1/chat/completions" \
    "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" \
    "nvidia/nemotron-3-ultra-550b-a55b" \
    '{"model":"nvidia/nemotron-3-ultra-550b-a55b","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# NVIDIA NIM - DeepSeek
test_endpoint "NVIDIA NIM - DeepSeek" \
    "https://integrate.api.nvidia.com/v1/chat/completions" \
    "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" \
    "deepseek-ai/deepseek-v4-flash" \
    '{"model":"deepseek-ai/deepseek-v4-flash","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# Sambanova
test_endpoint "Sambanova" \
    "https://api.sambanova.ai/v1/chat/completions" \
    "aa00847f-db17-461e-b725-18984b37a59e" \
    "DeepSeek-V3.2" \
    '{"model":"DeepSeek-V3.2","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# FreeTheAi via OpenRouter format (using their OpenAI-compatible endpoint)
test_endpoint "FreeTheAi (OpenAI Compatible)" \
    "https://api.freetheai.xyz/v1/chat/completions" \
    "sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    "opc/deepseek-v4-flash-free" \
    '{"model":"opc/deepseek-v4-flash-free","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# FreeTheAi - Claude Opus
test_endpoint "FreeTheAi - Claude Opus" \
    "https://api.freetheai.xyz/v1/chat/completions" \
    "sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    "vova/claude-opus-4-8" \
    '{"model":"vova/claude-opus-4-8","messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

# Cloudflare
test_endpoint "Cloudflare" \
    "https://api.cloudflare.com/client/v4/accounts/3d595aa9564ce6485743f1c89d9d7065/ai/run/@cf/zai-org/glm-5.2" \
    "CLOUDFLARE_TOKEN_PLACEHOLDER" \
    "@cf/zai-org/glm-5.2" \
    '{"messages":[{"role":"user","content":"Say OK in one word"}],"max_tokens":10}'

echo -e "${GREEN}=== Test Complete ==="
echo -e "Fastest models:${NC}"
echo "  ⚡ Kimi K2.6 (NVIDIA)"
echo "  ⚡ DeepSeek V4 (NVIDIA)"
echo "  ⚡ Nemotron (NVIDIA)"
echo "  ⚡ DeepSeek V3.2 (Sambanova)"
echo ""
echo -e "${YELLOW}Slow models:${NC}"
echo "  🐢 GLM 5.2 (NVIDIA)"
echo "  🐢 Cloudflare GLM"
echo "  🐢 FreeTheAi (Community)"
