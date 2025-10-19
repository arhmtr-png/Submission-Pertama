Testing & reviewer quick commands
=================================

This file contains one-liners and short instructions for running the permission-granting helper and the integration test on Windows (PowerShell) and macOS/Linux (bash).

Windows (PowerShell)
--------------------
# From repository root (PowerShell)
# Auto-detect package and grant POST_NOTIFICATIONS
.
\scripts\grant_notification_permission.ps1

# Auto-detect package, grant and restart the app
.
\scripts\grant_notification_permission.ps1 -Restart

# Run the integration test that taps "Send Test Notification"
flutter test integration_test/send_test_notification_test.dart

macOS / Linux (bash)
---------------------
# From repository root (bash)
# Auto-detect package and grant POST_NOTIFICATIONS
./scripts/grant_notification_permission.sh

# Specify the package explicitly and restart the app
./scripts/grant_notification_permission.sh com.example.fundamental --restart

# Run the integration test
flutter test integration_test/send_test_notification_test.dart

Notes
-----
- Both scripts require `adb` on PATH and a connected device/emulator.
- Integration tests that exercise platform plugins must be run on a device/emulator.
- If the scripts fail to grant permissions, grant the permission manually via device Settings → Apps → <this app> → Notifications.
