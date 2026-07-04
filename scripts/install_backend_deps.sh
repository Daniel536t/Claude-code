#!/bin/bash
echo "=== Installing Backend Dependencies ==="

# Install FastAPI and related packages
echo "Installing FastAPI, Uvicorn, and WebSockets..."

# Try pip install with --break-system-packages (Ubuntu 24.04+)
pip3 install fastapi uvicorn websockets python-multipart --break-system-packages 2>/dev/null || \
pip3 install fastapi uvicorn websockets python-multipart --user 2>/dev/null || \
sudo pip3 install fastapi uvicorn websockets python-multipart

echo ""
echo "✅ Dependencies installed"
echo ""
echo "Verifying installation:"
python3 -c "import fastapi; print('✅ FastAPI installed')" 2>/dev/null || echo "❌ FastAPI not installed"
python3 -c "import uvicorn; print('✅ Uvicorn installed')" 2>/dev/null || echo "❌ Uvicorn not installed"
