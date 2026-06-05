# RENDER DEPLOYMENT: Step-by-Step Instructions

## STEP 1: Create MongoDB Atlas Account (5 min)
1. Go to https://www.mongodb.com/cloud/atlas
2. Click "Try Free"
3. Sign up with email or Google
4. Create Organization & Project
5. Click "Create a Deployment"
6. Choose "Free" tier (M0)
7. Select region close to you
8. Click "Create Deployment"
9. Set username/password for database user
10. Click "Create User"
11. Add your current IP to whitelist (or allow all for now)
12. Click "Finish and Close"
13. Copy Connection String:
    - Click "Connect" button
    - Click "Drivers"
    - Copy the string
    - Replace `<password>` with your password
    - It should look like: `mongodb+srv://username:password@cluster.mongodb.net/elderly-care?retryWrites=true&w=majority`

## STEP 2: Commit Your Code (2 min)
```bash
cd path/to/your/project

# Make sure everything is committed
git add .
git commit -m "Configure for Render.com deployment"
git push origin main
```

## STEP 3: Sign Up for Render.com (3 min)
1. Go to https://render.com
2. Click "Sign up"
3. Click "Sign up with GitHub"
4. Authorize Render to access your GitHub
5. Complete sign up

## STEP 4: Create Blueprint Deployment (5 min)
1. On Render dashboard, click "New"
2. Click "Blueprint"
3. Connect your repository
4. Select your project
5. Click "Deploy"
6. Wait for services to start building

## STEP 5: Add Environment Variables (5 min)

### For Backend Service (fyp-backend):
1. Click on "fyp-backend" service
2. Go to "Environment" section
3. Click "Edit"
4. Add these variables:

```
NODE_ENV = production

MONGODB_URI = (paste your MongoDB connection string from Step 1)

JWT_SECRET = (generate random: go to https://www.random.org/passwords/ 
              and copy a 32+ character password)

CLIENT_ORIGIN = https://your-frontend-name.onrender.com
                (replace your-frontend-name with your actual frontend URL)

OPENAI_API_KEY = sk-... (only if you have ChatAI feature)
```

5. Click "Save"

### For Frontend Service (fyp-frontend):
1. Click on "fyp-frontend" service
2. Go to "Environment" section
3. Click "Edit"
4. Add these variables:

```
REACT_APP_API_URL = https://your-backend-name.onrender.com/api
                    (replace your-backend-name with actual backend URL)

REACT_APP_SOCKET_URL = https://your-backend-name.onrender.com
                       (same as above)
```

5. Click "Save"

## STEP 6: Deploy (Wait 5-10 minutes)
1. Go back to Services
2. Both services should be "Deploying"
3. Watch the Logs for progress
4. Look for ✓ checkmarks to indicate successful deployment
5. Services should show status "Live" when complete

## STEP 7: Test Your Application (5 min)

### Test Backend:
```bash
# Open your browser and go to:
https://your-backend-name.onrender.com/api/health-check

# You should see:
{"status": "OK", "message": "Backend is running"}
```

### Test Frontend:
1. Open your browser
2. Go to: https://your-frontend-name.onrender.com
3. You should see your app loading
4. Try logging in with test credentials

### Check Logs for Errors:
1. Go to each service
2. Click "Logs" tab
3. Look for error messages
4. Fix any issues (see troubleshooting below)

---

## TROUBLESHOOTING

### "Backend won't start"
**Check logs for:** MongoDB connection error
**Fix:** 
- Verify MONGODB_URI is correct (no extra spaces)
- Verify password has no special characters (if yes, URL encode them)
- Check MongoDB Atlas whitelist includes Render IPs

### "CORS error in browser console"
**Check:** CLIENT_ORIGIN environment variable
**Fix:**
- Add your frontend URL to CLIENT_ORIGIN
- Restart backend service (go to service → Manual Deploy)
- Format should be: https://domain.onrender.com (no trailing slash)

### "Socket.IO won't connect"
**Check:** REACT_APP_SOCKET_URL
**Fix:**
- Should match your backend URL exactly
- Both should be https:// (not http://)
- Restart frontend deployment

### "Frontend shows blank page"
**Check logs in browser (F12 → Console)**
**Fix:**
- Verify REACT_APP_API_URL is correct
- Check if API is accessible
- Clear browser cache and refresh

### "Service keeps spinning down"
**This is normal on FREE tier**
- Services pause after 15 minutes of no activity
- First request takes 30+ seconds
- Upgrade to paid tier (~$7/month) to prevent this

### "Build failed"
**Check build logs for errors**
**Fix:**
- Make sure node_modules exists locally
- Try: `npm install` then `npm run build`
- Check Node version (needs 18+)

---

## TESTING CHECKLIST

After deployment, verify:
- [ ] Frontend loads at https://your-frontend.onrender.com
- [ ] Backend API responds at https://your-backend.onrender.com/api/health-check
- [ ] Can log in with credentials
- [ ] Dashboard displays correctly
- [ ] Real-time features work (Socket.IO)
- [ ] File uploads work (if applicable)
- [ ] No errors in browser console (F12)
- [ ] No errors in Render logs

---

## USEFUL LINKS

**To find your service URLs:**
- Render Dashboard → Service Name → Copy the URL shown

**To update environment variables:**
- Service Settings → Environment → Edit

**To restart a service:**
- Service Page → Manual Deploy

**To view logs:**
- Service Page → Logs tab

**To update your domain:**
- Service Settings → Custom Domain

---

## QUICK REFERENCE: YOUR DEPLOYMENT URLs

After deployment, you'll have:
- **Frontend:** https://fyp-frontend.onrender.com (or your custom domain)
- **Backend:** https://fyp-backend.onrender.com (or your custom domain)
- **Health Check:** https://fyp-backend.onrender.com/api/health-check

---

## NEXT STEPS

1. ✅ Complete this deployment
2. Monitor application for 24 hours
3. Fix any issues that come up
4. Set up custom domain (optional)
5. Consider upgrading to paid tier for production
6. Enable backups in MongoDB Atlas
7. Set up monitoring (optional: UptimeRobot)

---

**Questions?** See the detailed guides:
- RENDER_DEPLOYMENT.md (complete guide)
- API_CONFIG_PRODUCTION.md (API setup)
- MONITORING_MAINTENANCE.md (after deployment)

**Estimated Total Time: 30-45 minutes**

Good luck! 🚀
