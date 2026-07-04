#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

# Test DeepSeek V4 Pro
echo "Testing NVIDIA DeepSeek V4 Pro..."
curl -s -X POST https://integrate.api.nvidia.com/v1/chat/completions \
    -H "Authorization: Bearer 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" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "deepseek-ai/deepseek-v4-pro",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -m json.tool 2>/dev/null | grep -A2 "content" | head -3

echo ""
echo "If it worked, add it to your models!"
