#!/bin/bash
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

echo "╔══════════════════════════════════════════╗"
echo "║   Complete Working Setup               ║"
echo "╚══════════════════════════════════════════╝"
echo ""

# 1. Ensure FCC is running with fastest model
echo "1️⃣ Starting FCC with Kimi K2.6..."
~/switch.sh kimi > /dev/null 2>&1
sleep 2

# 2. Test FCC
echo "2️⃣ Testing FCC..."
fcc-claude -p "Say OK" 2>/dev/null | head -1

# 3. Create your llm.py with full fallback chain
echo ""
echo "3️⃣ Setting up llm.py with full fallback chain..."
cat > ~/llm.py << 'LLMEOF'
#!/usr/bin/env python3
"""Universal LLM API with full fallback chain."""
import asyncio
import aiohttp
import json
import time
from typing import Optional, Dict, Any
from datetime import datetime

# ===== PROVIDER CONFIGURATION =====

# Tier 1: NVIDIA NIM (Fastest)
NV_URL = "https://integrate.api.nvidia.com/v1/chat/completions"
NV_KEY = "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"
NV_MODELS = [
    "moonshotai/kimi-k2.6",
    "z-ai/glm-5.2",
    "nvidia/nemotron-3-ultra-550b-a55b",
    "deepseek-ai/deepseek-v4-flash",
    "deepseek-ai/deepseek-v4-pro"
]

# Tier 2: Sambanova (Fallback)
SN_URL = "https://api.sambanova.ai/v1/chat/completions"
SN_KEY = "aa00847f-db17-461e-b725-18984b37a59e"
SN_MODELS = [
    "DeepSeek-V3.2",
    "Meta-Llama-3.3-70B-Instruct",
    "gemma-4-31B-it"
]

# Tier 3: FreeTheAi (Last resort)
FTA_URL = "https://api.freetheai.xyz/v1/chat/completions"
FTA_KEY = "sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d"
FTA_MODELS = [
    "opc/deepseek-v4-flash-free",
    "opc/big-pickle",
    "opc/mimo-v2.5-free"
]

# ===== RETRY CONFIGURATION =====
MAX_RETRIES = 3
RETRY_DELAY = 5  # seconds

# ===== RATE LIMITING =====
_last_request_time = 0
MIN_REQUEST_INTERVAL = 0.5  # seconds

# ===== CORE FUNCTIONS =====

class RateLimitError(Exception):
    pass

class AllModelsFailed(Exception):
    pass

def _log(provider: str, model: str, prompt_chars: int, response: str, finish_reason: str):
    """Log request details."""
    timestamp = datetime.now().isoformat()
    log_entry = {
        "timestamp": timestamp,
        "provider": provider,
        "model": model,
        "prompt_chars": prompt_chars,
        "response_chars": len(response),
        "finish_reason": finish_reason
    }
    # Print to console for now
    print(f"[{timestamp}] {provider}/{model}: {response[:50]}...")

async def _rate_limit():
    """Enforce minimum time between requests."""
    global _last_request_time
    now = time.time()
    elapsed = now - _last_request_time
    if elapsed < MIN_REQUEST_INTERVAL:
        await asyncio.sleep(MIN_REQUEST_INTERVAL - elapsed)
    _last_request_time = time.time()

async def _call_api(
    url: str,
    key: str,
    model: str,
    system: str,
    user: str,
    temp: float = 0.3,
    max_tokens: int = 4096,
    provider: str = "unknown"
) -> str:
    """Universal API caller for all providers."""
    
    headers = {
        "Authorization": f"Bearer {key}",
        "Accept": "application/json",
        "Content-Type": "application/json"
    }
    
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": system},
            {"role": "user", "content": user}
        ],
        "max_tokens": max_tokens,
        "temperature": temp,
        "stream": False,
    }
    
    # NVIDIA-specific settings
    if "nvidia" in url:
        payload["top_p"] = 1.0
    
    prompt_chars = len(system) + len(user)
    timeout = aiohttp.ClientTimeout(total=120)
    
    async with aiohttp.ClientSession(timeout=timeout) as session:
        async with session.post(url, headers=headers, json=payload) as resp:
            data = await resp.json()
            
            # Rate limit detection
            if resp.status == 429:
                error_msg = data.get("error", {}).get("message", "Rate limit")
                raise RateLimitError(f"{resp.status}: {error_msg}")
            
            # Error handling
            if "error" in data:
                error = data["error"]
                if isinstance(error, dict):
                    error_msg = error.get("message", str(error))
                else:
                    error_msg = str(error)
                
                # Check for rate limit indicators
                if any(term in error_msg.lower() for term in ["limit", "exhausted", "capacity", "quota"]):
                    raise RateLimitError(error_msg[:100])
                raise RuntimeError(error_msg[:200])
            
            # Extract response
            if "choices" not in data or not data["choices"]:
                raise RuntimeError("No choices in response")
            
            choice = data["choices"][0]
            content = choice.get("message", {}).get("content", "")
            finish = choice.get("finish_reason", "unknown")
            
            _log(provider, model, prompt_chars, content, finish)
            return content

async def _try_tier(
    url: str,
    key: str,
    models: list,
    system: str,
    user: str,
    temp: float,
    max_tokens: int,
    tier_name: str
) -> Optional[str]:
    """Try all models in a tier."""
    for model in models:
        try:
            print(f"🔄 Trying {tier_name}/{model}...")
            return await _call_api(url, key, model, system, user, temp, max_tokens, tier_name)
        except RateLimitError as e:
            print(f"⏳ Rate limit on {model}: {e}")
            await asyncio.sleep(RETRY_DELAY)
            continue
        except Exception as e:
            print(f"⚠️  Error on {model}: {e}")
            continue
    return None

async def llm(
    model: str = "moonshotai/kimi-k2.6",
    system: str = "You are a helpful assistant.",
    user: str = "",
    temp: float = 0.3,
    max_tokens: int = 4096
) -> str:
    """Main LLM function with full fallback chain."""
    
    await _rate_limit()
    
    # Tier 1: Try NVIDIA with requested model
    try:
        print(f"⚡ Trying NVIDIA/{model}...")
        return await _call_api(NV_URL, NV_KEY, model, system, user, temp, max_tokens, "nvidia")
    except RateLimitError:
        print("⏳ Rate limit on requested model, trying fallbacks...")
    except Exception as e:
        print(f"⚠️  Error on requested model: {e}")
    
    # Tier 1 fallback: Try other NVIDIA models
    result = await _try_tier(NV_URL, NV_KEY, NV_MODELS, system, user, temp, max_tokens, "nvidia")
    if result:
        return result
    
    print("⚠️  All NVIDIA models failed, trying Sambanova...")
    
    # Tier 2: Sambanova
    result = await _try_tier(SN_URL, SN_KEY, SN_MODELS, system, user, temp, max_tokens, "sambanova")
    if result:
        return result
    
    print("⚠️  Sambanova failed, trying FreeTheAi...")
    
    # Tier 3: FreeTheAi
    result = await _try_tier(FTA_URL, FTA_KEY, FTA_MODELS, system, user, temp, max_tokens, "freetheai")
    if result:
        return result
    
    raise AllModelsFailed("All providers failed. Check API keys and rate limits.")

# ===== COMMAND LINE USAGE =====
async def main():
    import sys
    
    if len(sys.argv) < 2:
        print("Usage: python3 llm.py 'Your prompt here'")
        print("Example: python3 llm.py 'Hello, how are you?'")
        sys.exit(1)
    
    prompt = " ".join(sys.argv[1:])
    
    # Fast version (just ask)
    if "--fast" in sys.argv:
        prompt = prompt.replace("--fast", "").strip()
        try:
            response = await llm(
                model="moonshotai/kimi-k2.6",
                user=prompt
            )
            print(response)
        except Exception as e:
            print(f"❌ Error: {e}")
        return
    
    # Show which model is used
    try:
        print("🤖 Querying with full fallback chain...")
        response = await llm(user=prompt)
        print(f"\n📝 Response:\n{response}")
    except Exception as e:
        print(f"❌ All providers failed: {e}")

if __name__ == "__main__":
    asyncio.run(main())
LLMEOF

chmod +x ~/llm.py

echo "✅ llm.py created"
echo ""
echo "4️⃣ Testing llm.py..."
python3 ~/llm.py "Say OK in one word" --fast 2>/dev/null | head -3

echo ""
echo "╔══════════════════════════════════════════╗"
echo "║   ✅ Setup Complete!                    ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "📌 Use these commands:"
echo "  python3 ~/llm.py 'Your prompt'         # Full fallback chain"
echo "  python3 ~/llm.py 'Prompt' --fast       # Fastest model only"
echo "  fcc-claude -p 'Prompt'                 # Claude Code CLI"
echo ""
echo "📊 Providers in fallback chain:"
echo "  1. NVIDIA NIM (5 models) ⚡⚡⚡"
echo "  2. Sambanova (3 models) ⚡⚡"
echo "  3. FreeTheAi (3 models) ⚡"
