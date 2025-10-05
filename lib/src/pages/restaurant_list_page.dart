import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant_summary.dart';
import 'restaurant_detail_page.dart';
import '../widgets/error_retry.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
    // Fetch restaurants after first frame to avoid using BuildContext across async gaps
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RestaurantProvider>(
        context,
        listen: false,
      ).fetchRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search restaurants...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                Provider.of<RestaurantProvider>(
                  context,
                  listen: false,
                ).searchRestaurants(value.trim());
              },
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                if (provider.state == RestaurantState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.state == RestaurantState.hasData) {
                  final List<RestaurantSummary> restaurants =
                      provider.searchResults.isNotEmpty
                      ? provider.searchResults
                      : provider.restaurants;
                  return ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return ListTile(
                        leading: Hero(
                          tag: item.id,
                          child: item.pictureId.isNotEmpty
                              ? Image.network(
                                  'https://restaurant-api.dicoding.dev/images/medium/${item.pictureId}',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                )
                              : const SizedBox(width: 56, height: 56),
                        ),
                        title: Text(item.name),
                        subtitle: Text('${item.city} • ⭐ ${item.rating}'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RestaurantDetailPage(
                                id: item.id,
                                name: item.name,
                                pictureId: item.pictureId,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (provider.state == RestaurantState.error) {
                  return ErrorRetry(
                    message: 'Failed to load data. ${provider.message}',
                    onRetry: () => provider.fetchRestaurants(),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
