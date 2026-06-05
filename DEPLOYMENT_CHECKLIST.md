# Pre-Deployment Checklist

## Code Quality
- [ ] All tests pass locally
- [ ] No console errors or warnings
- [ ] Code follows project conventions
- [ ] No hardcoded credentials or API keys

## Frontend Preparation
- [ ] Environment variables defined in `.env.example`
- [ ] API endpoints point to backend service
- [ ] Socket.IO client configured correctly
- [ ] Error handling implemented
- [ ] CORS headers configured

## Backend Preparation
- [ ] Environment variables defined in `.env.example`
- [ ] Database connection string validated
- [ ] JWT secret configured
- [ ] CORS origins updated for production
- [ ] Error handling and logging in place
- [ ] Database indexes created
- [ ] Upload directory handling configured

## Database
- [ ] MongoDB Atlas account created
- [ ] Free tier cluster provisioned (or paid for production)
- [ ] User credentials created
- [ ] Whitelist Render IPs (or allow all in free tier)
- [ ] Connection string copied
- [ ] Database collections initialized (if needed)

## Render Configuration
- [ ] Git repository is public and connected
- [ ] `render.yaml` file created and committed
- [ ] `.env.example` file committed (not `.env`)
- [ ] `.gitignore` includes `.env` and `node_modules/`
- [ ] All necessary files committed to repository

## Environment Variables
Backend:
- [ ] NODE_ENV = production
- [ ] MONGODB_URI = (from MongoDB Atlas)
- [ ] JWT_SECRET = (generate secure random string)
- [ ] CLIENT_ORIGIN = (add your frontend URL)
- [ ] OPENAI_API_KEY = (if using ChatAI feature)

Frontend:
- [ ] REACT_APP_API_URL = (your backend URL + /api)
- [ ] REACT_APP_SOCKET_URL = (your backend URL)

## Post-Deployment Testing
- [ ] Frontend loads without errors
- [ ] Login/authentication works
- [ ] API calls succeed
- [ ] Socket.IO connection established
- [ ] Database queries work
- [ ] File uploads work (if applicable)
- [ ] Error pages display correctly
- [ ] Mobile responsive design verified

## Monitoring
- [ ] Set up error tracking (optional: Sentry, etc.)
- [ ] Monitor server logs regularly
- [ ] Check error rates
- [ ] Monitor database usage

---

Complete this checklist before deployment to ensure smooth operation!
