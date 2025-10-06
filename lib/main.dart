import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
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
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),
          textTheme:
              GoogleFonts.robotoTextTheme(
                ThemeData(useMaterial3: true).textTheme,
              ).copyWith(
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
          cardTheme: CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2A5BB1),
              foregroundColor: Colors.white,
            ),
          ),
        ),
        // Dark theme with higher contrast and explicit surface/background roles
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2A5BB1),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF0B0B0E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF121216),
            foregroundColor: Colors.white,
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
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
                bodyMedium: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
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
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const RestaurantListPage(),
      ),
    );
  }
}
