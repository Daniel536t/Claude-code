#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Testing All Available Providers ==="
echo ""

# Test NVIDIA NIM
echo "1️⃣ Testing NVIDIA NIM (Kimi K2.6)..."
sed -i 's/^MODEL=.*/MODEL=nvidia_nim\/moonshotai\/kimi-k2.6/' ~/.fcc/.env
~/fcc_restart.sh
sleep 2
fcc-claude -p "Say 'NVIDIA NIM works!' in 3 words" 2>/dev/null | head -1
echo ""

# Test FreeTheAi
echo "2️⃣ Testing FreeTheAi (DeepSeek V4 Flash)..."
sed -i 's/^MODEL=.*/MODEL=opc\/deepseek-v4-flash-free/' ~/.fcc/.env
sed -i 's/^FTA_MODEL=.*/FTA_MODEL=opc\/deepseek-v4-flash-free/' ~/.fcc/.env
~/fcc_restart.sh
sleep 2
fcc-claude -p "Say 'FreeTheAi works!' in 3 words" 2>/dev/null | head -1
echo ""

# Test Cloudflare
echo "3️⃣ Testing Cloudflare (GLM 5.2)..."
sed -i 's/^MODEL=.*/MODEL=cloudflare\/zai-org\/glm-5.2/' ~/.fcc/.env
~/fcc_restart.sh
sleep 2
fcc-claude -p "Say 'Cloudflare works!' in 3 words" 2>/dev/null | head -1
echo ""

# Test Sambanova
echo "4️⃣ Testing Sambanova (DeepSeek V3.2)..."
sed -i 's/^MODEL=.*/MODEL=DeepSeek-V3.2/' ~/.fcc/.env
~/fcc_restart.sh
sleep 2
fcc-claude -p "Say 'Sambanova works!' in 3 words" 2>/dev/null | head -1
echo ""

echo "✅ All tests complete! Switch back to Kimi K2.6:"
echo "  ~/switch_to_model.sh \"nvidia_nim/moonshotai/kimi-k2.6\" \"NVIDIA Kimi K2.6\""
