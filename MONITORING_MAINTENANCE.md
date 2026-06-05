# Monitoring & Maintenance Guide for Render

## Application Monitoring

### 1. Real-Time Logs
**In Render Dashboard:**
- Navigate to each service (Backend, Frontend)
- Click "Logs" tab
- View real-time application output
- Filter by severity level

### Important Log Messages to Watch For

**Backend Startup:**
```
✓ Server is running on port 10000
✓ MongoDB connected successfully
✓ Socket.IO is running
```

**Errors to Monitor:**
```
✗ MongoDB connection failed
SIGTERM received
Socket connection error
CORS error
Authentication failed
```

### 2. Service Status Monitoring

**Manual Health Checks:**
```bash
# Backend health check
curl https://your-backend-url.onrender.com/api/health-check

# Expected response:
# {"status": "OK", "message": "Backend is running"}
```

**Automated Status Page:**
- Render dashboard shows service status
- Green = Running
- Yellow = Building
- Red = Failed

### 3. Error Tracking (Optional)

For production monitoring, consider adding:

**Option A: Sentry.io (Free tier available)**
```bash
npm install @sentry/react @sentry/tracing
```

Update `src/index.js`:
```javascript
import * as Sentry from "@sentry/react";
import { BrowserTracing } from "@sentry/tracing";

Sentry.init({
  dsn: process.env.REACT_APP_SENTRY_DSN,
  integrations: [new BrowserTracing()],
  tracesSampleRate: 1.0,
  environment: process.env.NODE_ENV,
});
```

**Option B: LogRocket (Session recording)**
```bash
npm install logrocket
```

## Database Maintenance

### MongoDB Atlas Monitoring

**1. Check Database Stats**
- Log in to MongoDB Atlas
- Go to Clusters > your-cluster
- Check storage usage
- Monitor query performance

**2. Backup Strategy**

**Free Tier (Manual):**
```bash
# Export data
mongoexport --uri="mongodb+srv://user:pass@cluster.mongodb.net/elderly-care" \
  --collection users --out users.json

# Import data
mongoimport --uri="mongodb+srv://user:pass@cluster.mongodb.net/elderly-care" \
  --collection users --file users.json
```

**Paid Tier (Automatic):**
- Enable continuous backup in Atlas
- Retention: 7+ days
- Test restore procedures monthly

### Database Performance

**Indexes to Monitor:**
```javascript
// Check indexes in MongoDB Atlas:
// Collections > Select Collection > Indexes

// Important indexes for elderly-care:
// - User.email (unique)
// - Alert.userId + createdAt
// - HealthData.userId + timestamp
```

## Uptime & Performance

### Response Time Monitoring

**Check via Browser DevTools:**
1. Open DevTools (F12)
2. Network tab
3. Check response times:
   - API: Should be < 200ms
   - Assets: Should be < 500ms
   - WebSocket: Should connect < 1s

### Performance Metrics

**Frontend:**
- First Contentful Paint (FCP): Target < 1.5s
- Largest Contentful Paint (LCP): Target < 2.5s
- Cumulative Layout Shift (CLS): Target < 0.1

**Backend:**
- API response time: Target < 200ms
- Database query time: Target < 100ms
- Spike recovery: Target < 5 minutes

## Memory & CPU Usage

**In Render Dashboard:**
- No direct metrics on free tier
- Watch for "Spinning up" messages (indicates spindown)
- Upgrade to paid for detailed metrics

**Free Tier Limitations:**
- 512 MB RAM per service
- Shared CPU
- Spindown after 15 min inactivity

**Paid Tier Benefits:**
- 1+ GB RAM per service
- Dedicated CPU
- No spindown
- Persistent resources

## Common Issues & Solutions

### Service Keeps Spinning Down (Free Tier)
**Symptoms:**
- "Service spinning up..." message
- First request takes 30+ seconds
- Other requests fast

**Solution:**
- Upgrade to paid tier (~$7/service/month)
- Or accept spindown (okay for development)
- Use keep-alive pings in production

### High Memory Usage
**Symptoms:**
- Service crashes after running for hours
- OOM (Out of Memory) in logs

**Solutions:**
```javascript
// Add memory monitoring to backend
setInterval(() => {
  const used = process.memoryUsage();
  console.log(`Memory: ${Math.round(used.heapUsed / 1024 / 1024)} MB`);
}, 60000);

// Limit socket.io connections
io.engine.maxHttpBufferSize = 1e6; // 1MB
```

### Database Connection Timeouts
**Symptoms:**
- "ECONNREFUSED" in logs
- API returns 500 errors
- Health check fails

**Solutions:**
1. Check MongoDB Atlas whitelist (add Render IPs)
2. Verify connection string is correct
3. Check network status at mongodb.com/status
4. Restart backend service

### CORS Errors
**Symptoms:**
- Browser console: "CORS policy blocked"
- API calls fail from frontend

**Solutions:**
```bash
# 1. Update CLIENT_ORIGIN in Render environment:
CLIENT_ORIGIN=https://frontend-url.onrender.com,https://custom-domain.com

# 2. Restart backend service after update

# 3. Test with curl:
curl -X OPTIONS https://backend-url.onrender.com/api/health \
  -H "Origin: https://frontend-url.onrender.com" \
  -H "Access-Control-Request-Method: GET"
```

## Performance Optimization Tips

### Frontend
1. Code splitting with React.lazy()
2. Image optimization (compress, WebP)
3. Cache API responses locally
4. Minimize bundle size

### Backend
1. Add database query caching
2. Implement rate limiting
3. Use connection pooling
4. Optimize Socket.IO messages

### Database
1. Create proper indexes
2. Archive old data
3. Clean up orphaned documents
4. Monitor query patterns

## Alerting Setup (Recommended)

**For Uptime Monitoring:**
1. Use UptimeRobot (free tier)
2. Set health check endpoint: `https://your-backend.onrender.com/api/health-check`
3. Configure alerts for failures
4. Get notifications via email/SMS

**Setup:**
- Go to uptimerobot.com
- Create account
- Add monitor for API endpoint
- Set check interval: Every 5 minutes
- Alerts to: Your email

## Maintenance Schedule

**Daily:**
- Check logs for errors
- Monitor API response times
- Quick uptime verification

**Weekly:**
- Review database usage
- Check error rates
- Monitor user activity patterns

**Monthly:**
- Update dependencies
- Review security logs
- Performance analysis
- Backup verification

**Quarterly:**
- Security audit
- Database optimization
- Load testing
- Disaster recovery drill

## Scaling for Production

**When to Upgrade from Free Tier:**
- ✓ More than 100 daily active users
- ✓ Need persistent uptime (no spindown)
- ✓ Database exceeding 1GB
- ✓ API response time critical
- ✓ Expecting traffic spikes

**Paid Tier:**
- ~$7/service/month (minimum)
- Better performance
- No spindown
- Priority support
- Advanced metrics

## Emergency Procedures

### Service Down Checklist

1. **Check Status**
   ```bash
   curl -I https://your-backend.onrender.com/api/health-check
   ```

2. **Check Logs** → Render Dashboard > Logs

3. **Common Fixes**
   - Restart service: Dashboard > Service > Manual Deploy
   - Check environment variables
   - Verify MongoDB connection
   - Review recent deployments

4. **If Not Resolved**
   - Check Render status page
   - Review error logs for root cause
   - Rollback to previous working version
   - Contact Render support if needed

---

**Questions?** See [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md) or Render docs: https://render.com/docs
