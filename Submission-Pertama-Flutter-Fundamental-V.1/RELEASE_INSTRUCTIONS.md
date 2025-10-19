Release instructions for the debug APK

I built a debug APK locally at:

build/app/outputs/flutter-apk/app-debug.apk

Since the GitHub CLI (`gh`) is not available in this environment, you can upload the APK via one of these methods:

Option A — GitHub Releases (recommended):
1. Open your repository on GitHub: https://github.com/<owner>/<repo>
2. Go to the "Releases" tab and click "Draft a new release".
3. Set a tag (e.g., `v1.0.0-debug`) and a release title (e.g., "Debug APK for review").
4. Drag and drop the `app-debug.apk` from `build/app/outputs/flutter-apk/` into the release as an asset.
5. Publish the release.

Option B — Share via cloud storage:
1. Upload `build/app/outputs/flutter-apk/app-debug.apk` to Google Drive / Dropbox / OneDrive.
2. Share the link with reviewers.

Notes and recommendations:
- Avoid committing APKs to the git repository; use Releases instead.
- If you want me to create the release programmatically, install and authenticate the GitHub CLI in this environment (run `gh auth login`) and I can create the release and upload the APK.

If you want me to proceed with the release creation here, please install/authorize `gh` or provide credentials for a CI pipeline that can handle uploads securely.
