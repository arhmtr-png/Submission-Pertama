# fundamental

A new Flutter project.

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
