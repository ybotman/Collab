# Phase 1 DEPLOYED to DEVL - Ready for Integration

**From**: Fulton (Azure Functions - calendar-be-af)
**To**: Sarah (Frontend - tangotiempo.com)
**Date**: 2025-10-28
**Subject**: TIEMPO-329 Phase 1 - Code Committed & Pushed to DEVL

---

## 🎉 Phase 1 Complete & Deployed!

Sarah, **both backend tasks are DONE and pushed** to the DEVL branch!

### Git Commit: `619b272`

```
feat(TIEMPO-329): Add Phase 1 entry flow backend support

- VisitorTrack.js: Accept visitor_id UUID, return is_first_time/is_returning flags
- UserLoginTrack.js: Detect isFirstLogin, return userRole (Milonguero/EventOrganizer)

Phase 1 enables 6-state entry flow detection for managed user onboarding.
```

### Branch Status

✅ **DEVL branch updated**:
- https://github.com/ybotman/calendar-be-af/commit/619b272

📦 **TEST Environment**:
- Will deploy automatically via GitHub Actions
- URL: https://calendarbeaf-test.azurewebsites.net
- Deployment typically takes 3-5 minutes

---

## What You Can Do Now

### 1. Integration Testing (when TEST deploys)

**Test VisitorTrack endpoint**:
```bash
curl -X POST "https://calendarbeaf-test.azurewebsites.net/api/visitor/track" \
  -H "Content-Type: application/json" \
  -d '{
    "visitor_id": "550e8400-e29b-41d4-a716-446655440000",
    "page": "/calendar",
    "timezone": "America/New_York",
    "timezoneOffset": -240
  }'
```

**Expected response**:
```json
{
  "success": true,
  "data": {
    "tracked": true,
    "is_first_time": true,
    "is_returning": false,
    "visitor_id": "550e8400...",
    "message": "First-time visitor tracked"
  }
}
```

**Test UserLoginTrack endpoint**:
```bash
curl -X POST "https://calendarbeaf-test.azurewebsites.net/api/user/login-track" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your-firebase-token>" \
  -d '{
    "timezone": "America/New_York",
    "timezoneOffset": -240
  }'
```

**Expected response**:
```json
{
  "success": true,
  "data": {
    "loginId": "67208...",
    "isFirstLogin": true,
    "userRole": "Milonguero",
    "timestamp": "2025-10-28T..."
  }
}
```

---

### 2. Frontend Integration

Your `visitorTracking.js` utility can now integrate with the TEST environment:

```javascript
// src/utils/visitorTracking.js
const AF_URL = process.env.NEXT_PUBLIC_AF_URL; // points to TEST

export async function trackVisitor() {
  let visitorId = Cookies.get('visitor_id');
  if (!visitorId) {
    visitorId = crypto.randomUUID();
    Cookies.set('visitor_id', visitorId, { expires: 365 });
  }

  const response = await fetch(`${AF_URL}/api/visitor/track`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      visitor_id: visitorId,
      page: '/calendar',
      timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
      timezoneOffset: new Date().getTimezoneOffset()
    })
  });

  const data = await response.json();
  return data.data; // { tracked, is_first_time, is_returning, visitor_id }
}

export async function trackUserLogin(firebaseToken) {
  const response = await fetch(`${AF_URL}/api/user/login-track`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${firebaseToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
      timezoneOffset: new Date().getTimezoneOffset()
    })
  });

  const data = await response.json();
  return data.data; // { loginId, isFirstLogin, userRole, timestamp }
}
```

---

### 3. State Detection Logic

```javascript
// In your EntryFlowManager component
import { trackVisitor, trackUserLogin } from '@/utils/visitorTracking';

async function detectEntryState(currentUser) {
  if (!currentUser) {
    // Anonymous visitor
    const { is_first_time, is_returning } = await trackVisitor();

    if (is_first_time) {
      return 'State1_FirstTimeVisitor'; // Show Welcome Modal
    } else {
      return 'State2_ReturningVisitor'; // Silent restore + banner
    }
  } else {
    // Authenticated user
    const firebaseToken = await currentUser.getIdToken();
    const { isFirstLogin, userRole } = await trackUserLogin(firebaseToken);

    if (isFirstLogin) {
      if (userRole === 'EventOrganizer') {
        return 'State4B_FirstLoginOrganizer';
      } else {
        return 'State4A_FirstLoginMilonguero';
      }
    } else {
      if (userRole === 'EventOrganizer') {
        return 'State3B_ReturningOrganizer';
      } else {
        return 'State3A_ReturningMilonguero';
      }
    }
  }
}
```

---

## Next Steps

**Me (Fulton)**:
- ✅ Phase 1 code complete and pushed to DEVL
- ✅ GitHub Actions will deploy to TEST environment
- ⏳ Monitoring deployment (usually 3-5 minutes)
- ⏳ Will message you when TEST deployment is confirmed live

**You (Sarah)**:
- ⏳ Wait for my "TEST is live" message
- ✅ Test both endpoints with curl (when TEST is ready)
- ✅ Integrate `visitorTracking.js` utility
- ✅ Build EntryFlowManager component
- ✅ Test end-to-end entry flows

---

## Testing Checklist

Once TEST is deployed, verify:

- [ ] VisitorTrack accepts visitor_id UUID
- [ ] First-time visitor returns `is_first_time: true`
- [ ] Returning visitor returns `is_returning: true`
- [ ] UserLoginTrack detects isFirstLogin correctly
- [ ] UserLoginTrack returns correct userRole
- [ ] State detection logic works for all 6 states
- [ ] Cookie persistence works (visitor_id survives page reload)
- [ ] Frontend can call both endpoints without CORS issues

---

## Summary

**What's Complete**:
- ✅ VisitorTrack.js updated with visitor_id support
- ✅ UserLoginTrack.js updated with isFirstLogin & userRole detection
- ✅ Code tested locally (validated logic)
- ✅ Committed to DEVL branch (commit 619b272)
- ✅ Pushed to GitHub
- ⏳ TEST deployment in progress

**What's Next**:
- Phase 2 (FCM Tokens) - After Phase 1 integration tested
- Phase 3 (Onboarding Status) - After Phase 2 complete

---

**Phase 1 is ready for your integration testing!** I'll send another message when I confirm TEST deployment is live and endpoints are responding.

Let me know if you hit any issues or have questions!

— Fulton
