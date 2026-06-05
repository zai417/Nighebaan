# API Configuration Guide for Production (Render)

## Overview
This guide helps configure API endpoints for production deployment on Render.

## Frontend Configuration

### 1. Environment Variables
Create a `.env.production` file in the root directory:

```env
# API Configuration
REACT_APP_API_URL=https://your-backend-service.onrender.com/api
REACT_APP_SOCKET_URL=https://your-backend-service.onrender.com

# Optional Features
REACT_APP_ENVIRONMENT=production
REACT_APP_LOG_LEVEL=error
```

### 2. Update API Service
Update your `src/services/api.js` or similar:

```javascript
import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:5000/api';
const SOCKET_URL = process.env.REACT_APP_SOCKET_URL || 'http://localhost:5000';

export const apiClient = axios.create({
  baseURL: API_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth token to all requests
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const SOCKET_CONFIG = {
  url: SOCKET_URL,
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionDelayMax: 5000,
  reconnectionAttempts: 5,
};

export default apiClient;
```

### 3. Update Socket.IO Connection
Update your `src/services/socket.js` or similar:

```javascript
import io from 'socket.io-client';

const SOCKET_URL = process.env.REACT_APP_SOCKET_URL || 'http://localhost:5000';

export const socket = io(SOCKET_URL, {
  reconnection: true,
  reconnectionDelay: 1000,
  reconnectionDelayMax: 5000,
  reconnectionAttempts: 5,
  secure: true, // Use SSL/TLS in production
  rejectUnauthorized: false,
});

export default socket;
```

## Mobile App Configuration (React Native)

### Update mobile/services/api.js

```javascript
import axios from 'axios';
import { Platform } from 'react-native';

// Production API URL - set via environment or use default
const PRODUCTION_API = 'https://your-backend-service.onrender.com/api';

const BASE_URL = __DEV__ 
  ? Platform.OS === 'android'
    ? 'http://10.0.2.2:5000/api'
    : 'http://localhost:5000/api'
  : PRODUCTION_API;

const api = axios.create({
  baseURL: BASE_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

export const loginUser = (data) => api.post('/auth/login', data);
export const getAlerts = (token) =>
  api.get('/alerts', {
    headers: { Authorization: `Bearer ${token}` },
  });
export const getPlans = () => api.get('/plans');

export default api;
```

## Backend Configuration

### Backend Environment Variables

The backend uses these key environment variables:

```env
# Core
NODE_ENV=production
PORT=10000

# Database
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/elderly-care?retryWrites=true&w=majority

# Security
JWT_SECRET=your-super-secure-random-string-minimum-32-characters

# CORS - Frontend URLs
CLIENT_ORIGIN=https://your-frontend-service.onrender.com,https://your-domain.com,https://mobile-app-url

# Optional
OPENAI_API_KEY=sk-your-api-key-if-using-chatai
```

### Backend CORS Configuration

Update `backend/server.js` to ensure CORS is properly configured:

```javascript
const allowedOrigins = (process.env.CLIENT_ORIGIN || 
  'http://localhost:3000,http://localhost:3001,http://localhost:3002')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

const io = new Server(server, {
  cors: {
    origin: allowedOrigins,
    methods: ['GET', 'POST'],
    credentials: true,
    allowedHeaders: ['Content-Type', 'Authorization'],
  },
});

app.use(cors({
  origin: allowedOrigins,
  credentials: true,
  optionsSuccessStatus: 200,
}));
```

## Testing Endpoints

### Health Check
```bash
curl https://your-backend-service.onrender.com/api/health-check
```

Should return:
```json
{
  "status": "OK",
  "message": "Backend is running"
}
```

### API Test
```bash
# Login
curl -X POST https://your-backend-service.onrender.com/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password"}'

# Get Health Data (requires auth)
curl -X GET https://your-backend-service.onrender.com/api/health \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## Troubleshooting API Issues

### CORS Errors
**Problem:** `Access to XMLHttpRequest has been blocked by CORS policy`

**Solution:**
1. Verify `CLIENT_ORIGIN` includes your frontend URL
2. Check frontend URL format: `https://domain.onrender.com` (no trailing slash)
3. Restart backend service after updating CLIENT_ORIGIN
4. Check browser console for exact error

### Socket.IO Connection Fails
**Problem:** Socket connection times out or refuses

**Solution:**
1. Verify `REACT_APP_SOCKET_URL` matches backend URL
2. Ensure WebSocket protocol is enabled (Render supports this)
3. Check browser WebSocket connections in DevTools
4. Verify firewall/security settings aren't blocking connections

### API 401 Unauthorized
**Problem:** Auth endpoints return 401

**Solution:**
1. Verify JWT_SECRET is consistent across deployments
2. Check token is being sent in Authorization header
3. Verify token is stored correctly on client
4. Check token expiration time

### API 500 Server Error
**Problem:** Backend returns 500 errors

**Solution:**
1. Check backend logs in Render dashboard
2. Verify MongoDB connection
3. Check JWT_SECRET and API_KEY environment variables
4. Verify file upload directory exists (or use cloud storage)

## Performance Optimization

### Frontend
```javascript
// Minimize API calls
const useQuery = (url, options = {}) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    const cache = sessionStorage.getItem(url);
    if (cache) {
      setData(JSON.parse(cache));
      setLoading(false);
      return;
    }
    
    apiClient.get(url).then(res => {
      sessionStorage.setItem(url, JSON.stringify(res.data));
      setData(res.data);
      setLoading(false);
    });
  }, [url]);
  
  return { data, loading };
};
```

### Backend
- Add request logging
- Implement caching for frequently accessed data
- Use database indexes for common queries
- Optimize Socket.IO events

## Security Best Practices

1. ✅ Never commit `.env` files
2. ✅ Use HTTPS only in production
3. ✅ Validate all user input
4. ✅ Use secure JWT secrets (min 32 chars)
5. ✅ Implement rate limiting
6. ✅ Keep dependencies updated
7. ✅ Use environment-specific configs

---

For more information, see [RENDER_DEPLOYMENT.md](RENDER_DEPLOYMENT.md)
