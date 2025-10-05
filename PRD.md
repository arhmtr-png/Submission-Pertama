# Product Requirements Document (PRD)

## Project Overview

This Flutter application is a Restaurant App that fetches restaurant data from the Dicoding Restaurant API. It meets the Fundamental Flutter Part 1 submission criteria, including UI design, state management, networking, and API integration. The app provides pages to show a list of restaurants, detailed restaurant information, search, and review features.

## Goals and Success Criteria

- Display a list of restaurants with image, name, city, and rating.
- Show detailed information for a selected restaurant including menus and customer reviews.
- Allow users to search restaurants and add reviews.
- Implement Provider for state management and show loading and error states clearly.
- Implement light and dark themes with Roboto and Montserrat fonts, Cyan as primary color and #F5F5F5 as secondary.
- Smooth navigation with Hero animations between list and detail pages.

## Core Features

1. Restaurant List Page (Halaman Daftar Restoran)

- Data displayed: name, image, city, rating.
- UI: `ListView.builder` showing restaurant cards/list tiles.
- Shows `CircularProgressIndicator` while loading.
- Tap item to navigate to Restaurant Detail Page with Hero animation.

2. Restaurant Detail Page (Halaman Detail Restoran)

- Data displayed: name, image, description, city, address, rating, food menu, drink menu, customer reviews.
- Use `Card` widgets to display menus and reviews.
- Show `CircularProgressIndicator` while loading.
- Add review form (name + review) and POST to the API.

3. Theme Customization

- Light and dark themes using `ThemeData`.
- Primary color: Cyan (#00BCD4).
- Secondary color: Light grey (#F5F5F5).
- Fonts: Roboto (body), Montserrat (headers) — configure in `pubspec.yaml`.

4. Loading Indicator

- Use `CircularProgressIndicator` while fetching list and detail data.

5. State Management

- Use `Provider` to manage state across the app.
- Use sealed classes (e.g., `Result`, `State`) for loading, success, and error states.

6. Search Feature

- Add a `TextField` on the list page to search restaurants by name, category, or menu.
- Use `/search?q=<query>` endpoint.
- Show results in the same `ListView`.

7. Review Feature

- Add review UI (name + comment) in the detail page.
- POST to `/review` endpoint and refresh reviews on success.

## API Integration

- Base URL: `https://restaurant-api.dicoding.dev`

Endpoints:
- GET `/list` — list of restaurants. Response includes `name`, `rating`, `pictureId`, `city`, and `id`.
- GET `/detail/:id` — detailed data including `name`, `description`, `rating`, `address`, `menus` (foods and drinks), `customerReviews`.
- GET `/search?q=<query>` — search restaurants by name, category, or menu.
- POST `/review` — add review with payload: `{ "id": "<restaurantId>", "name": "<name>", "review": "<review>" }`.

Error handling:
- Show `SnackBar` or `AlertDialog` for network/API errors with friendly messages.

## Data Models (Suggested)

- RestaurantSummary: id, name, city, rating, pictureId
- RestaurantDetail: id, name, description, city, address, rating, menus:{foods:[...],drinks:[...]}, customerReviews:[{name, review, date}]
- ReviewPayload: id, name, review

## UI/UX

- List page: search bar at top, `ListView.builder` with `ListTile` or `Card` showing image, name, city, rating.
- Detail page: large header image (Hero), description, menus in `Card` or `ListView`, reviews in `Card`, and review form at the bottom.
- Use responsive layout and padding for readability.

## State Management & Architecture

- Use Provider for app-level state.
- Create services for API calls (e.g., `ApiService` using `http`).
- Use repository pattern (optional but recommended) to separate data fetching from UI.
- Use sealed classes or enum-based state models for `Loading`, `HasData`, `NoData`, `Error`.

## Animations

- Implement `Hero` animation for the restaurant image from list to detail view.
- Add subtle `Fade` or `Scale` transitions for entering content sections (optional).

## Testing & Quality

- Add unit tests for API parsers and repository methods.
- Add widget tests for the list and detail pages to confirm UI renders given mock data.
- Manual smoke tests on Android and iOS emulators and web.

## Accessibility

- Ensure text scales with system font size.
- Provide semantic labels for images and buttons.

## Timeline & Milestones (Suggested)

- Week 1: Set up project, themes, fonts, basic navigation, and Restaurant List UI.
- Week 2: Implement API service, Provider state, Restaurant Detail UI, and Hero animation.
- Week 3: Add search and review features, error handling, and tests.
- Week 4: Polish UI, testing, create final submission artifacts.

## Acceptance Criteria

- List page shows restaurants fetched from `/list`.
- Detail page shows data from `/detail/:id` including menus and reviews.
- Search returns results from `/search?q=` and populates the list.
- Users can add a review via `/review` and see it appended to the reviews list.
- App supports light/dark themes and uses specified fonts and colors.
- Provider used for state management and clearly shows loading/error states.

## Next Steps

- Once PRD approved, start implementing core features in the following order: 1) Restaurant List UI and theme setup, 2) Networking and Provider state, 3) Restaurant Detail and review posting, 4) Search and extra polish.

---

Created on: 2025-10-05
