import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/home_page.dart';
import 'screens/details_page.dart';
import 'screens/login_page.dart';
import 'screens/results_page.dart';
import 'screens/gallery_page.dart';
import 'screens/error_page.dart';
import 'src/providers/settings_provider.dart';
import 'src/services/settings_service.dart';
import 'src/providers/favorite_provider.dart';
import 'src/data/favorite_repository.dart';
import 'src/providers/gallery_provider.dart';
import 'src/services/background_service.dart';
import 'src/services/notification_service.dart';

// In-memory favorite repo for tests and when sqflite isn't desired.
class InMemoryFavoriteRepository extends FavoriteRepository {
  final List<Map<String, dynamic>> _store = [];

  @override
  Future<void> insertFavorite(Map<String, dynamic> item) async {
    _store.removeWhere((e) => e['id'] == item['id']);
    _store.add(item);
  }

  @override
  Future<void> removeFavorite(String id) async {
    _store.removeWhere((e) => e['id'] == id);
  }

  @override
  Future<bool> isFavorite(String id) async {
    return _store.any((e) => e['id'] == id);
  }

  @override
  Future<List<Map<String, dynamic>>> getFavorites() async {
    return List.from(_store);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsService = SettingsService();
  final favoriteRepository = InMemoryFavoriteRepository();

  await NotificationService.init();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  runApp(
    AppRoot(
      settingsService: settingsService,
      favoriteRepository: favoriteRepository,
    ),
  );
}

class AppRoot extends StatelessWidget {
  final SettingsService? settingsService;
  final FavoriteRepository? favoriteRepository;

  const AppRoot({super.key, this.settingsService, this.favoriteRepository});

  @override
  Widget build(BuildContext context) {
    final settingsSvc = settingsService ?? SettingsService();
    final favRepo = favoriteRepository ?? InMemoryFavoriteRepository();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(service: settingsSvc),
        ),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (_) => FavoriteProvider(repository: favRepo),
        ),
      ],
      child: const SubmissionPertamaApp(),
    );
  }
}

class SubmissionPertamaApp extends StatelessWidget {
  const SubmissionPertamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider? settings;
    try {
      settings = Provider.of<SettingsProvider>(context);
    } catch (_) {
      settings = null;
    }
    final isDark = settings?.isDark ?? false;

    return MaterialApp(
      title: 'Submission Pertama',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF0D47A1),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.cyan,
        ).copyWith(secondary: const Color(0xFF00BCD4)),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
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
