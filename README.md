# fundamental

A new Flutter project.

[![Flutter CI](https://github.com/arhmtr-png/Submission-Pertama/actions/workflows/flutter.yml/badge.svg)](https://github.com/arhmtr-png/Submission-Pertama/actions/workflows/flutter.yml)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## How to run

1. Ensure Flutter SDK is installed and added to PATH.
2. From project root run:

```bash
flutter pub get
flutter run
```

## Tests

Run unit and widget tests:

```bash
flutter test
```

Notes:
- Widget tests use a `FakeApiService` to avoid real network calls and network images.

Integration tests:

```bash
# Run integration tests (desktop):
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d windows
```
Note: Integration tests require a supported device/driver (desktop or mobile) and may not run in headless web environments.

## APK build & Screenshots (Submission)

If you'd like to include an APK for the submission, you can build it locally with the commands below.

Build a release APK:

```bash
# Ensure dependencies are fetched
flutter pub get

# Build a release APK
flutter build apk --release

# Output will be in:
# build/app/outputs/flutter-apk/app-release.apk
```

Build a debug APK (faster, for quick testing):

```bash
flutter build apk --debug
# Output: build/app/outputs/flutter-apk/app-debug.apk
```

Install the APK on a connected Android device (Windows PowerShell):

```powershell
adb install -r build\app\outputs\flutter-apk\app-debug.apk
```

Screenshots (placeholders)

Below are placeholder screenshot slots — replace these with real PNGs taken from your device/emulator before final submission. Place real images under `assets/screenshots/` and update the file names in the markdown.

![Screenshot - List page](assets/screenshots/list_placeholder.png)
_Figure 1: Restaurant list (replace with actual screenshot)_

![Screenshot - Detail page](assets/screenshots/detail_placeholder.png)
_Figure 2: Restaurant detail (replace with actual screenshot)_

Notes:
- If you prefer not to commit APK binaries to the repository, attach the built APK to your submission platform (or a release) instead and include a download link here.
- I can generate screenshots locally and add them to the repo if you want — tell me and I'll run the app and capture 2–3 images.

## Continuous Integration

A GitHub Actions workflow is included at `.github/workflows/flutter.yml` that runs `flutter analyze` and `flutter test` on pushes and pull requests to `main`.

## Submission checklist

- [ ] App runs and shows restaurant list
- [ ] Detail page shows menus and reviews
- [ ] Search and review submission work
- [ ] All tests pass locally (`flutter test`)
- [ ] CI green on GitHub Actions

## Contact

If you need any adjustments or want me to add integration tests or CI deployment, let me know.

## Features implemented (delta)

- Restaurant list (fetches from Dicoding Restaurant API `/list`).
- Restaurant detail (fetches `/detail/:id`, shows menus and reviews).
- Search (uses `/search?q=`; submit in the search field).
- Add review (POST `/review` from the detail page).
- Error handling widget with Retry button (`lib/src/widgets/error_retry.dart`).
- State management using Provider (`lib/src/providers`).

## Files changed / added

- `lib/src/models/restaurant_summary.dart` (model)
- `lib/src/models/restaurant_detail.dart` (detail model, menus, reviews)
- `lib/src/services/api_service.dart` (API client for list/detail/search/review)
- `lib/src/providers/restaurant_provider.dart` (list + search state)
- `lib/src/providers/restaurant_detail_provider.dart` (detail + review submit)
- `lib/src/pages/restaurant_list_page.dart` (list UI + search)
- `lib/src/pages/restaurant_detail_page.dart` (detail UI + review form)
- `lib/src/widgets/error_retry.dart` (error + retry UI)

## Notes

This project aims to meet the Dicoding Fundamental Flutter Part 1 primary criteria.
Further polishing (themes, fonts, tests) can be done after final verification.
