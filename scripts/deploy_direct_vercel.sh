#!/bin/bash
echo "=== Direct Vercel Deployment ==="

cd ~/claude-agent/frontend

# Install dependencies
echo "1️⃣ Installing dependencies..."
npm install

# Build the frontend
echo "2️⃣ Building..."
npm run build

# Deploy to Vercel
echo "3️⃣ Deploying to Vercel..."
echo ""
echo "📌 When prompted:"
echo "   - Set up and deploy? → Yes"
echo "   - Link to existing project? → Yes (or No to create new)"
echo "   - Select your scope/account"
echo "   - Project name: claude-code (or your existing project)"
echo "   - Directory: frontend"
echo "   - Build command: npm run build"
echo "   - Output directory: build"
echo "   - Environment variable: REACT_APP_SERVER_URL=http://13.217.12.249:8000"
echo ""
echo "Press Enter to continue..."
read

vercel --prod

echo ""
echo "✅ Deployment complete!"
echo "📌 Your app URL will be shown above"
