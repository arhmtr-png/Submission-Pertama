Revision Plan — Favorite Restaurant App
======================================

Goal
----
Complete final revisions required by Dicoding (Belajar Fundamental Aplikasi Flutter). This document maps your requested tasks to the current repository state, lists missing work, and gives a recommended implementation plan with small, safe changes.

How I worked
------------
- I scanned the repository for existing implementations of favorites, database helper, settings, background work, and theming.
- Where implementations already exist I mark them and suggest minimal changes instead of duplicating code.

Summary mapping (requested -> current status)
--------------------------------------------
1) Favorite Restaurant Page & SQLite
- Requested: Create LocalDatabaseService, provider, UI route `/favorites`, favorite toggle on detail page.
- Current: `lib/src/data/database_helper.dart` provides a singleton `DatabaseHelper` implementing favorites CRUD. `lib/src/providers/favorite_provider.dart` is present and wired into `main.dart`. `lib/src/pages/favorites_page.dart` exists and displays favorites using `FavoriteProvider`. The detail page uses `FavoriteProvider` to toggle favorites.
- Action: No full rewrite required. I will:
  - Verify `DatabaseHelper` schema matches spec (it does: `favorites` table with id,name,pictureId,city,rating).
  - Add small polish: ensure `FavoritesPage` uses `InkWell`/Card layout with correct image fallback and contrast in dark mode (file exists; will run quick fixes if needed).
  - Ensure `Detail` heart button reads/writes DB via `FavoriteProvider` (already implemented via repository layer). Confirm duplicate prevention via primary key.

2) Theme Settings & SharedPreferences
- Requested: Create `ThemeProvider` persist theme with SharedPreferences; add switch in SettingsPage; apply theme dynamically in `MaterialApp`.
- Current: `SettingsProvider` and `SettingsService` exist. `SettingsProvider` exposes `isDark` and has `setDarkTheme()` which persists via `SettingsService` (SharedPreferences). `main.dart` already uses `SettingsProvider` to choose `themeMode` and applies `AppTheme.light()` and `AppTheme.dark()`.
- Action: No new `ThemeProvider` required. We will:
  - Confirm `SettingsProvider` is used in `MaterialApp` builder (it is).
  - Ensure SettingsPage toggles call `setDarkTheme()` (it already does). If needed, rename `isDark` to `isDarkTheme` for clarity.
  - Verify text contrast in dark theme and adjust where necessary (use `colorScheme.onSurface`).

3) Daily Reminder with Workmanager + Notifications
- Requested: Implement callbackDispatcher to show a notification at 11:00 AM daily; scheduling logic with initialDelay.
- Current: `lib/src/services/background_service.dart` contains `callbackDispatcher()` with handling for `dailyTask` and favorites sync. `SettingsProvider.setDailyReminderActive()` schedules tasks with initialDelay logic via `WorkmanagerWrapper` and uses SharedPreferences in `SettingsService`.
- Action: A few minor checks and possible fixes:
  - Ensure Workmanager is initialized in `main.dart` with the top-level callback dispatcher (it is).
  - Verify the `NotificationService` used by the callback uses a raw sound resource if provided (it does).
  - Confirm that scheduling uses correct keys and that `initialDelay` is computed using target 11:00 (SettingsProvider does that). We'll add a unit test for the initialDelay computation.

4) Tests
- Requested: Add unit tests for providers, DB, and integration tests for navigation.
- Current: There are some tests in `test/` and `integration_test/` (we added a send_test_notification_test.dart). `DatabaseHelper` has been covered earlier.
- Action: Add/extend tests:
  - Unit test for `SettingsProvider` to verify theme and reminder persistence behavior using a fake `SettingsService`.
  - Unit test for `FavoriteProvider` add/remove (using a fake repository or in-memory DB via `sqflite_common_ffi`).
  - An integration test already exists; we will harden additional tests as requested later.

5) Layout overflow
- Requested: Fix overflow in Home Page for small screens.
- Current: I will scan `restaurant_list_page.dart` and other pages for potential Column/Row overflow and apply `Expanded`/`Flexible`/`SingleChildScrollView` where needed.
- Action: Add small responsive wrappers where applicable.

Planned changes (small, incremental, test-first where possible)
--------------------------------------------------------------
- Create `REVISION_PLAN.md` (this file) — DONE.
- Verify `DatabaseHelper` schema and unit test the CRUD functions (create `test/data/database_helper_test.dart`).
- Add unit tests for `FavoriteProvider` (using test doubles).
- Run `flutter analyze` and `flutter test` and fix any failures.
- Improve `FavoritesPage` UI contrast and ensure `InkWell` navigation.
- Confirm `SettingsProvider` theme integration and update a couple of UI text colors for contrast.
- Add a small test for `SettingsProvider` initialDelay calculation for 11:00 scheduling.

Execution & verification plan
-----------------------------
I will proceed step-by-step. For each change I will:
- Create or update the source file(s).
- Add unit tests where appropriate.
- Run `flutter analyze` and `flutter test` to ensure no regressions.
- Commit and push to `Flutter-Fundamental-V.1` with descriptive messages.

Next step — request confirmation
-------------------------------
I can start now by implementing the first developer-facing items:
- Add unit tests for `DatabaseHelper` CRUD and run them.
- Add unit tests for `FavoriteProvider` add/remove using a simple in-memory repo.

Would you like me to start with the database/provider tests now, or do you prefer I first create any missing UI polish (FavoritesPage/Detail heart icon contrast and InkWell)?

If you confirm, I will implement the next items and report progress with commits and test outputs.

