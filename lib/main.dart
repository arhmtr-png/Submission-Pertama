import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'src/services/api_service.dart';
import 'src/providers/restaurant_provider.dart';
import 'src/pages/restaurant_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        title: 'Restaurant App',
        themeMode: ThemeMode.system,
        // Light theme (Material 3) with a seeded color scheme for dynamic color support
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2A5BB1), // indigo-like primary
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFFEFBFF),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF2A5BB1),
            foregroundColor: ThemeData().colorScheme.onPrimary,
            elevation: 2,
            centerTitle: true,
          ),
          textTheme: GoogleFonts.robotoTextTheme(ThemeData.light().textTheme)
              .copyWith(
                headlineLarge: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                bodyMedium: GoogleFonts.roboto(
                  textStyle: const TextStyle(fontSize: 14),
                ),
              ),
          fontFamily: platformFontFamily(),
        ),
        // Dark theme with higher contrast and explicit surface/background roles
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2A5BB1),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0B0B0E),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF121216),
            foregroundColor: ThemeData(
              brightness: Brightness.dark,
            ).colorScheme.onPrimary,
            elevation: 2,
            centerTitle: true,
          ),
          textTheme:
              GoogleFonts.robotoTextTheme(
                ThemeData(
                  brightness: Brightness.dark,
                  useMaterial3: true,
                ).textTheme,
              ).copyWith(
                headlineLarge: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ThemeData(
                      brightness: Brightness.dark,
                    ).colorScheme.onSurface,
                  ),
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: ThemeData(
                      brightness: Brightness.dark,
                    ).colorScheme.onSurface.withAlpha(0xCC),
                  ),
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeData(
                      brightness: Brightness.dark,
                    ).colorScheme.onSurface.withAlpha(0xCC),
                  ),
                ),
                bodyMedium: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: ThemeData(
                      brightness: Brightness.dark,
                    ).colorScheme.onSurface.withAlpha(0xCC),
                  ),
                ),
              ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1A1A1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF245FA6),
              foregroundColor: ThemeData(
                brightness: Brightness.dark,
              ).colorScheme.onPrimary,
            ),
          ),
        ),
        home: const RestaurantListPage(),
      ),
    );
  }

  // Choose base font family per platform as requested by reviewer
  String platformFontFamily() {
    // Android, Fuchsia, Linux: Roboto
    if (Platform.isAndroid || Platform.isFuchsia || Platform.isLinux)
      return 'Roboto';
    // iOS: SF Pro Display/Text
    if (Platform.isIOS) return 'SF Pro Text';
    // macOS: .AppleSystemUIFont
    if (Platform.isMacOS) return '.AppleSystemUIFont';
    // Windows: Segoe UI
    if (Platform.isWindows) return 'Segoe UI';
    return 'Roboto';
  }
}
