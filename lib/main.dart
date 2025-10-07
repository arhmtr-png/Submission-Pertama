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
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
        ).copyWith(secondary: const Color(0xFF00BCD4)),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        // Use Roboto as default body font and Montserrat for headlines if available (bundle TTFs to enable)
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00BCD4),
            foregroundColor: Colors.white,
            minimumSize: const Size(64, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        textTheme: const TextTheme(
          // Montserrat for large headings (falls back to a system font if not bundled)
          headlineLarge: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/details': (context) => const DetailsPage(),
        '/login': (context) => const LoginPage(),
        '/results': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<dynamic, dynamic>?;
          return ResultsPage(
            email: args != null && args['email'] != null
                ? args['email'] as String
                : null,
            timestamp: args != null && args['timestamp'] != null
                ? args['timestamp'] as String
                : null,
          );
        },
        '/gallery': (context) => const GalleryPage(),
        '/error': (context) => const ErrorPage(),
      },
    );
  }
}
