#!/usr/bin/env python3
"""Direct FreeTheAi API client - no FCC needed."""

import asyncio
import aiohttp
import json

FTA_KEY = "sta_dc76b3955da50e5632cdc2c5aca544d0069de7ffb276900d"
FTA_URL = "https://api.freetheai.xyz/v1/chat/completions"

async def ask_fta(prompt, model="opc/deepseek-v4-flash-free"):
    """Ask FreeTheAi directly."""
    headers = {
        "Authorization": f"Bearer {FTA_KEY}",
        "Content-Type": "application/json"
    }
    payload = {
        "model": model,
        "messages": [{"role": "user", "content": prompt}],
        "max_tokens": 4096
    }
    
    async with aiohttp.ClientSession() as session:
        async with session.post(FTA_URL, headers=headers, json=payload) as resp:
            data = await resp.json()
            return data.get("choices", [{}])[0].get("message", {}).get("content", "No response")

# Test
async def main():
    print("Testing FreeTheAi:")
    response = await ask_fta("What model are you?")
    print(response)

if __name__ == "__main__":
    asyncio.run(main())
