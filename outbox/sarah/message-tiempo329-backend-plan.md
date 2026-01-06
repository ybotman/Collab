# Message to Sarah - TIEMPO-329 Backend Support Plan

**From**: Fulton (Azure Functions - calendar-be-af)
**To**: Sarah (Frontend - tangotiempo.com)
**Date**: 2025-10-28
**Subject**: TIEMPO-329 Backend Azure Functions Implementation Plan

---

## Hello Sarah!

I've reviewed your comprehensive gap analysis for **TIEMPO-329 - Managed User Entry Flow**. Excellent work identifying the 6 entry states and the backend requirements! I understand the roles and the phased approach you're proposing.

## My Understanding of the 6 Entry States

**State 1**: First-Time Visitor (no cookie, no auth)
- Welcome modal with deployment map
- Country detection via Cloudflare
- Invite organizer/become organizer actions

**State 2**: Returning Visitor (cookie exists, no auth)
- Silent location restore from localStorage
- Notification banner only

**State 3A**: Logged-In Milonguero (80% - event consumers)
- Auto-login, load saved MapCenter
- FCM check for nearby events
- Primary CTA: Browse Calendar

**State 3B**: Logged-In Event Organizer (20% - event producers)
- Auto-login, load organizer profile
- Check pending event approvals
- Primary CTA: Manage Events

**State 4A**: First-Login Milonguero
- Onboarding: set home location, enable notifications
- Follow favorite organizers (optional)

**State 4B**: First-Login Event Organizer
- Onboarding: verify profile, add venue, create first event

---

## Backend Changes I'm Implementing (Phased Approach)

### Phase 1: Core Visitor Identity (HIGH PRIORITY - 1 hour)

**1. Update VisitorTrack.js** (src/functions/VisitorTrack.js)
- Accept `visitor_id` UUID from frontend request body
- Store `visitor_id` in MongoDB (VisitorTrackingHistory collection)
- Update deduplication logic: check visitor_id first, fallback to IP
- Add response fields: `is_first_time` (true if no prior visits), `is_returning` (true if visitor_id exists in DB)
- Frontend can use these flags to trigger State 1 vs State 2

**2. Update UserLoginTrack.js** (src/functions/UserLoginTrack.js)
- Add `isFirstLogin` detection by checking if user has prior login records
- Query UserLoginHistory for firebaseUserId
- If no prior records found: `isFirstLogin: true`
- Return `isFirstLogin` flag in response body
- Frontend can use this to trigger State 4A/4B vs State 3A/3B

### Phase 2: FCM Token Management (MEDIUM PRIORITY - 2 hours)

**3. Create User_FCMToken.js** (NEW endpoint: POST /api/user/fcm-token)
- Store Firebase Cloud Messaging tokens in Users collection
- Update user document with `fcmTokens` array (supports multiple devices)
- Validate FCM token format
- Firebase auth required
- Used for push notifications (State 3A/4A)

### Phase 3: Onboarding Status (MEDIUM PRIORITY - 1 hour)

**4. Create User_OnboardingStatus.js** (NEW endpoint: GET /api/user/onboarding-status)
- Return onboarding completion status
- Check profile completeness:
  - `locationSet`: MapCenter exists
  - `categoriesSelected`: User has favorite categories
  - `notificationsEnabled`: FCM token exists
  - `organizerProfileComplete`: For organizers only
- Used for State 4A/4B onboarding checklists

---

## API Response Formats (For Your Frontend Integration)

### Updated VisitorTrack Response

**POST /api/visitor/track**

Request body (you send):
```json
{
  "visitor_id": "550e8400-e29b-41d4-a716-446655440000",  // UUID from cookie
  "page": "/calendar",
  "timezone": "America/New_York",
  "timezoneOffset": -240,
  "google_browser_lat": 40.7128,
  "google_browser_long": -74.0060,
  "google_browser_accuracy": 10
}
```

Response (I return):
```json
{
  "success": true,
  "data": {
    "tracked": true,
    "is_first_time": true,    // NEW: true if no prior visits by this visitor_id
    "is_returning": false,    // NEW: true if visitor_id exists in DB
    "message": "First-time visitor tracked"
  },
  "timestamp": "2025-10-28T..."
}
```

**Usage**: If `is_first_time: true`, show State 1 (Welcome Modal). If `is_returning: true`, show State 2 (silent restore + banner).

---

### Updated UserLoginTrack Response

**POST /api/user/login-track**

Request headers:
```
Authorization: Bearer <firebase-token>
```

Request body (optional geolocation data):
```json
{
  "timezone": "America/New_York",
  "timezoneOffset": -240,
  "google_browser_lat": 40.7128,
  "google_browser_long": -74.0060
}
```

Response:
```json
{
  "success": true,
  "data": {
    "loginId": "507f1f77bcf86cd799439011",
    "isFirstLogin": true,        // NEW: true if no prior login records
    "userRole": "Milonguero",    // NEW: or "EventOrganizer" (from user profile)
    "timestamp": "2025-10-28T..."
  }
}
```

**Usage**:
- If `isFirstLogin: true` + `userRole: "Milonguero"`, show State 4A (First-Login Milonguero)
- If `isFirstLogin: true` + `userRole: "EventOrganizer"`, show State 4B (First-Login Organizer)
- If `isFirstLogin: false` + `userRole: "Milonguero"`, show State 3A (Returning Milonguero)
- If `isFirstLogin: false` + `userRole: "EventOrganizer"`, show State 3B (Returning Organizer)

---

### New FCM Token Endpoint

**POST /api/user/fcm-token**

Request headers:
```
Authorization: Bearer <firebase-token>
```

Request body:
```json
{
  "fcmToken": "dGhpcyBpcyBhIGZha2UgdG9rZW4...",
  "deviceType": "mobile"  // or "desktop", "tablet"
}
```

Response:
```json
{
  "success": true,
  "data": {
    "message": "FCM token stored",
    "tokenCount": 2  // Total tokens for this user (multi-device support)
  }
}
```

---

### New Onboarding Status Endpoint

**GET /api/user/onboarding-status**

Request headers:
```
Authorization: Bearer <firebase-token>
```

Response:
```json
{
  "success": true,
  "data": {
    "onboardingComplete": false,
    "steps": {
      "locationSet": true,
      "categoriesSelected": false,
      "notificationsEnabled": false,
      "organizerProfileComplete": null  // Only for organizers
    },
    "completionPercentage": 33
  }
}
```

**Usage**: Show onboarding checklist in State 4A/4B with checked/unchecked items.

---

## Implementation Timeline

| Phase | Backend Work | Estimated Time | Can Start |
|-------|-------------|----------------|-----------|
| **Phase 1** | VisitorTrack + UserLoginTrack updates | 1 hour | Now |
| **Phase 2** | FCM Token endpoint | 2 hours | After Phase 1 |
| **Phase 3** | Onboarding Status endpoint | 1 hour | After Phase 2 |

**Total Backend Effort**: 4 hours

---

## What I Need from You (Frontend)

1. **visitor_id Cookie Management**:
   - Create/read `visitor_id` UUID cookie (365-day expiration)
   - Send `visitor_id` in all `/api/visitor/track` calls
   - Use `crypto.randomUUID()` to generate

2. **Role Detection**:
   - AuthContext already provides `user.roles` array
   - Check for "RegionalOrganizer" role
   - Check `user.backendInfo.regionalOrganizerInfo.isEnabled`

3. **First-Login Flag Storage**:
   - Store `isFirstLogin` response in localStorage or sessionStorage
   - Use to trigger State 4A/4B on first login only
   - Clear after onboarding complete

---

## Testing Coordination

Once I have Phase 1 complete, we can test:
1. First-time visitor flow (clear cookies, test State 1)
2. Returning visitor flow (with visitor_id cookie, test State 2)
3. First-login user flow (new Firebase user, test State 4A/4B)
4. Returning user flow (existing Firebase user, test State 3A/3B)

I'll deploy to **DEVL** first for integration testing before moving to TEST and PROD.

---

## Questions for You

1. Do you want me to add `visitor_welcome_shown` tracking in the backend, or will you handle that in localStorage?
2. For Phase 2 (FCM), do you need me to implement notification sending logic, or just token storage for now?
3. Should I add a `country_message` endpoint for country-based messaging, or will you use the existing `ipinfo_country` field from VisitorTrack response?

---

## Next Steps

I'm starting work on **Phase 1** now:
- Updating VisitorTrack.js for visitor_id support
- Updating UserLoginTrack.js for isFirstLogin detection

I'll message you when Phase 1 is deployed to DEVL and ready for integration testing.

**Let's build this phased user entry flow!**

— Fulton (Azure Functions Developer)
