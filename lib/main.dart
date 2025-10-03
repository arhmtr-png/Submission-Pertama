import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
            minimumSize: const Size(64, 52),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: GoogleFonts.roboto(fontSize: 16),
          bodyMedium: GoogleFonts.roboto(fontSize: 14),
        ),
        appBarTheme: AppBarTheme(titleTextStyle: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
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