# Food Recognizer App

This repository contains the Food Recognizer Flutter application. The app uses a TensorFlow Lite model to classify food images captured by the camera or selected from the gallery. After prediction, it fetches recipe details from MealDB API.

## Features
- Capture image (Camera / Gallery) with crop support
- Run Food Classification using a local TensorFlow Lite model
- Show prediction result: food name + confidence
- Fetch recipe details from MealDB API (thumbnail, ingredients, instructions)
- UI/UX Screens: Home, Capture, Results

## Project structure
- `lib/main.dart` - app entry and routing
- `lib/screens/home.dart` - Home screen with capture/pick options
- `lib/screens/camera_capture.dart` - Image capture and crop flow
- `lib/screens/camera_preview.dart` - Live camera preview and capture
- `lib/screens/processing.dart` - Processing / inference spinner
- `lib/screens/results.dart` - Prediction result + MealDB details
- `lib/services/ml_service.dart` - TensorFlow Lite inference (isolate-friendly)
- `lib/services/mealdb_service.dart` - MealDB API client
- `lib/services/gemini_service.dart` - (optional) Nutrition API client
- `assets/models/` - place your `model.tflite` here
- `assets/labels/` - place your `labels.txt` here

## Installation & Run
1. Clone the repository:

	git clone <your-repo-url>
	cd submission_ketiga

2. Install dependencies:

```powershell
flutter pub get
```

3. Add model and labels (required for ML inference):

	- Place your TensorFlow Lite model at `assets/models/model.tflite`
	- Place your labels file at `assets/labels/labels.txt` (one label per line)

4. Run the app on a connected device or emulator:

```powershell
flutter run
```

## Commit History Guide
Use clear, focused commit messages for each major change. Example sequence:

```powershell
git add .
git commit -m "chore: initialize project structure and dependencies"
git commit -m "feat: add image capture (camera/gallery) and cropping"
git commit -m "feat: integrate TFLite model and isolate-based inference"
git commit -m "feat: results page with MealDB recipe integration"
git commit -m "chore: update README and docs"
```

## Future Improvements
- Firebase ML for dynamic model fetching and remote updates
- Nutrition API integration (Gemini, Edamam, Nutritionix) to show nutrition facts
- Unit tests for ML service and API clients
- Better UI/UX polish and animations

## Screenshots
_Add screenshots here (place images under `assets/screenshots/` and update this section)._ 

---

If you want, I can create a commit message and push these README changes. I cannot push from this environment — run the following locally to commit and push:

```powershell
git add README.md
git commit -m "docs: updated README with project details, features, setup guide, and future improvements"
git push origin main
```

If you want me to also prepare a PR or a set of incremental commits for the remaining improvements, tell me which item I should implement next and I will continue.
