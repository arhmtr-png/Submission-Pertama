Place the platform-specific font files here before building.

Recommended file names (examples used in pubspec.yaml):
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-Bold.ttf

You can download Poppins from Google Fonts: https://fonts.google.com/specimen/Poppins

Instructions:
1. Download the Poppins font files (Regular, Medium/500, Bold) or another
	supported font of your choice.
2. Place them under `assets/fonts/` with the file names above (or update `pubspec.yaml` to match your file names).
3. Run `flutter pub get` to register the fonts.
4. Rebuild the app.

Notes:
- Make sure you have the rights to distribute any font you include in the repository.
- For iOS/macOS, system fonts are available without bundling; bundling SF Pro requires licensing in some cases.
