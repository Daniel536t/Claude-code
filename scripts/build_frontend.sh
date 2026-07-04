#!/bin/bash
echo "=== Building Frontend for Vercel ==="

cd ~/claude-agent/frontend

# Install dependencies
echo "1️⃣ Installing dependencies..."
npm install

# Build
echo "2️⃣ Building..."
npm run build

echo ""
echo "✅ Build complete!"
echo "📁 Build folder: ~/claude-agent/frontend/build"
echo ""
echo "📌 The build folder is ready for Vercel deployment!"
echo "   Size: $(du -sh ~/claude-agent/frontend/build | cut -f1)"
echo ""
echo "📌 Option C (Drag & Drop):"
echo "   Go to https://vercel.com/new"
echo "   Drag and drop the 'build' folder"
echo ""
echo "   Set environment variable:"
echo "   REACT_APP_SERVER_URL=http://13.217.12.249:8000"
