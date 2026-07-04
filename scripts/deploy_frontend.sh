#!/bin/bash
echo "=== Deploying Frontend to Vercel ==="

cd ~/claude-agent/frontend

# Install dependencies
echo "1️⃣ Installing dependencies..."
npm install

# Build the project
echo "2️⃣ Building project..."
npm run build

echo ""
echo "✅ Build complete!"
echo "📁 Build folder: ~/claude-agent/frontend/build"
echo ""
echo "📌 NEXT STEPS:"
echo ""
echo "Option A: Deploy via Vercel CLI"
echo "  npm install -g vercel"
echo "  cd ~/claude-agent/frontend"
echo "  vercel --prod"
echo ""
echo "Option B: Deploy via GitHub"
echo "  1. Push to GitHub:"
echo "     cd ~/claude-agent"
echo "     git init"
echo "     git add ."
echo "     git commit -m 'Initial commit'"
echo "     git remote add origin https://github.com/YOUR_USERNAME/claude-agent.git"
echo "     git push -u origin main"
echo ""
echo "  2. Import to Vercel:"
echo "     https://vercel.com/new"
echo "     Select your GitHub repo"
echo "     Set environment variable:"
echo "     REACT_APP_SERVER_URL=http://$(curl -s ifconfig.me):8000"
echo ""
echo "Option C: Deploy via Vercel Dashboard"
echo "  1. Go to https://vercel.com/new"
echo "  2. Drag and drop the 'build' folder"
echo "  3. Set environment variable when prompted"
echo "  4. Deploy!"
