import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/details_page.dart';
import 'screens/login_page.dart';
import 'screens/results_page.dart';
import 'screens/gallery_page.dart';
import 'screens/error_page.dart';

void main() {
  runApp(const SubmissionPertamaApp());
}

class SubmissionPertamaApp extends StatelessWidget {
  const SubmissionPertamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Submission Pertama',
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1), // dark blue header
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.cyan).copyWith(secondary: const Color(0xFF00BCD4)),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BCD4), // cyan primary button
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/details': (context) => const DetailsPage(),
        '/login': (context) => const LoginPage(),
        '/results': (context) => const ResultsPage(),
        '/gallery': (context) => const GalleryPage(),
        '/error': (context) => const ErrorPage(),
      },
    );
  }
}