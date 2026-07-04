#!/bin/bash

echo "=== Testing Direct API (No FCC Proxy) ==="
echo ""

# Test NVIDIA directly
echo "Testing NVIDIA NIM directly:"
curl -s -X POST https://integrate.api.nvidia.com/v1/chat/completions \
    -H "Authorization: Bearer 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" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "moonshotai/kimi-k2.6",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -m json.tool 2>/dev/null || echo "❌ Failed"

echo ""
echo "Testing Sambanova directly:"
curl -s -X POST https://api.sambanova.ai/v1/chat/completions \
    -H "Authorization: Bearer aa00847f-db17-461e-b725-18984b37a59e" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "DeepSeek-V3.2",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -m json.tool 2>/dev/null || echo "❌ Failed"
