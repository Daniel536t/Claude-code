#!/usr/bin/env python3
"""Advanced Discord bot with full FCC support."""

import discord
import aiohttp
import asyncio
import json

TOKEN = "DISCORD_BOT_TOKEN_PLACEHOLDER"
CHANNEL_ID = 1522818806911860831
FCC_URL = "http://localhost:8082/v1/messages"

class FCCBot(discord.Client):
    async def on_ready(self):
        print(f'✅ Bot connected as {self.user}')
        channel = self.get_channel(CHANNEL_ID)
        if channel:
            await channel.send("✅ FCC Bot is online! Send any message to run Claude Code.")

    async def on_message(self, message):
        if message.author == self.user:
            return
        if message.channel.id != CHANNEL_ID:
            return
        
        async with message.channel.typing():
            try:
                async with aiohttp.ClientSession() as session:
                    payload = {
                        "model": "nvidia_nim/moonshotai/kimi-k2.6",
                        "messages": [{"role": "user", "content": message.content}],
                        "max_tokens": 4096
                    }
                    headers = {"Authorization": "Bearer freecc", "Content-Type": "application/json"}
                    async with session.post(FCC_URL, headers=headers, json=payload) as resp:
                        data = await resp.json()
                        response = data.get("choices", [{}])[0].get("message", {}).get("content", "No response")
                        await message.channel.send(response)
            except Exception as e:
                await message.channel.send(f"❌ Error: {str(e)[:500]}")

intents = discord.Intents.default()
intents.message_content = True
bot = FCCBot(intents=intents)
asyncio.run(bot.start(TOKEN))
