#!/bin/bash
echo "=== Fixing Vercel Configuration ==="

cd ~/claude-agent

# Create vercel.json in the root directory
cat > vercel.json << 'VERCEL_EOF'
{
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
      "dest": "frontend/build/$1"
    }
  ]
}
VERCEL_EOF

echo "✅ vercel.json created"

# Also create a vercel.json in frontend directory for safety
cat > frontend/vercel.json << 'VERCEL_FRONTEND_EOF'
{
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/static-build",
      "config": {
        "distDir": "build"
      }
    }
  ],
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/build/$1"
    }
  ]
}
VERCEL_FRONTEND_EOF

echo "✅ frontend/vercel.json created"

# Add and commit the changes
git add vercel.json frontend/vercel.json
git commit -m "Fix: Add vercel.json for proper frontend deployment"
git push origin main

echo ""
echo "✅ Changes pushed to GitHub!"
echo "📌 Redeploy on Vercel now."
