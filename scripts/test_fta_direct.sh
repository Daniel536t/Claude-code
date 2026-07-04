#!/bin/bash
echo "=== Testing FreeTheAi Direct API ==="
echo ""

# Test FreeTheAi with curl (like your llm.py does)
echo "1️⃣ Testing FreeTheAi DeepSeek V4 Flash..."
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "opc/deepseek-v4-flash-free",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content','No response'))"

echo ""
echo "2️⃣ Testing FreeTheAi Big Pickle..."
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "opc/big-pickle",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content','No response'))"

echo ""
echo "3️⃣ Testing FreeTheAi Gemini 3.5 Flash..."
curl -s -X POST https://api.freetheai.xyz/v1/chat/completions \
    -H "Authorization: Bearer sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "vova/gemini-3.5-flash",
        "messages": [{"role": "user", "content": "Say OK in one word"}],
        "max_tokens": 10
    }' | python3 -c "import sys, json; data=json.load(sys.stdin); print(data.get('choices',[{}])[0].get('message',{}).get('content','No response'))"
