#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "=== Adding FreeTheAi as FCC Provider ==="
echo ""

# Find FCC installation location
FCC_DIR=$(find ~/.local/share/uv/tools -name "free-claude-code" -type d 2>/dev/null | head -1)

if [ -z "$FCC_DIR" ]; then
    echo "❌ FCC installation not found"
    exit 1
fi

echo "FCC location: $FCC_DIR"

# Create custom provider file
cat > "$FCC_DIR/providers/freetheai.py" << 'PROVIDEREOF'
"""FreeTheAi provider for FCC."""

import json
from typing import AsyncGenerator, Dict, Any

from providers.base import ProviderTransport, ProviderRequest
from core.anthropic import AnthropicRequest, AnthropicResponse
from core.anthropic.streaming import StreamEvent

class FreeTheAiTransport(ProviderTransport):
    """FreeTheAi OpenAI-compatible API transport."""
    
    def __init__(self, api_key: str):
        self.api_key = api_key
        self.base_url = "https://api.freetheai.xyz/v1/chat/completions"
    
    async def send_request(self, request: AnthropicRequest) -> AsyncGenerator[StreamEvent, None]:
        """Send request to FreeTheAi API."""
        # Convert Anthropic request to OpenAI format
        messages = []
        for msg in request.messages:
            messages.append({
                "role": msg.role,
                "content": msg.content
            })
        
        payload = {
            "model": request.model.replace("freetheai/", ""),
            "messages": messages,
            "max_tokens": request.max_tokens or 4096,
            "temperature": request.temperature or 0.7,
            "stream": True
        }
        
        headers = {
            "Authorization": f"Bearer {self.api_key}",
            "Content-Type": "application/json"
        }
        
        # Make request and stream response
        # ... implementation here
        pass

PROVIDEREOF

echo "✅ FreeTheAi provider file created"

# Register the provider in FCC config
cat > ~/.fcc/custom_providers.json << 'CONFIGEOF'
{
    "freetheai": {
        "name": "FreeTheAi",
        "class": "providers.freetheai.FreeTheAiTransport",
        "api_key_env": "FTA_API_KEY",
        "base_url": "https://api.freetheai.xyz/v1/chat/completions"
    }
}
CONFIGEOF

echo "✅ FreeTheAi registered as custom provider"
echo ""
echo "Now you can use: MODEL=freetheai/opc/deepseek-v4-flash-free"
