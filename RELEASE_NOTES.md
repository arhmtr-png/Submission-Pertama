# v1.0 Release Notes

Release: v1.0-release
Date: 2025-10-10

Summary
-------
This is the first stable release of the Fundamental Flutter app. Key highlights:

- Favorites: Add/remove restaurants to Favorites with persistence via SQLite.
- Daily reminder: Settings option to enable daily recommended restaurant notifications (Workmanager + local notifications).
- Notification test helper: Debug-only button in Settings to trigger a test notification.
- Repository and providers: `LocalRestaurantRepository` implemented and wired into providers.
- Tests: Full unit and widget test suite passing locally. Integration tests passed on Android device (RR8R400MQNN).

Files
-----
- APK: `build/app/outputs/flutter-apk/app-release.apk` (47.5 MB)
- Tag: `v1.0-release`

How to install the APK
----------------------
1. Connect your Android device and enable USB debugging.
2. Run:

```powershell
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

Creating the GitHub release (locally)
-------------------------------------
A helper script `scripts/create_release.ps1` is included to create the release using the GitHub CLI (`gh`) or the GitHub API (via `GITHUB_TOKEN`). See the script for details. Example using gh:

```powershell
# from repository root
.\scripts\create_release.ps1 -Tag v1.0-release -ApkPath "build\app\outputs\flutter-apk\app-release.apk" -Title "v1.0 Release" -NotesFile RELEASE_NOTES.md
```

Known issues / notes
--------------------
- Android 13+ requires POST_NOTIFICATIONS permission; the manifest includes the permission. Runtime permission may still be necessary depending on device/Android version.
- Workmanager tasks can behave differently on emulators; use the debug test notification in Settings for quick verification.

Contact
-------
If you want me to run the GitHub release command here, provide an authentication method (preferred: run the included script locally, or authenticate `gh` yourself). I will not accept tokens or credentials via chat.
