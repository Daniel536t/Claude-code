#!/usr/bin/env python3
"""Test Discord bot connection directly."""

import discord
import asyncio
import sys

TOKEN = "DISCORD_BOT_TOKEN_PLACEHOLDER"
CHANNEL_ID = 1522818806911860831

class TestBot(discord.Client):
    async def on_ready(self):
        print(f'✅ Bot connected as {self.user}')
        print(f'📌 Bot ID: {self.user.id}')
        print(f'📌 Channel ID: {CHANNEL_ID}')
        
        # Try to send a test message
        try:
            channel = self.get_channel(CHANNEL_ID)
            if channel:
                await channel.send("✅ FCC Discord Bot is online!")
                print("✅ Test message sent!")
            else:
                print(f"❌ Channel {CHANNEL_ID} not found")
        except Exception as e:
            print(f"❌ Error: {e}")
        
        await self.close()

    async def on_message(self, message):
        if message.author == self.user:
            return
        print(f"📨 Message from {message.author}: {message.content[:50]}...")
        
        if message.content.startswith('/'):
            print(f"   Command: {message.content}")

async def main():
    intents = discord.Intents.default()
    intents.message_content = True
    intents.messages = True
    
    bot = TestBot(intents=intents)
    
    try:
        await bot.start(TOKEN)
    except discord.LoginFailure:
        print("❌ Invalid token! Get a new token from Discord Developer Portal")
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    print("=== Testing Discord Bot ===")
    print(f"Token: {TOKEN[:20]}...")
    print(f"Channel: {CHANNEL_ID}")
    print("")
    asyncio.run(main())
