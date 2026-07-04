#!/bin/bash
echo "=== Creating Frontend Structure ==="

# Create frontend directories
mkdir -p ~/claude-agent/frontend/src
mkdir -p ~/claude-agent/frontend/public

# Create package.json
cat > ~/claude-agent/frontend/package.json << 'PKGEOF'
{
  "name": "claude-agent-ui",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-scripts": "5.0.1",
    "socket.io-client": "^4.7.2"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": ["react-app"]
  },
  "browserslist": {
    "production": [">0.2%", "not dead", "not op_mini all"],
    "development": ["last 1 chrome version", "last 1 firefox version", "last 1 safari version"]
  }
}
PKGEOF

echo "✅ package.json created"

# Create App.js
cat > ~/claude-agent/frontend/src/App.js << 'APPEOF'
import React, { useState, useEffect, useRef } from 'react';
import './App.css';

const SERVER_URL = process.env.REACT_APP_SERVER_URL || 'http://localhost:8000';

function App() {
  const [prompt, setPrompt] = useState('');
  const [logs, setLogs] = useState([]);
  const [status, setStatus] = useState('idle');
  const [sessionId, setSessionId] = useState(null);
  const [ws, setWs] = useState(null);
  const [files, setFiles] = useState([]);
  const logsEndRef = useRef(null);

  const connectWebSocket = (sessionId) => {
    const ws = new WebSocket(`ws://${SERVER_URL.replace('http://', '')}/ws/${sessionId}`);
    
    ws.onopen = () => {
      setLogs(prev => [...prev, { type: 'info', message: '✅ Connected to agent', time: new Date() }]);
      setStatus('connected');
    };
    
    ws.onmessage = (event) => {
      const data = JSON.parse(event.data);
      handleWebSocketMessage(data);
    };
    
    ws.onclose = () => {
      setLogs(prev => [...prev, { type: 'error', message: '⚠️ Disconnected from agent', time: new Date() }]);
      setStatus('disconnected');
    };
    
    setWs(ws);
    return ws;
  };

  const handleWebSocketMessage = (data) => {
    const timestamp = new Date();
    
    switch(data.type) {
      case 'log':
        setLogs(prev => [...prev, { type: data.level || 'info', message: data.message, time: timestamp }]);
        break;
      case 'status':
        setStatus(data.is_running ? 'running' : 'idle');
        setLogs(prev => [...prev, { type: 'info', message: data.message, time: timestamp }]);
        break;
      case 'file':
        setFiles(prev => [...prev, { name: data.file, action: data.action, time: timestamp }]);
        setLogs(prev => [...prev, { type: 'file', message: `${data.action}: ${data.file}`, time: timestamp }]);
        break;
      case 'error':
        setLogs(prev => [...prev, { type: 'error', message: data.message, time: timestamp }]);
        break;
      default:
        console.log('Unknown message type:', data);
    }
    scrollToBottom();
  };

  const scrollToBottom = () => {
    setTimeout(() => {
      logsEndRef.current?.scrollIntoView({ behavior: 'smooth' });
    }, 100);
  };

  const createSession = async () => {
    try {
      const response = await fetch(`${SERVER_URL}/api/session/create`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
      });
      const data = await response.json();
      setSessionId(data.session_id);
      setLogs([{ type: 'info', message: `📌 Session created: ${data.session_id}`, time: new Date() }]);
      connectWebSocket(data.session_id);
    } catch (error) {
      setLogs(prev => [...prev, { type: 'error', message: `❌ Failed to create session: ${error.message}`, time: new Date() }]);
    }
  };

  const sendPrompt = () => {
    if (!prompt.trim()) return;
    if (!ws || ws.readyState !== WebSocket.OPEN) {
      setLogs(prev => [...prev, { type: 'error', message: '❌ Not connected to agent', time: new Date() }]);
      return;
    }
    
    setLogs(prev => [...prev, { type: 'info', message: `📤 Sending: ${prompt}`, time: new Date() }]);
    ws.send(JSON.stringify({ type: 'run', prompt }));
    setPrompt('');
  };

  const stopAgent = () => {
    if (ws && ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({ type: 'stop' }));
      setLogs(prev => [...prev, { type: 'info', message: '🛑 Stop command sent', time: new Date() }]);
    }
  };

  useEffect(() => {
    const handleKeyPress = (e) => {
      if (e.key === 'Enter' && e.ctrlKey) {
        sendPrompt();
      }
    };
    window.addEventListener('keydown', handleKeyPress);
    return () => window.removeEventListener('keydown', handleKeyPress);
  }, [prompt, ws]);

  return (
    <div className="App">
      <header className="header">
        <div className="header-left">
          <h1>🤖 Claude Code Agent</h1>
          <span className="version">v1.0</span>
        </div>
        <div className="status-bar">
          <span className={`status-dot ${status}`}></span>
          <span className="status-text">{status}</span>
          <button onClick={createSession} className="btn-connect">
            {sessionId ? '🔄 Reconnect' : '🔌 Connect'}
          </button>
          {sessionId && <span className="session-id">📌 {sessionId}</span>}
        </div>
      </header>

      <main className="main-content">
        <div className="sidebar">
          <div className="sidebar-section">
            <h3>📁 Files</h3>
            <div className="file-tree">
              {files.length === 0 ? (
                <p className="empty">No files yet</p>
              ) : (
                files.map((file, index) => (
                  <div key={index} className={`file-item ${file.action}`}>
                    {file.action === 'create' ? '📄' : '📝'} {file.name}
                  </div>
                ))
              )}
            </div>
          </div>
          <div className="sidebar-section">
            <h3>📊 Stats</h3>
            <div className="stats">
              <div>Logs: {logs.length}</div>
              <div>Files: {files.length}</div>
              <div>Session: {sessionId || 'None'}</div>
            </div>
          </div>
        </div>

        <div className="chat-area">
          <div className="logs-container">
            {logs.map((log, index) => (
              <div key={index} className={`log-entry ${log.type}`}>
                <span className="log-time">
                  {log.time ? log.time.toLocaleTimeString() : new Date().toLocaleTimeString()}
                </span>
                <span className="log-message">{log.message}</span>
              </div>
            ))}
            <div ref={logsEndRef} />
          </div>

          <div className="input-area">
            <input
              type="text"
              value={prompt}
              onChange={(e) => setPrompt(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && sendPrompt()}
              placeholder="Enter your prompt... (Ctrl+Enter to send)"
              className="prompt-input"
              disabled={!sessionId}
            />
            <button 
              onClick={sendPrompt} 
              className="btn-send"
              disabled={!sessionId || !prompt.trim()}
            >
              Send
            </button>
            <button 
              onClick={stopAgent} 
              className="btn-stop"
              disabled={status !== 'running'}
            >
              ⏹ Stop
            </button>
          </div>
        </div>
      </main>
    </div>
  );
}

export default App;
APPEOF

echo "✅ App.js created"

# Create App.css
cat > ~/claude-agent/frontend/src/App.css << 'CSSEOF'
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.App {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: #0a0e17;
  color: #e0e7ff;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.header {
  padding: 12px 24px;
  background: #0d1b2a;
  border-bottom: 1px solid #1a2d45;
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-shrink: 0;
}

.header-left {
  display: flex;
  align-items: center;
  gap: 12px;
}

.header h1 {
  font-size: 20px;
  font-weight: 600;
  background: linear-gradient(135deg, #60a5fa, #a78bfa);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.version {
  font-size: 11px;
  color: #64748b;
  background: #1a2d45;
  padding: 2px 8px;
  border-radius: 10px;
}

.status-bar {
  display: flex;
  align-items: center;
  gap: 12px;
}

.status-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  display: inline-block;
  transition: all 0.3s;
}

.status-dot.idle { 
  background: #fbbf24; 
  box-shadow: 0 0 8px #fbbf2466;
}
.status-dot.running { 
  background: #34d399; 
  box-shadow: 0 0 8px #34d39966;
  animation: pulse 1s infinite;
}
.status-dot.connected { 
  background: #60a5fa; 
  box-shadow: 0 0 8px #60a5fa66;
}
.status-dot.disconnected { 
  background: #ef4444; 
  box-shadow: 0 0 8px #ef444466;
}

@keyframes pulse {
  0%, 100% { opacity: 1; transform: scale(1); }
  50% { opacity: 0.5; transform: scale(0.8); }
}

.status-text {
  font-size: 13px;
  color: #94a3b8;
  text-transform: capitalize;
}

.btn-connect {
  padding: 6px 14px;
  border: none;
  border-radius: 6px;
  background: #1a2d45;
  color: #e0e7ff;
  cursor: pointer;
  font-size: 13px;
  transition: all 0.2s;
}

.btn-connect:hover {
  background: #2a3d55;
}

.session-id {
  font-size: 12px;
  color: #64748b;
  font-family: monospace;
}

.main-content {
  display: flex;
  flex: 1;
  overflow: hidden;
}

.sidebar {
  width: 220px;
  background: #0d1b2a;
  padding: 16px;
  overflow-y: auto;
  border-right: 1px solid #1a2d45;
  flex-shrink: 0;
}

.sidebar-section {
  margin-bottom: 20px;
}

.sidebar-section h3 {
  font-size: 13px;
  color: #94a3b8;
  margin-bottom: 10px;
  font-weight: 500;
}

.file-tree {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.file-item {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-family: monospace;
  transition: background 0.2s;
}

.file-item.create { 
  color: #34d399; 
  border-left: 2px solid #34d399;
}
.file-item.modify { 
  color: #fbbf24; 
  border-left: 2px solid #fbbf24;
}
.file-item:hover {
  background: #1a2d45;
}

.empty {
  color: #475569;
  font-size: 12px;
  font-style: italic;
}

.stats {
  font-size: 12px;
  color: #94a3b8;
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.chat-area {
  flex: 1;
  display: flex;
  flex-direction: column;
  background: #0a0e17;
}

.logs-container {
  flex: 1;
  padding: 16px;
  overflow-y: auto;
  font-family: 'JetBrains Mono', 'Fira Code', monospace;
  font-size: 13px;
  line-height: 1.6;
}

.log-entry {
  padding: 2px 0;
  display: flex;
  gap: 12px;
  align-items: baseline;
}

.log-entry.info { color: #94a3b8; }
.log-entry.error { color: #f87171; }
.log-entry.file { color: #34d399; }
.log-entry.success { color: #34d399; }

.log-time {
  color: #475569;
  font-size: 11px;
  flex-shrink: 0;
}

.log-message {
  word-break: break-word;
}

.input-area {
  display: flex;
  padding: 12px;
  background: #0d1b2a;
  gap: 8px;
  border-top: 1px solid #1a2d45;
  flex-shrink: 0;
}

.prompt-input {
  flex: 1;
  padding: 10px 14px;
  border: 1px solid #1a2d45;
  border-radius: 8px;
  background: #0a0e17;
  color: #e0e7ff;
  font-size: 14px;
  font-family: inherit;
  transition: border-color 0.2s;
}

.prompt-input:focus {
  outline: none;
  border-color: #60a5fa;
}

.prompt-input:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.prompt-input::placeholder {
  color: #475569;
}

.btn-send, .btn-stop {
  padding: 10px 20px;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  font-size: 14px;
  transition: all 0.2s;
}

.btn-send {
  background: linear-gradient(135deg, #3b82f6, #8b5cf6);
  color: white;
}

.btn-send:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.btn-send:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.btn-stop {
  background: #7f1d1d;
  color: #fca5a5;
}

.btn-stop:hover:not(:disabled) {
  background: #991b1b;
}

.btn-stop:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

::-webkit-scrollbar {
  width: 6px;
  height: 6px;
}

::-webkit-scrollbar-track {
  background: #0a0e17;
}

::-webkit-scrollbar-thumb {
  background: #1a2d45;
  border-radius: 3px;
}

::-webkit-scrollbar-thumb:hover {
  background: #2a3d55;
}

@media (max-width: 768px) {
  .sidebar {
    display: none;
  }
  
  .header {
    flex-direction: column;
    gap: 8px;
    padding: 12px;
  }
  
  .status-bar {
    flex-wrap: wrap;
    justify-content: center;
  }
  
  .input-area {
    flex-wrap: wrap;
  }
  
  .btn-send, .btn-stop {
    flex: 1;
    min-width: 80px;
  }
}
CSSEOF

echo "✅ App.css created"

# Create index.js
cat > ~/claude-agent/frontend/src/index.js << 'INDEXEOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
INDEXEOF

echo "✅ index.js created"

# Create index.html
cat > ~/claude-agent/frontend/public/index.html << 'HTMLEOF'
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta name="theme-color" content="#0a0e17" />
    <meta name="description" content="Claude Code Agent - Web Interface" />
    <title>Claude Code Agent</title>
  </head>
  <body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
  </body>
</html>
HTMLEOF

echo "✅ index.html created"

echo ""
echo "✅ Frontend structure complete!"
echo "📁 ~/claude-agent/frontend/"
ls -la ~/claude-agent/frontend/src/
