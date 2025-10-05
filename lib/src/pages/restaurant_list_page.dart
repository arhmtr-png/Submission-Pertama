import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant_summary.dart';
import 'restaurant_detail_page.dart';
import '../widgets/error_retry.dart';
import '../utils/result.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  void initState() {
    super.initState();
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
                final result = provider.listResult;
                if (result is Loading<List<RestaurantSummary>>) {
                  return const Center(child: CircularProgressIndicator());
                } else if (result is Success<List<RestaurantSummary>>) {
                  final restaurants = provider.searchResults.isNotEmpty
                      ? provider.searchResults
                      : result.data;
                  return ListView.builder(
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: Hero(
                          tag: item.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: item.pictureId.isNotEmpty
                                ? Image.network(
                                    'https://restaurant-api.dicoding.dev/images/medium/${item.pictureId}',
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 72,
                                    height: 72,
                                    color: Colors.grey[200],
                                  ),
                          ),
                        ),
                        title: Text(item.name),
                        subtitle: Row(
                          children: [
                            Expanded(child: Text(item.city)),
                            const SizedBox(width: 8),
                            Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 0,
                              ),
                              label: Text('⭐ ${item.rating}'),
                            ),
                          ],
                        ),
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
                } else if (result is ErrorResult<List<RestaurantSummary>>) {
                  return ErrorRetry(
                    message: 'Failed to load data. ${result.message}',
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
