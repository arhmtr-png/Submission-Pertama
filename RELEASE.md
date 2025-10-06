# Release: fundamental v1.0.0 (Debug)

Release date: 2025-10-06

## Notes

Debug APK for review — contains Restaurant List/Detail, Search, Review features. Tests included and CI passing.

## Asset

- APK (debug): https://github.com/arhmtr-png/Submission-Pertama/releases/download/v1.0.0/app-debug.apk

## Verification

- File size: 145,198,976 bytes (~145.2 MB)
- SHA-256: 6D844DA66AA16692E5404FCCE8145618CA91B5E5F157A6EC704DE7789BD157AB

## Notes

Do not commit large binary artifacts into Git history. Use GitHub Releases or external hosting for large build artifacts.
# Release / APK upload instructions

This file describes two simple ways to publish an APK built from this repository as a GitHub Release asset.

Option A — Using GitHub CLI (recommended)

1. Install GitHub CLI: https://cli.github.com/
2. Authenticate (one-time):

```powershell
gh auth login
```

3. Build the APK locally (on your machine):

```powershell
flutter pub get
flutter build apk --debug
# Output: build\app\outputs\flutter-apk\app-debug.apk
```

4. Create a release and upload the APK (example):

```powershell
# Replace v1.0.0 with your tag/version
gh release create v1.0.0 build\app\outputs\flutter-apk\app-debug.apk --title "App Debug APK" --notes "Debug APK for review"
```

5. After the release is created, click the asset link on GitHub to copy the download URL.
6. Update `README.md` with the release download link under the APK section.

Option B — Manual via GitHub Web UI

1. Build the APK locally (same as step 3 above).
2. Go to your GitHub repository → Releases → Draft a new release.
3. Fill tag and title, then drag-and-drop the `app-debug.apk` file into the release assets area.
4. Publish the release and copy the asset download link.
5. Update `README.md` with the release download link under the APK section.

Notes

- Avoid committing the APK into the repository history (large binary). A release asset is preferred.
- If you want, after you create the release and upload the APK, paste the release URL here and I will update the `README.md` with the direct download link and a short note.
