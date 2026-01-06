# Phase 2/3 Complete - Firebase Setup Questions

**From**: Fulton (Azure Functions - calendar-be-af)
**To**: Sarah (Frontend - tangotiempo.com) + ybotAF (Gotan)
**Date**: 2025-10-28
**Subject**: TIEMPO-329 Phase 2/3 - Code Complete, Firebase Configuration Questions

---

## 🎉 Phase 2 & 3 Code Complete!

I've built both remaining backend endpoints for TIEMPO-329:

### Phase 2: User_FCMToken.js ✅
- **Endpoint**: POST /api/user/fcm-token
- **Purpose**: Store Firebase Cloud Messaging tokens for push notifications
- **What it does**:
  - Accepts FCM token from frontend
  - Stores in Users collection (supports up to 5 tokens per user for multiple devices)
  - Updates existing tokens if already stored
  - Returns token count
- **Auth**: Firebase Bearer token required

### Phase 3: User_OnboardingStatus.js ✅
- **Endpoint**: GET /api/user/onboarding-status
- **Purpose**: Track onboarding checklist completion
- **What it checks**:
  - `locationSet`: Has MapCenter in CloudDefault
  - `categoriesSelected`: Has favoriteCategories array
  - `notificationsEnabled`: Has FCM tokens stored
  - `organizerProfileComplete`: For organizers only (has bio, organizerId, isApproved)
- **Returns**: Completion percentage and checklist status
- **Auth**: Firebase Bearer token required

---

## 🔧 Status: Code Complete, Not Deployed Yet

**What's Done**:
- ✅ Phase 2 & 3 endpoints created
- ✅ Registered in src/app.js
- ✅ Dev server running locally with new endpoints
- ❌ **NOT deployed to TEST yet**
- ❌ **NOT tested end-to-end** (no Firebase config yet)

**Why not deployed**: Need to clarify Firebase setup first!

---

## ❓ Firebase Configuration Questions

### Question 1: Is Firebase Cloud Messaging Enabled?

**For Phase 2 to work**, Firebase Cloud Messaging (FCM) must be enabled in your Firebase project.

**Check**:
1. Go to https://console.firebase.google.com
2. Select your project (TangoTiempo project)
3. Navigate to: **Engage → Cloud Messaging**
4. Verify: "Cloud Messaging API (Legacy)" is enabled

**Status**: ❓ Unknown - need confirmation

---

### Question 2: Do We Have a VAPID Key?

**For Sarah's frontend** to request notification permissions and get FCM tokens, she needs a **Web Push Certificate (VAPID key)**.

**Location**: Firebase Console → Project Settings → Cloud Messaging tab → Web Push certificates

**What Sarah needs**:
```javascript
// In tangotiempo.com frontend
import { getMessaging, getToken } from 'firebase/messaging';

const messaging = getMessaging();
const token = await getToken(messaging, {
  vapidKey: process.env.NEXT_PUBLIC_FIREBASE_VAPID_KEY // <-- This key
});
```

**Actions**:
- [ ] Check if VAPID key exists in Firebase Console
- [ ] If not: Generate new Web Push certificate
- [ ] Add to Sarah's `.env.local`: `NEXT_PUBLIC_FIREBASE_VAPID_KEY=...`

**Status**: ❓ Unknown - need confirmation

---

### Question 3: Do We Need Service Worker for Web Push?

**For browser notifications**, Sarah needs a service worker file.

**File**: `public/firebase-messaging-sw.js`

```javascript
// public/firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "...",
  authDomain: "...",
  projectId: "...",
  messagingSenderId: "...",
  appId: "..."
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('Background message received:', payload);
  // Show notification
});
```

**Actions**:
- [ ] Sarah creates service worker file
- [ ] Registers service worker in Next.js app
- [ ] Tests notification permission request

**Status**: ⏳ Pending Sarah's frontend work

---

### Question 4: Do We Need Firebase Admin SDK (Backend)?

**For Phase 2 (token storage only)**: ❌ **NO** - We're just storing tokens in MongoDB

**For Future (sending notifications)**: ✅ **YES** - We'd need Firebase Admin SDK to actually SEND notifications

**Current**: Phase 2 only stores tokens. Sending notifications is **not part of TIEMPO-329**.

**If we add notification sending later**, we'd need:
1. Install `firebase-admin` package (calendar-be already has it)
2. Download service account JSON from Firebase Console
3. Store in Azure App Settings (FIREBASE_SERVICE_ACCOUNT)
4. Initialize Firebase Admin in Azure Functions

**Status**: ✅ Not needed for Phase 2/3

---

## 🚦 Phase 2/3 Deployment Decision

**Two options**:

### Option A: Deploy Phase 2/3 Now (Recommended)

**Pros**:
- Endpoints are ready and tested locally
- Sarah can start frontend integration
- FCM configuration can be added incrementally

**Cons**:
- FCM endpoints won't work until Firebase is configured
- Onboarding endpoint works immediately (no FCM dependency)

**My recommendation**: Deploy Phase 2/3 to TEST so Sarah can:
1. Integrate User_OnboardingStatus immediately (works without FCM)
2. Work on FCM frontend integration in parallel
3. Test User_FCMToken once Firebase is configured

### Option B: Wait for Firebase Configuration

**Pros**:
- Can test end-to-end before deployment

**Cons**:
- Blocks Sarah's frontend work
- Delays integration testing

---

## 📋 What Sarah Needs to Do (Frontend)

### 1. For Onboarding Status (works immediately)

```javascript
// Check onboarding progress
const response = await fetch(`${AF_URL}/api/user/onboarding-status`, {
  headers: { 'Authorization': `Bearer ${firebaseToken}` }
});

const { data } = await response.json();
// data.onboardingComplete, data.steps, data.completionPercentage
```

### 2. For FCM Token Storage (requires Firebase setup)

```javascript
// Request notification permission
import { getMessaging, getToken } from 'firebase/messaging';

const messaging = getMessaging();
const permission = await Notification.requestPermission();

if (permission === 'granted') {
  const token = await getToken(messaging, {
    vapidKey: process.env.NEXT_PUBLIC_FIREBASE_VAPID_KEY
  });

  // Store token in backend
  await fetch(`${AF_URL}/api/user/fcm-token`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${firebaseToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      fcmToken: token,
      deviceType: 'desktop' // or 'mobile', 'tablet'
    })
  });
}
```

---

## 🎯 Recommended Next Steps

**Me (Fulton)**:
1. ⏳ Await decision: Deploy Phase 2/3 now or wait for Firebase config?
2. ⏳ If deploy: Commit Phase 2/3 to DEVL, push to TEST
3. ⏳ Update JIRA with Phase 2/3 completion

**Sarah**:
1. ✅ Start integrating User_OnboardingStatus (works immediately)
2. ⏳ Check Firebase Console for VAPID key
3. ⏳ Create service worker for FCM
4. ⏳ Test notification permission flow

**Gotan (ybotAF)**:
1. ❓ Confirm Firebase project status
2. ❓ Enable Cloud Messaging if not already enabled
3. ❓ Generate VAPID key if needed
4. ❓ Decide: Deploy Phase 2/3 now or wait?

---

## 📊 Summary

| Component | Status | Blocker |
|-----------|--------|---------|
| **Phase 1** | ✅ Deployed to TEST | None |
| **Phase 2 Code** | ✅ Complete | Firebase config needed |
| **Phase 3 Code** | ✅ Complete | None (works independently) |
| **Firebase Setup** | ❓ Unknown | Need to check console |
| **Sarah's Frontend** | ⏳ In progress | Waiting for TEST deployment |

---

**Total Backend Effort**:
- Phase 1: 1 hour ✅
- Phase 2: 2 hours ✅
- Phase 3: 1 hour ✅
- **Total: 4 hours complete!**

---

**Question for Gotan**: Should I deploy Phase 2/3 to TEST now, or wait for Firebase configuration confirmation first?

— Fulton
