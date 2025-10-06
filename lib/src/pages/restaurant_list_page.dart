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
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
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
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Hero(
                                  tag: item.id,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: item.pictureId.isNotEmpty
                                        ? Image.network(
                                            'https://restaurant-api.dicoding.dev/images/medium/${item.pictureId}',
                                            width: 84,
                                            height: 84,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 84,
                                            height: 84,
                                            color: Colors.grey[200],
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(child: Text(item.city)),
                                          const SizedBox(width: 8),
                                          Chip(
                                            backgroundColor:
                                                Colors.teal.shade50,
                                            label: Text('⭐ ${item.rating}'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
