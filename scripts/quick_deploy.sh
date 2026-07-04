#!/bin/bash
echo "=== Quick Vercel Deploy ==="

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📌 Installing Vercel CLI..."
    npm install -g vercel
fi

cd ~/claude-agent/frontend

echo "📌 Deploying to Vercel..."
echo "📌 When prompted for environment variable, enter:"
echo "   REACT_APP_SERVER_URL=http://13.217.12.249:8000"
echo ""
echo "Press Enter to continue..."
read

vercel --prod

echo ""
echo "✅ Deploy complete!"
echo "📌 After deployment, update CORS in backend:"
echo "   ~/update_cors_after_deploy.sh"
