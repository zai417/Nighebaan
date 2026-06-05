#!/bin/bash

# Render.com Deployment Helper Script
# This script helps prepare your application for deployment on Render.com

set -e

echo "🚀 Render.com Deployment Helper"
echo "================================"
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git repository not found. Please run 'git init' first."
    exit 1
fi

echo "✓ Git repository found"

# Check if files exist
if [ ! -f "render.yaml" ]; then
    echo "❌ render.yaml not found in root directory"
    exit 1
fi
echo "✓ render.yaml found"

if [ ! -f ".env.example" ]; then
    echo "❌ .env.example not found in root directory"
    exit 1
fi
echo "✓ .env.example found"

# Check Node modules
if [ ! -d "node_modules" ]; then
    echo "⚠️  Frontend node_modules not found. Installing..."
    npm install
    echo "✓ Frontend dependencies installed"
fi

if [ ! -d "backend/node_modules" ]; then
    echo "⚠️  Backend node_modules not found. Installing..."
    cd backend && npm install
    cd ..
    echo "✓ Backend dependencies installed"
fi

# Check if frontend is built
if [ ! -d "build" ]; then
    echo "⚠️  Frontend build directory not found. Building..."
    npm run build
    echo "✓ Frontend built"
fi

echo ""
echo "✅ Pre-deployment checks completed!"
echo ""
echo "Next steps:"
echo "1. Create MongoDB Atlas cluster: https://www.mongodb.com/cloud/atlas"
echo "2. Copy your MongoDB connection string"
echo "3. Go to https://render.com and sign in with GitHub"
echo "4. Click 'New Blueprint' and select your repository"
echo "5. Render will deploy services from render.yaml"
echo "6. Set environment variables in Render dashboard:"
echo "   - MONGODB_URI (from MongoDB Atlas)"
echo "   - JWT_SECRET (generate a secure random string)"
echo "   - CLIENT_ORIGIN (your frontend URL)"
echo "   - OPENAI_API_KEY (if using ChatAI feature)"
echo ""
echo "📚 For detailed instructions, see RENDER_DEPLOYMENT.md"
echo ""
