# Render.com Deployment Guide

## Overview
This application consists of:
- **Backend**: Node.js/Express API server
- **Frontend**: React static site
- **Database**: MongoDB

## Deployment Steps

### 1. Prepare Your Repository
Ensure all changes are committed to your Git repository (GitHub, GitLab, or Bitbucket).

### 2. Set Up MongoDB
You have two options:

#### Option A: MongoDB Atlas (Recommended for Free Tier)
1. Go to [MongoDB Atlas](https://www.mongodb.com/cloud/atlas)
2. Create a free account and cluster
3. Get your connection string: `mongodb+srv://username:password@cluster.mongodb.net/elderly-care?retryWrites=true&w=majority`
4. Replace `username` and `password` with your actual credentials

#### Option B: Render PostgreSQL (if using database service)
*Note: Render's free tier database is PostgreSQL. You'll need to either use MongoDB Atlas or upgrade to a paid tier for MongoDB.*

### 3. Create Render Services

#### Option A: Using render.yaml (Recommended)
1. Push the `render.yaml` file to your repository
2. Go to [Render Dashboard](https://dashboard.render.com/)
3. Click "New Blueprint" 
4. Connect your repository
5. Render will automatically detect and deploy services from `render.yaml`

#### Option B: Manual Service Creation

**Backend Service:**
1. New → Web Service
2. Connect your GitHub repository
3. Set configurations:
   - **Name**: `fyp-backend`
   - **Environment**: Node
   - **Region**: Choose closest to your users
   - **Branch**: `main` (or your default branch)
   - **Build Command**: `cd backend && npm install`
   - **Start Command**: `cd backend && npm start`
4. Add environment variables (see section below)
5. Create service

**Frontend Service:**
1. New → Static Site
2. Connect your repository
3. Set configurations:
   - **Name**: `fyp-frontend`
   - **Build Command**: `npm run build`
   - **Publish Directory**: `build`
4. Add environment variables
5. Create service

### 4. Set Environment Variables

**Backend Environment Variables:**
```
NODE_ENV=production
PORT=10000
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/elderly-care?retryWrites=true&w=majority
JWT_SECRET=your-secure-random-string-minimum-32-characters
CLIENT_ORIGIN=https://your-frontend-url.onrender.com,https://your-domain.com
OPENAI_API_KEY=sk-your-api-key-here (if using ChatAI)
```

**Frontend Environment Variables:**
```
REACT_APP_API_URL=https://your-backend-url.onrender.com/api
REACT_APP_SOCKET_URL=https://your-backend-url.onrender.com
```

### 5. Custom Domain Setup (Optional)
1. Go to service settings
2. Click "Custom Domain"
3. Add your domain and follow DNS configuration instructions

### 6. Monitor Deployment

**View Logs:**
- Each service has a "Logs" tab showing real-time build and runtime logs
- Check for any errors during deployment

**Test Your Application:**
1. Visit the frontend URL
2. Try logging in or accessing API endpoints
3. Check the health endpoint: `https://your-backend-url.onrender.com/api/health-check`

## Important Considerations

### Free Tier Limits
- Spindown: Services spin down after 15 minutes of inactivity
- Build time: Limited to 30 minutes
- Bandwidth: Shared pool
- Upgrade when ready for production

### Cold Starts
- First request after spindown may take 30+ seconds
- Upgrade to paid tier to prevent spindowns

### File Uploads
- Store uploaded files in a cloud service (AWS S3, Cloudinary, etc.)
- The `uploads/` directory on Render is ephemeral (not persistent)

### Database
- MongoDB Atlas free tier limited to 5GB
- Consider upgrading for production use

## Troubleshooting

### Backend Not Starting
- Check logs for MongoDB connection errors
- Verify MongoDB URI is correct
- Ensure JWT_SECRET is set

### Frontend Build Fails
- Check Node version compatibility (requires Node 18+)
- Clear npm cache: `npm cache clean --force`
- Verify REACT_APP_* variables are set

### CORS Errors
- Update `CLIENT_ORIGIN` in backend to include your frontend URL
- Ensure origins are comma-separated with no spaces

### Socket.IO Connection Issues
- Verify `REACT_APP_SOCKET_URL` matches backend URL
- Check browser console for connection errors
- Ensure CORS settings allow WebSocket connections

## Scaling for Production

1. **Upgrade from Free to Paid Tier**
   - Prevents spindown
   - Better performance

2. **Add CDN**
   - Render automatically provides CDN for static sites
   - Configure caching headers

3. **Optimize Images**
   - Compress frontend assets
   - Use responsive images

4. **Database Backups**
   - Enable MongoDB Atlas backups
   - Test recovery procedures

## Useful Commands

**Deploy Changes:**
```bash
git add .
git commit -m "Your commit message"
git push origin main
```

**View Logs:**
- Use Render dashboard or
- Use Render CLI: `render logs -s service-name`

**Restart Service:**
- Use Render dashboard or
- Use CLI: `render restart -s service-name`

## Support

- **Render Docs**: https://render.com/docs
- **MongoDB Atlas**: https://docs.atlas.mongodb.com/
- **Express.js**: https://expressjs.com/
- **React**: https://react.dev/

---

For more information, contact your deployment administrator or refer to the official Render documentation.
