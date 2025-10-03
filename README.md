
# Submission Pertama - Flutter Pemula

Submission pertama dari kelas **Flutter Pemula** Dicoding.  
Proyek ini berupa aplikasi Flutter sederhana yang dibuat untuk menguji pemahaman dasar, meliputi:

- Penggunaan widget dasar
- Penyusunan layout
- Navigasi antar halaman
- Penambahan aset & gambar

### 🚀 Tujuan
Mengimplementasikan materi fundamental Flutter mulai dari instalasi, struktur project, hingga build aplikasi.

## Overview
A simple Flutter mobile app demonstrating stateless and stateful widgets, navigation, and responsive design. Works on Android, iOS, and Web.

## Features
- Home Page: Welcome message, image, navigation button.
- Details Page: Text input, dynamic display, back navigation.
- Responsive layout for mobile and web.
- No overflow on any device size.

## Getting Started
1. Clone the repository:
   ```
   git clone <your-repo-link>
   ```
2. (Optional — placeholder) Add `assets/welcome.png` to show the welcome image. If not present, the app uses a fallback icon.
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## Progress
- Home Screen: Implemented (Stateless)
- Login Screen: Implemented (Stateful) — validation and navigation to Results or Error implemented.
- Gallery Screen: Added (Stateful) — responsive GridView and search UI added. (Replace placeholder assets for a richer gallery.)
- Results Screen: Added (Stateful) — displays email passed from Login.
- Error Page: Added (Stateful) — shows validation messages.

## Notes
- If you add `assets/welcome.png`, re-enable it in `pubspec.yaml` under `flutter: assets:` and run `flutter pub get`.

## Project Structure
- `lib/`: Dart source files.
- `assets/`: Images and media.
- `pubspec.yaml`: Dependencies and assets.

## Testing
Run widget tests:
```
flutter test
```

## Submission
- ZIP the project or push to GitHub.
- Ensure the app runs on Android, iOS, and Web.

## License
MIT
