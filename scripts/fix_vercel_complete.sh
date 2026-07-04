#!/bin/bash
echo "=== Complete Vercel Fix ==="

cd ~/claude-agent

# 1. Create proper vercel.json at root
cat > vercel.json << 'VERCEL_EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "frontend/package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/frontend/build/$1"
    }
  ]
}
VERCEL_EOF

echo "✅ Root vercel.json created"

# 2. Create vercel.json in frontend
cat > frontend/vercel.json << 'VERCEL_FRONTEND_EOF'
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build"
    }
  ]
}
VERCEL_FRONTEND_EOF

echo "✅ Frontend vercel.json created"

# 3. Add to git
git add vercel.json frontend/vercel.json
git commit -m "Fix: Add vercel.json configuration"
git push origin main

echo ""
echo "✅ Configuration pushed to GitHub!"
echo ""
echo "📌 Now go to Vercel and click 'Redeploy'"
echo "   Or visit: https://vercel.com/dashboard"
echo ""
echo "📌 If it still fails, try the Direct Upload method:"
echo "   cd ~/claude-agent/frontend"
echo "   npm install"
echo "   npm run build"
echo "   vercel --prod"
