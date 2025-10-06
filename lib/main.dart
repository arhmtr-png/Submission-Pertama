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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
          useMaterial3: true,
          // Use Montserrat for headlines and Roboto for body text
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
              .copyWith(
                headlineLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 22),
                ),
                headlineSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 18),
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                titleMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                titleSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontSize: 14),
                ),
              ),
          appBarTheme: AppBarTheme(backgroundColor: Colors.cyan.shade700),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
              .copyWith(
                headlineLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineLarge?.copyWith(fontSize: 28),
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(fontSize: 22),
                ),
                headlineSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(fontSize: 18),
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                titleMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontSize: 16),
                ),
                titleSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontSize: 14),
                ),
              ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyan,
            brightness: Brightness.dark,
          ),
        ),
        home: const RestaurantListPage(),
      ),
    );
  }
}
