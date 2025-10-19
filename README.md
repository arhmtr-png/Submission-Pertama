
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

## Assets

This project expects image assets to be stored as binary files (PNG/JPEG) under the `assets/` folder. Two images are referenced in the app:

- `assets/welcome.png` — welcome image shown on the Home screen. If you remove it, the app will show a fallback icon.
- `assets/placeholder.png` — small local placeholder used while remote images in the Gallery load. This file is included in the repository and is referenced from `lib/screens/gallery_page.dart`.

If you add or replace any asset, run:

```powershell
flutter pub get
```

Tip: Don't commit base64-encoded text files for images. Store them as binary PNG/JPEG files to avoid runtime decode issues.

## Progress
- Home Screen: Implemented (Stateless)
- Login Screen: Implemented (Stateful) — validation and navigation to Results or Error implemented.
- Gallery Screen: Added (Stateful) — responsive GridView and search UI added. (Replace placeholder assets for a richer gallery.)
- Results Screen: Added (Stateful) — displays email passed from Login.
- Error Page: Added (Stateful) — shows validation messages.

## Notes
- If you add `assets/welcome.png`, re-enable it in `pubspec.yaml` under `flutter: assets:` and run `flutter pub get`.

## Bundling Fonts
To bundle Montserrat and Roboto locally, add the TTF files under `assets/fonts/` with the names used in `pubspec.yaml`:

- `assets/fonts/Montserrat-Regular.ttf`
- `assets/fonts/Montserrat-Bold.ttf`
- `assets/fonts/Roboto-Regular.ttf`
- `assets/fonts/Roboto-Bold.ttf`

After adding them, run:

```powershell
flutter pub get
```

If you'd like to download the fonts automatically (Windows PowerShell), run this script from the repository root. It will fetch official TTFs from the Google Fonts GitHub repository and save them to `assets/fonts/`:

```powershell
# run from project root (PowerShell)
$urls = @{
   'Montserrat-Regular' = 'https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-Regular.ttf';
   'Montserrat-Bold' = 'https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-Bold.ttf';
   'Roboto-Regular' = 'https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Regular.ttf';
   'Roboto-Bold' = 'https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Bold.ttf'
}
New-Item -ItemType Directory -Path .\assets\fonts -Force | Out-Null
foreach ($k in $urls.Keys) {
   $out = Join-Path -Path .\assets\fonts -ChildPath ($k + '.ttf')
   Invoke-WebRequest -Uri $urls[$k] -OutFile $out -UseBasicParsing
}
```

Note: If your network or environment blocks raw downloads, download the files manually from https://fonts.google.com/ and place them in `assets/fonts/`.

The app theme will then use these bundled fonts.

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
