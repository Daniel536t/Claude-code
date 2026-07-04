#!/bin/bash
echo "=== Installing Voice Support ==="
echo ""
echo "Choose voice backend:"
echo "  1) NVIDIA NIM (Riva gRPC) - requires API key"
echo "  2) Local Whisper (CPU) - slower but free"
echo "  3) Local Whisper (CUDA) - faster with GPU"
echo "  4) Skip (no voice)"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        echo "Installing NVIDIA NIM voice support..."
        curl -fsSL "https://github.com/Alishahryar1/free-claude-code/blob/main/scripts/install.sh?raw=1" | sh -s -- --voice-nim
        echo "✅ Voice-NIM installed"
        echo "📌 Set 'Voice Notes' to 'on' and 'Whisper Device' to 'nvidia_nim' in Admin UI"
        ;;
    2)
        echo "Installing Local Whisper (CPU)..."
        curl -fsSL "https://github.com/Alishahryar1/free-claude-code/blob/main/scripts/install.sh?raw=1" | sh -s -- --voice-local
        echo "✅ Voice-Local (CPU) installed"
        echo "📌 Set 'Whisper Device' to 'cpu' in Admin UI"
        ;;
    3)
        echo "Installing Local Whisper (CUDA)..."
        curl -fsSL "https://github.com/Alishahryar1/free-claude-code/blob/main/scripts/install.sh?raw=1" | sh -s -- --voice-local --torch-backend cu130
        echo "✅ Voice-Local (CUDA) installed"
        echo "📌 Set 'Whisper Device' to 'cuda' in Admin UI"
        ;;
    *)
        echo "Skipping voice support"
        ;;
esac
