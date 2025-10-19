VERIFICATION CHECKLIST
======================

This document contains a concise checklist for manually verifying the final app behavior on an Android device (recommended Android 13+ to validate the POST_NOTIFICATIONS flow).

1) Install the APK
   - Install the release APK located at `build/app/outputs/flutter-apk/app-release.apk` or use the release asset attached to the GitHub release `v1.0-release`.

2) Grant notification permission (Android 13+)
   - On first launch the app should request notification permission. Grant it.
   - If you need to grant it manually via adb (useful for automated checks), run:

     adb shell pm grant $(adb shell pm list packages | grep -o "package:.*" | sed 's/package://g' | grep -F "Submission-Pertama" || echo ${ADB_PACKAGE}) android.permission.POST_NOTIFICATIONS

     # Note: Replace the package detection line above with the actual package id if needed, e.g. com.example.myapp

   - Alternatively, on the device: Settings → Apps → <this app> → Notifications → Allow

3) Test immediate notification and sound
   - Open the app → Settings → Tap "Send Test Notification".
   - Expect: a notification appears, playing the bundled sound `notification_sound.mp3`.
   - If sound doesn't play, ensure your device is not in Do Not Disturb and volume is up.

4) Verify favorites persistence
   - Open a restaurant detail → tap the heart icon to add to favorites.
   - Restart the app → open Favorites page; the item should remain.
   - Remove it and confirm it disappears from Favorites after restart.

5) Verify dark theme contrast
   - Settings → toggle Dark Theme.
   - Inspect titles, description text, and address line for readable contrast.

6) Verify WorkManager (daily reminder)
   - In Settings, enable "Daily Reminder (11:00 AM)".
   - In debug builds: Settings → "Trigger Background Job (debug)" to run the job immediately and verify a notification is shown.
   - In release builds: rely on scheduled job delivery (may be affected by OEM battery optimizations). For advanced testing use `adb shell` to trigger the WorkManager job or check system logs.

7) Collect logs (if troubleshooting)
   - Use logcat to see scheduling/notification messages and any exceptions:

     adb logcat -s FlutterWorkManager FlutterLocalNotificationsPlugin *:S

   - To capture all logs during a test run: `adb logcat > logcat.txt` then reproduce the issue and stop the capture.

Extra notes
-----------
- Notification resource: the app expects `android/app/src/main/res/raw/notification_sound.mp3`. The resource name (without extension) is `notification_sound` and must follow Android resource naming rules.
- The debug background trigger is only visible in debug builds via a button in Settings guarded by `kDebugMode`.
- If the notification permission request doesn't show on startup, try toggling the permission from the system settings or re-installing the app.

Contact
-------
If anything here is unclear or you want me to add an automated integration test to exercise the Settings → Send Test Notification flow, tell me and I will add it.

PowerShell helper (Windows)
----------------------------
If you're testing on Windows with adb available, a small PowerShell helper script is provided at `scripts/grant_notification_permission.ps1` that will grant the `POST_NOTIFICATIONS` permission to the app (useful for automated reviewer checks).

Usage (PowerShell):

```powershell
# Run from repository root (may require Administrator in some setups)
.
\scripts\grant_notification_permission.ps1 -package "com.example.fundamental"
```

This script will check for `adb` on PATH and a connected device, then run the appropriate `adb shell pm grant ...` command.

Running the integration test
----------------------------
The repository includes a simple integration test that opens Settings and taps "Send Test Notification". To run it on a connected device/emulator:

```powershell
flutter test integration_test/send_test_notification_test.dart
```

Notes:
- Integration tests that exercise platform plugins (notifications) must be run on a real device or emulator — they will fail in a pure Dart VM environment.
- If you prefer, run `flutter test integration_test` to run all integration tests.

8) Build verification
    - After running `flutter build apk --release`, the APK will be at:

       `build/app/outputs/flutter-apk/app-release.apk`

    - To generate a SHA256 checksum (optional):

       ```powershell
       Get-FileHash -Algorithm SHA256 build\app\outputs\flutter-apk\app-release.apk
       ```

    - Include the resulting hash in release notes to allow reviewers to verify the APK integrity.

   APK build (release)
   -------------------

   - Path: `build/app/outputs/flutter-apk/app-release.apk`
   - Size: ~47.8 MB
   - SHA256: `E2DBD44CF0001D0CF98567E1FF26AF05599C9CEC24CEC6D01A7EF04513873047`

   This APK was built from branch `Flutter-Fundamental-V.1` and should be attached to the GitHub release tag `v1.0-release` for reviewer download.
