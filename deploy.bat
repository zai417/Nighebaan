@echo off
REM Render.com Deployment Helper Script for Windows
REM This script helps prepare your application for deployment on Render.com

echo.
echo Render.com Deployment Helper
echo ================================
echo.

REM Check if git is initialized
if not exist ".git" (
    echo X Git repository not found. Please run 'git init' first.
    exit /b 1
)

echo + Git repository found

REM Check if files exist
if not exist "render.yaml" (
    echo X render.yaml not found in root directory
    exit /b 1
)
echo + render.yaml found

if not exist ".env.example" (
    echo X .env.example not found in root directory
    exit /b 1
)
echo + .env.example found

REM Check Node modules
if not exist "node_modules" (
    echo - Frontend node_modules not found. Installing...
    call npm install
    echo + Frontend dependencies installed
)

if not exist "backend\node_modules" (
    echo - Backend node_modules not found. Installing...
    cd backend
    call npm install
    cd ..
    echo + Backend dependencies installed
)

REM Check if frontend is built
if not exist "build" (
    echo - Frontend build directory not found. Building...
    call npm run build
    echo + Frontend built
)

echo.
echo == Pre-deployment checks completed!
echo.
echo Next steps:
echo 1. Create MongoDB Atlas cluster: https://www.mongodb.com/cloud/atlas
echo 2. Copy your MongoDB connection string
echo 3. Go to https://render.com and sign in with GitHub
echo 4. Click 'New Blueprint' and select your repository
echo 5. Render will deploy services from render.yaml
echo 6. Set environment variables in Render dashboard:
echo    - MONGODB_URI (from MongoDB Atlas)
echo    - JWT_SECRET (generate a secure random string)
echo    - CLIENT_ORIGIN (your frontend URL)
echo    - OPENAI_API_KEY (if using ChatAI feature)
echo.
echo For detailed instructions, see RENDER_DEPLOYMENT.md
echo.
