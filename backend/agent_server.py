#!/usr/bin/env python3
"""WebSocket server for Claude Code agent with real-time control."""

import asyncio
import json
import subprocess
import os
import signal
import uuid
from fastapi import FastAPI, WebSocket, WebSocketDisconnect, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
import uvicorn
from typing import Dict
import queue

app = FastAPI(title="Claude Code Agent Server")

# ===== CORS CONFIGURATION =====
# Restrict to specific origins for security
ALLOWED_ORIGINS = [
    "https://your-vercel-app.vercel.app",  # Your Vercel frontend
    "http://localhost:3000",               # Local development
    "http://localhost:8000",               # Local backend
]

# For production, restrict to your Vercel URL only
# Replace 'your-vercel-app' with your actual Vercel URL
if os.environ.get("VERCEL_URL"):
    ALLOWED_ORIGINS.append(f"https://{os.environ.get('VERCEL_URL')}")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Store active sessions
class AgentSession:
    def __init__(self, session_id: str):
        self.session_id = session_id
        self.process = None
        self.is_running = False
        self.websocket = None
        self.task = None

sessions: Dict[str, AgentSession] = {}

@app.get("/")
async def root():
    return {"status": "Agent Server Running", "sessions": len(sessions)}

@app.post("/api/session/create")
async def create_session():
    """Create a new agent session."""
    session_id = str(uuid.uuid4())[:8]
    sessions[session_id] = AgentSession(session_id)
    return {"session_id": session_id}

@app.websocket("/ws/{session_id}")
async def websocket_endpoint(websocket: WebSocket, session_id: str):
    """WebSocket endpoint for real-time agent communication."""
    await websocket.accept()
    
    if session_id not in sessions:
        await websocket.send_json({"type": "error", "message": "Session not found"})
        await websocket.close()
        return
    
    session = sessions[session_id]
    session.websocket = websocket
    
    try:
        while True:
            data = await websocket.receive_json()
            
            if data.get("type") == "run":
                prompt = data.get("prompt", "")
                await run_agent(session, prompt)
            
            elif data.get("type") == "stop":
                await stop_agent(session)
            
            elif data.get("type") == "status":
                await send_status(session)
                
            elif data.get("type") == "ping":
                await websocket.send_json({"type": "pong"})
                
    except WebSocketDisconnect:
        print(f"WebSocket disconnected for session {session_id}")
    finally:
        await cleanup_session(session)

async def run_agent(session: AgentSession, prompt: str):
    """Run Claude Code with the given prompt."""
    if session.is_running:
        await session.websocket.send_json({
            "type": "error", 
            "message": "Agent is already running. Use /stop first."
        })
        return
    
    session.is_running = True
    
    await session.websocket.send_json({
        "type": "status",
        "message": f"🚀 Starting Claude Code with: {prompt[:100]}..."
    })
    
    loop = asyncio.get_event_loop()
    session.task = loop.create_task(run_claude_code(session, prompt))

async def run_claude_code(session: AgentSession, prompt: str):
    """Execute Claude Code and stream output."""
    try:
        env = os.environ.copy()
        env["ANTHROPIC_BASE_URL"] = "http://localhost:8082"
        env["ANTHROPIC_AUTH_TOKEN"] = "freecc"
        env["CLAUDE_CODE_ENABLE_GATEWAY_MODEL_DISCOVERY"] = "1"
        env["CLAUDE_CODE_AUTO_COMPACT_WINDOW"] = "190000"
        
        cmd = ["fcc-claude", "-p", prompt]
        
        session.process = await asyncio.create_subprocess_exec(
            *cmd,
            stdout=asyncio.subprocess.PIPE,
            stderr=asyncio.subprocess.PIPE,
            env=env,
            cwd="/home/ubuntu/claude-agent/workspace"
        )
        
        await session.websocket.send_json({
            "type": "log",
            "level": "info",
            "message": f"📦 Process started (PID: {session.process.pid})"
        })
        
        while True:
            line = await session.process.stdout.readline()
            if not line:
                break
            
            line_str = line.decode('utf-8', errors='ignore').strip()
            if line_str:
                if "writing" in line_str.lower() or "creating" in line_str.lower():
                    await session.websocket.send_json({
                        "type": "file",
                        "action": "create",
                        "file": line_str
                    })
                else:
                    await session.websocket.send_json({
                        "type": "log",
                        "level": "info",
                        "message": line_str
                    })
            
        stderr = await session.process.stderr.read()
        if stderr:
            stderr_str = stderr.decode('utf-8', errors='ignore')
            await session.websocket.send_json({
                "type": "log",
                "level": "error",
                "message": stderr_str
            })
        
        await session.process.wait()
        
        await session.websocket.send_json({
            "type": "status",
            "message": f"✅ Claude Code finished (exit code: {session.process.returncode})"
        })
        
    except Exception as e:
        await session.websocket.send_json({
            "type": "error",
            "message": f"❌ Error: {str(e)}"
        })
    finally:
        session.is_running = False

async def stop_agent(session: AgentSession):
    """Stop the currently running agent."""
    if session.process:
        try:
            session.process.terminate()
            await asyncio.sleep(1)
            if session.process.returncode is None:
                session.process.kill()
            await session.websocket.send_json({
                "type": "status",
                "message": "🛑 Agent stopped"
            })
        except Exception as e:
            await session.websocket.send_json({
                "type": "error",
                "message": f"Error stopping: {e}"
            })
    session.is_running = False

async def send_status(session: AgentSession):
    """Send current status."""
    await session.websocket.send_json({
        "type": "status",
        "is_running": session.is_running,
        "message": f"Agent is {'running' if session.is_running else 'idle'}"
    })

async def cleanup_session(session: AgentSession):
    """Clean up session resources."""
    if session.is_running:
        await stop_agent(session)
    session.is_running = False
    session.websocket = None

if __name__ == "__main__":
    print("╔══════════════════════════════════════════╗")
    print("║   Claude Code Agent Server              ║")
    print("╚══════════════════════════════════════════╝")
    print("")
    print(f"📌 CORS Allowed Origins: {ALLOWED_ORIGINS}")
    print("📌 WebSocket: ws://localhost:8000/ws/{session_id}")
    print("📌 API: http://localhost:8000")
    print("")
    uvicorn.run(app, host="0.0.0.0", port=8000)
