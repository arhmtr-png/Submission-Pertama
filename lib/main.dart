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
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                ),
                headlineSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleLarge,
                ),
                titleMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                titleSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ),
          appBarTheme: AppBarTheme(backgroundColor: Colors.cyan.shade700),
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)
              .copyWith(
                headlineLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineLarge,
                ),
                headlineMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                ),
                headlineSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                ),
                titleLarge: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleLarge,
                ),
                titleMedium: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleMedium,
                ),
                titleSmall: GoogleFonts.montserrat(
                  textStyle: Theme.of(context).textTheme.titleSmall,
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
