import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/services/api_service.dart';
import 'src/providers/restaurant_provider.dart';
import 'src/repositories/local_restaurant_repository.dart';
import 'src/providers/favorite_provider.dart';
import 'src/pages/restaurant_list_page.dart';
import 'src/pages/restaurant_detail_page.dart';
import 'src/pages/favorites_page.dart';
import 'src/pages/settings_page.dart';
import 'src/theme/app_theme.dart';
import 'src/services/notification_service.dart';
import 'src/services/background_service.dart';
import 'src/providers/settings_provider.dart';
import 'src/services/settings_service.dart';
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
    callbackDispatcher,
    // ignore: deprecated_member_use
    isInDebugMode: false,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Single repository instance shared across providers
        Provider<LocalRestaurantRepository>(
          create: (_) => LocalRestaurantRepository(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (ctx) => RestaurantProvider(apiService: ApiService()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SettingsProvider(service: SettingsService()),
        ),
        ChangeNotifierProvider<FavoriteProvider>(
          create: (ctx) => FavoriteProvider(repository: ctx.read<LocalRestaurantRepository>()),
        ),
      ],
        child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Restaurant App',
            themeMode: settings.isDark ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const RestaurantListPage(),
            onGenerateRoute: (routeSettings) {
              // Handle notification deep links by expecting a route named '/detail' with an id
              if (routeSettings.name == '/detail' && routeSettings.arguments is Map) {
                final args = routeSettings.arguments as Map;
                final id = args['id'] as String?;
                if (id != null) {
                  return MaterialPageRoute(builder: (_) => RestaurantDetailPage(id: id));
                }
              }
              if (routeSettings.name == FavoritesPage.routeName) {
                return MaterialPageRoute(builder: (_) => const FavoritesPage());
              }
              if (routeSettings.name == SettingsPage.routeName) {
                return MaterialPageRoute(builder: (_) => const SettingsPage());
              }
              return null;
            },
          );
        },
      ),
    );
  }

  // Choose base font family per platform as requested by reviewer
  // Font selection is handled by TourismTheme.platformFontFamily()
}
