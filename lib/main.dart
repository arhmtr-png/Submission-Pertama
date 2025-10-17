import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'screens/home_page.dart';
import 'screens/details_page.dart';
import 'screens/login_page.dart';
import 'screens/results_page.dart';
import 'screens/gallery_page.dart';
import 'screens/error_page.dart';
import 'screens/restaurants_page.dart';
import 'screens/dev_screen.dart';
import 'src/providers/settings_provider.dart';
import 'src/services/settings_service.dart';
import 'src/providers/favorite_provider.dart';
import 'src/data/favorite_repository.dart';
import 'src/providers/gallery_provider.dart';
import 'src/providers/restaurant_provider.dart';
<<<<<<< HEAD
import 'src/services/background_service.dart';
import 'src/services/notification_service.dart';

// In-memory favorite repo for tests and when sqflite isn't desired.
class InMemoryFavoriteRepository extends FavoriteRepository {
  final List<Map<String, dynamic>> _store = [];
=======
import 'src/pages/restaurant_list_page.dart';
import 'src/pages/restaurant_detail_page.dart';
import 'src/theme/tourism_theme.dart';
import 'src/services/notification_service.dart';
import 'src/services/background_service.dart';
import 'package:workmanager/workmanager.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init(onSelect: (payload) {
    if (payload != null && payload.isNotEmpty) {
      // Navigate to detail route with id payload
      navigatorKey.currentState?.pushNamed('/detail', arguments: {'id': payload});
    }
  });
  // Initialize Workmanager with our callback dispatcher
  Workmanager().initialize(
    BackgroundService.callbackDispatcher,
    isInDebugMode: false,
  );
  runApp(const MyApp());
}
>>>>>>> b44b836 (fix(warnings)/feat(workmanager): Fix all Dart warnings, implement final Workmanager scheduling logic, and deep link handler.)

  @override
<<<<<<< HEAD
  Future<void> insertFavorite(Map<String, dynamic> item) async {
    _store.removeWhere((e) => e['id'] == item['id']);
    _store.add(item);
=======
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Restaurant App',
        themeMode: ThemeMode.system,
        theme: TourismTheme.light(),
        darkTheme: TourismTheme.dark(),
        home: const RestaurantListPage(),
        onGenerateRoute: (settings) {
          // Handle notification deep links by expecting a route named '/detail' with an id
          if (settings.name == '/detail' && settings.arguments is Map) {
            final args = settings.arguments as Map;
            final id = args['id'] as String?;
            final name = args['name'] as String? ?? '';
            final pictureId = args['pictureId'] as String? ?? '';
            if (id != null) {
              return MaterialPageRoute(builder: (_) => RestaurantDetailPage(id: id, name: name, pictureId: pictureId));
            }
          }
          return null;
        },
      ),
    );
>>>>>>> b44b836 (fix(warnings)/feat(workmanager): Fix all Dart warnings, implement final Workmanager scheduling logic, and deep link handler.)
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
  // Use the SQLite-backed FavoriteRepository for runtime so favorites persist
  // across app restarts in the release APK. Tests and injection can still
  // provide InMemoryFavoriteRepository via AppRoot.
  final favoriteRepository = FavoriteRepository();

  await NotificationService.init();
  Workmanager().initialize(callbackDispatcher);

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
        import 'package:flutter/material.dart';
        import 'package:provider/provider.dart';

        import 'screens/home_page.dart';
        import 'screens/details_page.dart';
        import 'screens/login_page.dart';
        import 'screens/results_page.dart';
        import 'screens/gallery_page.dart';
        import 'screens/error_page.dart';
        import 'screens/restaurants_page.dart';
        import 'screens/dev_screen.dart';
        import 'src/providers/settings_provider.dart';
        import 'src/services/settings_service.dart';
        import 'src/providers/favorite_provider.dart';
        import 'src/data/favorite_repository.dart';
        import 'src/providers/gallery_provider.dart';
        import 'src/providers/restaurant_provider.dart';
        import 'src/services/background_service.dart';
        import 'src/services/notification_service.dart';
        import 'package:workmanager/workmanager.dart';

        final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

        void main() async {
          WidgetsFlutterBinding.ensureInitialized();

          final settingsService = SettingsService();
          final favoriteRepository = FavoriteRepository();

          await NotificationService.init(onSelect: (payload) {
            if (payload != null && payload.isNotEmpty) {
              navigatorKey.currentState?.pushNamed('/details', arguments: {'id': payload});
            }
          });

          // Initialize Workmanager with our callback dispatcher
          Workmanager().initialize(
            BackgroundService.callbackDispatcher,
            isInDebugMode: false,
          );

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
            final favRepo = favoriteRepository ?? FavoriteRepository();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider<SettingsProvider>(
                  create: (_) => SettingsProvider(service: settingsSvc),
                ),
                ChangeNotifierProvider(create: (_) => GalleryProvider()),
                ChangeNotifierProvider(create: (_) => RestaurantProvider()),
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
            final settings = Provider.of<SettingsProvider?>(context);
            final isDark = settings?.isDark ?? false;

            return MaterialApp(
              navigatorKey: navigatorKey,
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
                '/restaurants': (context) => const RestaurantsPage(),
                '/dev': (context) => const DevScreen(),
                '/error': (context) => const ErrorPage(),
              },
            );
          }
        }
