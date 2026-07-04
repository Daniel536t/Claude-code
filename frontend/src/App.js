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
