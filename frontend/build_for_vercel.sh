#!/bin/bash
echo "=== Building Frontend for Vercel ==="

cd ~/claude-agent/frontend

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
fi

# Build
echo "Building..."
npm run build

echo ""
echo "✅ Build complete!"
echo "📁 Build folder: ~/claude-agent/frontend/build"
echo ""
echo "📌 Deploy to Vercel:"
echo "   Option 1: Using Vercel CLI"
echo "   npm install -g vercel"
echo "   cd ~/claude-agent/frontend"
echo "   vercel --prod"
echo ""
echo "   Option 2: Push to GitHub and import to Vercel"
echo "   https://vercel.com/new"
echo ""
echo "📌 Set environment variable in Vercel:"
echo "   REACT_APP_SERVER_URL=http://YOUR_AWS_IP:8000"
