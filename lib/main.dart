import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/services/api_service.dart';
import 'src/providers/restaurant_provider.dart';
import 'src/pages/restaurant_list_page.dart';
import 'src/theme/tourism_theme.dart';

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
        theme: TourismTheme.light(),
        darkTheme: TourismTheme.dark(),
        home: const RestaurantListPage(),
      ),
    );
  }

  // Choose base font family per platform as requested by reviewer
  // Font selection is handled by TourismTheme.platformFontFamily()
}
