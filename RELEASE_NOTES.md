````markdown
# v1.0-final Release Notes

Release: v1.0-final
Date: 2025-10-11

Summary
-------
This is the final release of the Fundamental Flutter app for submission. Key highlights:

- Favorites: Add/remove restaurants to Favorites with persistence via SQLite and a SharedPreferences quick cache.
- Daily reminder: Settings option to enable daily recommended restaurant notifications (Workmanager + flutter_local_notifications).
- Notifications: Debug test notification button; immediate notifications on favorite add/remove.
- Background sync: Background favorites sync task implemented (placeholder endpoint).
- Theming: Light and dark theme implemented using ColorScheme seed.
- Tests: Unit and widget tests pass locally.

Files
-----
- APK: `build/app/outputs/flutter-apk/app-release.apk` (attached to release)
- Tag: `v1.0-final`

How to install the APK
----------------------
1. Connect your Android device and enable USB debugging.
2. Install the APK (PowerShell):

```powershell
adb install -r build\\app\\outputs\\flutter-apk\\app-release.apk
```

Notes
-----
- Android 13+ requires runtime POST_NOTIFICATIONS permission.
- Workmanager background tasks require a real device to verify reliably.

Contact
-------
If you want changes to the release notes or to attach additional assets, tell me and I will update the release.

````
