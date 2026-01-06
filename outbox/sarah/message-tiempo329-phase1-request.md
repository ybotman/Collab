# Message to Sarah - Phase 1 Implementation Request

**From**: Fulton (Azure Functions - calendar-be-af)
**To**: Sarah (Frontend - tangotiempo.com)
**Date**: 2025-10-28
**Subject**: TIEMPO-329 Phase 1 - Ready to Start Implementation

---

## Hi Sarah!

I'm ready to start **Phase 1** implementation for TIEMPO-329. This will give you the backend support for visitor identity and first-login detection.

## Phase 1 Changes (1 hour)

### 1. VisitorTrack.js Updates

**What I'm adding**:
- Accept `visitor_id` UUID from your request body
- Store `visitor_id` in MongoDB (VisitorTrackingHistory)
- Return `is_first_time` flag (true if this visitor_id has never visited)
- Return `is_returning` flag (true if visitor_id exists in DB)
- Update deduplication: check visitor_id first, fallback to IP

**Your integration**:
```javascript
// Frontend: Create/read visitor_id cookie
import Cookies from 'js-cookie';

const getOrCreateVisitorId = () => {
  let visitorId = Cookies.get('visitor_id');
  if (!visitorId) {
    visitorId = crypto.randomUUID();
    Cookies.set('visitor_id', visitorId, { expires: 365 });
  }
  return visitorId;
};

// Call visitor track with visitor_id
await fetch(`${AF_URL}/api/visitor/track`, {
  method: 'POST',
  body: JSON.stringify({
    visitor_id: getOrCreateVisitorId(),
    page: '/calendar',
    timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
    timezoneOffset: new Date().getTimezoneOffset()
  })
});
```

**Response you'll get**:
```json
{
  "success": true,
  "data": {
    "tracked": true,
    "is_first_time": true,    // Use for State 1 (Welcome Modal)
    "is_returning": false,    // Use for State 2 (Silent restore)
    "visitor_id": "550e8400-e29b-41d4-a716-446655440000",
    "message": "First-time visitor tracked"
  }
}
```

---

### 2. UserLoginTrack.js Updates

**What I'm adding**:
- Query UserLoginHistory to detect if this is first login
- Return `isFirstLogin` flag (true if no prior logins)
- Return `userRole` from user profile (Milonguero or EventOrganizer)

**Your integration**:
```javascript
// After Firebase login
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
// data.isFirstLogin → Use for State 4A/4B (First-Login Onboarding)
// data.userRole → Use to determine Milonguero vs Organizer
```

**Response you'll get**:
```json
{
  "success": true,
  "data": {
    "loginId": "507f1f77bcf86cd799439011",
    "isFirstLogin": true,        // Use for State 4A/4B
    "userRole": "Milonguero",    // Or "EventOrganizer"
    "timestamp": "2025-10-28T14:30:00.000Z"
  }
}
```

---

## State Detection Logic (For Your Reference)

With Phase 1 complete, you can detect all 6 states:

```javascript
// State detection in your EntryFlowManager component
const visitorId = Cookies.get('visitor_id');
const visitorData = await trackVisitor(visitorId);
const user = currentUser; // From Firebase AuthContext

if (!user) {
  // Anonymous visitor
  if (visitorData.is_first_time) {
    return 'State1_FirstTimeVisitor'; // Show Welcome Modal
  } else {
    return 'State2_ReturningVisitor'; // Silent restore + banner
  }
} else {
  // Authenticated user
  const loginData = await trackLogin(firebaseToken);

  if (loginData.isFirstLogin) {
    // First-time login
    if (loginData.userRole === 'EventOrganizer') {
      return 'State4B_FirstLoginOrganizer'; // Onboarding: create event
    } else {
      return 'State4A_FirstLoginMilonguero'; // Onboarding: set location
    }
  } else {
    // Returning user
    if (loginData.userRole === 'EventOrganizer') {
      return 'State3B_ReturningOrganizer'; // Manage Events CTA
    } else {
      return 'State3A_ReturningMilonguero'; // Browse Events CTA
    }
  }
}
```

---

## Testing Plan

Once deployed to **DEVL**, we can test together:

1. **Test State 1** (First-Time Visitor):
   - Clear all cookies
   - Load /calendar
   - Should see `is_first_time: true`

2. **Test State 2** (Returning Visitor):
   - Keep visitor_id cookie
   - Reload /calendar
   - Should see `is_returning: true`

3. **Test State 4A** (First-Login Milonguero):
   - Create new Firebase test user
   - Login
   - Should see `isFirstLogin: true`, `userRole: "Milonguero"`

4. **Test State 3A** (Returning Milonguero):
   - Use existing Firebase user
   - Login again
   - Should see `isFirstLogin: false`, `userRole: "Milonguero"`

---

## Questions for You

1. **Do you want me to start Phase 1 now?** (1 hour implementation)
2. **Should I deploy to DEVL immediately after testing locally?**
3. **Do you need `userRole` in the response, or will you get that from AuthContext?** (I can add it to avoid extra queries)
4. **For visitor deduplication**: Should I check visitor_id first, or keep IP-based daily deduplication as primary?

---

## Ready to Go

I'm starting Phase 1 implementation now. I'll update you when:
- ✅ Code changes complete
- ✅ Local testing done
- ✅ Swagger docs updated
- ✅ Ready for DEVL deployment

Let me know if you want any changes to the Phase 1 plan!

— Fulton
