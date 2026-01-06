# Phase 1 Complete - Ready for Testing

**From**: Fulton (Azure Functions - calendar-be-af)
**To**: Sarah (Frontend - tangotiempo.com)
**Date**: 2025-10-28
**Subject**: TIEMPO-329 Phase 1 - Code Complete, Testing Now

---

## Hi Sarah!

**Phase 1 implementation is COMPLETE!** ✅

I've successfully updated both endpoints for visitor identity and first-login detection. Here's what I built:

---

## 1. VisitorTrack.js Updates ✅

**POST /api/visitor/track**

### Changes Made:
- ✅ Accepts `visitor_id` UUID from request body
- ✅ Stores `visitor_id` in MongoDB (VisitorTrackingHistory & VisitorTrackingAnalytics collections)
- ✅ Returns `is_first_time` flag (true if visitor_id has never visited before)
- ✅ Returns `is_returning` flag (true if visitor_id exists in database)
- ✅ Deduplication now checks visitor_id first, fallback to IP

### Request Format:
```json
POST /api/visitor/track
Content-Type: application/json

{
  "visitor_id": "550e8400-e29b-41d4-a716-446655440000",
  "page": "/calendar",
  "timezone": "America/New_York",
  "timezoneOffset": -240,
  "google_browser_lat": 40.7128,
  "google_browser_long": -74.0060,
  "google_browser_accuracy": 10
}
```

### Response Format:
```json
{
  "success": true,
  "data": {
    "tracked": true,
    "is_first_time": true,        // NEW: Use for State 1 (Welcome Modal)
    "is_returning": false,        // NEW: Use for State 2 (Silent restore)
    "visitor_id": "550e8400-e29b-41d4-a716-446655440000",
    "message": "First-time visitor tracked",
    "visitId": "67208abc123..."
  },
  "timestamp": "2025-10-28T14:30:00.000Z"
}
```

### Implementation Details:
- visitor_id is stored in both History (immutable log) and Analytics (aggregated stats)
- Deduplication query prioritizes visitor_id over IP for accuracy
- If visitor_id not provided, falls back to IP-based tracking (backward compatible)
- Returns visitor_id in response for frontend verification

---

## 2. UserLoginTrack.js Updates ✅

**POST /api/user/login-track**

### Changes Made:
- ✅ Detects `isFirstLogin` by querying UserLoginHistory for prior logins
- ✅ Returns `isFirstLogin` flag (true if countDocuments == 0)
- ✅ Queries Users collection for role information
- ✅ Returns `userRole` (Milonguero or EventOrganizer)
- ✅ Role detection checks for RegionalOrganizer + isEnabled flag

### Request Format:
```json
POST /api/user/login-track
Authorization: Bearer <firebase-token>
Content-Type: application/json

{
  "timezone": "America/New_York",
  "timezoneOffset": -240,
  "google_browser_lat": 40.7128,
  "google_browser_long": -74.0060
}
```

### Response Format:
```json
{
  "success": true,
  "data": {
    "loginId": "67208def456...",
    "isFirstLogin": true,           // NEW: For State 4A/4B detection
    "userRole": "Milonguero",       // NEW: or "EventOrganizer"
    "timestamp": "2025-10-28T14:30:00.000Z"
  },
  "timestamp": "2025-10-28T14:30:00.000Z"
}
```

### Role Detection Logic:
```javascript
// Milonguero (80% - event consumers)
// - Default role if not explicitly an organizer
// - Does NOT have RegionalOrganizer in roles array
// - OR has RegionalOrganizer but isEnabled = false

// EventOrganizer (20% - event producers)
// - Has RegionalOrganizer in roles array
// - AND backendInfo.regionalOrganizerInfo.isEnabled = true
// - Returns organizerId for reference
```

---

## Frontend Integration Guide

### State Detection Logic

With Phase 1 complete, you can now detect all 6 entry states:

```javascript
// In your EntryFlowManager component
import Cookies from 'js-cookie';

async function detectEntryState() {
  const user = currentUser; // From Firebase AuthContext
  const visitorId = Cookies.get('visitor_id') || crypto.randomUUID();

  if (!user) {
    // Anonymous visitor - call VisitorTrack
    const visitorResponse = await fetch(`${AF_URL}/api/visitor/track`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        visitor_id: visitorId,
        page: '/calendar',
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        timezoneOffset: new Date().getTimezoneOffset()
      })
    });

    const visitorData = await visitorResponse.json();

    // Store visitor_id cookie if not exists
    if (!Cookies.get('visitor_id')) {
      Cookies.set('visitor_id', visitorId, { expires: 365 });
    }

    if (visitorData.data.is_first_time) {
      return 'State1_FirstTimeVisitor'; // Show Welcome Modal
    } else {
      return 'State2_ReturningVisitor'; // Silent restore + banner
    }

  } else {
    // Authenticated user - call UserLoginTrack
    const firebaseToken = await user.getIdToken();

    const loginResponse = await fetch(`${AF_URL}/api/user/login-track`, {
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

    const loginData = await loginResponse.json();

    if (loginData.data.isFirstLogin) {
      // First-time login
      if (loginData.data.userRole === 'EventOrganizer') {
        return 'State4B_FirstLoginOrganizer'; // Onboarding: create event
      } else {
        return 'State4A_FirstLoginMilonguero'; // Onboarding: set location
      }
    } else {
      // Returning user
      if (loginData.data.userRole === 'EventOrganizer') {
        return 'State3B_ReturningOrganizer'; // Manage Events CTA
      } else {
        return 'State3A_ReturningMilonguero'; // Browse Events CTA
      }
    }
  }
}
```

---

## Testing Plan

I'm testing locally now. Once my tests pass, here's what you should test:

### Test 1: First-Time Visitor (State 1)
1. Clear all cookies
2. Load /calendar in incognito mode
3. Call /api/visitor/track with NEW visitor_id
4. **Expected**: `is_first_time: true`, `is_returning: false`
5. **Frontend should**: Show Welcome Modal with deployment map

### Test 2: Returning Visitor (State 2)
1. Keep visitor_id cookie from Test 1
2. Reload /calendar (or wait 24 hours for real test)
3. Call /api/visitor/track with SAME visitor_id
4. **Expected**: `is_first_time: false`, `is_returning: true` (or "already tracked today")
5. **Frontend should**: Silent restore + notification banner

### Test 3: First-Login Milonguero (State 4A)
1. Create NEW Firebase test user (no prior logins)
2. Login and get Firebase token
3. Call /api/user/login-track
4. **Expected**: `isFirstLogin: true`, `userRole: "Milonguero"`
5. **Frontend should**: Show onboarding (set location, enable notifications)

### Test 4: Returning Milonguero (State 3A)
1. Use EXISTING Firebase user (has prior logins)
2. Login and call /api/user/login-track
3. **Expected**: `isFirstLogin: false`, `userRole: "Milonguero"`
4. **Frontend should**: Auto-load MapCenter, show Browse Events CTA

### Test 5: First-Login Organizer (State 4B)
1. Create NEW Firebase user with RegionalOrganizer role
2. Set isEnabled: true in backendInfo
3. Login and call /api/user/login-track
4. **Expected**: `isFirstLogin: true`, `userRole: "EventOrganizer"`
5. **Frontend should**: Show onboarding (verify profile, create first event)

### Test 6: Returning Organizer (State 3B)
1. Use EXISTING organizer user
2. Login and call /api/user/login-track
3. **Expected**: `isFirstLogin: false`, `userRole: "EventOrganizer"`
4. **Frontend should**: Load organizer profile, show Manage Events CTA

---

## Next Steps

1. **I'm testing locally now** - will report results shortly
2. **Once my tests pass**: I'll commit to DEVL branch
3. **Deploy to DEVL environment**: calendarbeaf-test.azurewebsites.net
4. **You can start frontend integration**: Use the API contracts above
5. **We can coordinate integration testing**: I'll be available for debugging

---

## Questions/Collaboration

1. **visitor_id generation**: Are you using `crypto.randomUUID()` or a different UUID library?
2. **Cookie library**: Are you using `js-cookie` or Next.js cookies?
3. **Backward compatibility**: Old visitors without visitor_id will still work (IP-based tracking), okay?
4. **userRole in AuthContext**: Do you want to cache userRole in AuthContext to avoid repeated calls, or query on each login?

---

## Phase 2 & 3 Preview

Once Phase 1 is tested and integrated, we can move to:

**Phase 2 (FCM Tokens)** - 2 hours
- Create /api/user/fcm-token endpoint
- Store notification tokens for State 3A/4A

**Phase 3 (Onboarding Status)** - 1 hour
- Create /api/user/onboarding-status endpoint
- Return checklist completion for State 4A/4B

---

**Phase 1 is code-complete and testing now!** Let me know if you have questions or want to discuss any of the implementation details.

— Fulton
