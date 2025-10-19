#!/usr/bin/env bash
# Grant POST_NOTIFICATIONS permission to the app on the first connected device.
# Usage: ./scripts/grant_notification_permission.sh [package] [--restart]

set -euo pipefail
ROOT_DIR=$(dirname "$(dirname "${BASH_SOURCE[0]}")")
PACKAGE="$1"
RESTART=0
if [ "${PACKAGE:-}" = "--restart" ] || [ "${PACKAGE:-}" = "-r" ]; then
  PACKAGE=""
  RESTART=1
fi
if [ "${2:-}" = "--restart" ] || [ "${2:-}" = "-r" ]; then
  RESTART=1
fi

ADB=$(command -v adb || true)
if [ -z "$ADB" ]; then
  echo "adb not found on PATH. Install Android Platform Tools and ensure adb is on PATH." >&2
  exit 2
fi

DEVICE=$($ADB devices | awk '/\tdevice$/ {print $1; exit}')
if [ -z "$DEVICE" ]; then
  echo "No connected device/emulator found. Ensure a device is connected and adb is authorized." >&2
  exit 3
fi

if [ -z "$PACKAGE" ]; then
  # Try to detect from build.gradle.kts
  GRADLE_FILE="$ROOT_DIR/android/app/build.gradle.kts"
  if [ -f "$GRADLE_FILE" ]; then
    PACKAGE=$(grep -oP 'applicationId\s*=\s*"\K[^"]+' "$GRADLE_FILE" || true)
  fi
  if [ -z "$PACKAGE" ]; then
    MANIFEST="$ROOT_DIR/android/app/src/main/AndroidManifest.xml"
    if [ -f "$MANIFEST" ]; then
      PACKAGE=$(grep -oP 'package="\K[^"]+' "$MANIFEST" || true)
    fi
  fi
  if [ -z "$PACKAGE" ]; then
    echo "Could not detect package name; please pass it as the first argument." >&2
    exit 4
  fi
fi

PERM=android.permission.POST_NOTIFICATIONS
echo "Granting $PERM to $PACKAGE on device $DEVICE"
$ADB -s $DEVICE shell pm grant $PACKAGE $PERM || {
  echo "Grant command returned non-zero exit code. The device may not allow granting runtime permissions via adb." >&2
}

if [ "$RESTART" -eq 1 ]; then
  echo "Restarting app $PACKAGE"
  $ADB -s $DEVICE shell am force-stop $PACKAGE
  sleep 1
  $ADB -s $DEVICE shell monkey -p $PACKAGE -c android.intent.category.LAUNCHER 1
fi

echo "Done. Verify notifications are allowed in system settings for the app."
