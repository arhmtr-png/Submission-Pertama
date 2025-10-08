import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/services/api_service.dart';
import 'src/providers/restaurant_provider.dart';
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
  }

  // Choose base font family per platform as requested by reviewer
  // Font selection is handled by TourismTheme.platformFontFamily()
}
