import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
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
  String platformFontFamily() {
    // Android, Fuchsia, Linux: Roboto
    if (Platform.isAndroid || Platform.isFuchsia || Platform.isLinux) {
      return 'Roboto';
    }
    // iOS: SF Pro Display/Text
    if (Platform.isIOS) return 'SF Pro Text';
    // macOS: .AppleSystemUIFont
    if (Platform.isMacOS) return '.AppleSystemUIFont';
    // Windows: Segoe UI
    if (Platform.isWindows) return 'Segoe UI';
    return 'Roboto';
  }
}
