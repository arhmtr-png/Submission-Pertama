import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../models/restaurant_summary.dart';
// ...existing imports
import '../widgets/error_retry.dart';
import '../utils/result.dart';
import '../widgets/star_rating.dart';

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
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            tooltip: 'Favorites',
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
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
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  // Restore full list when input cleared
                  Provider.of<RestaurantProvider>(
                    context,
                    listen: false,
                  ).searchRestaurants('');
                }
              },
              onSubmitted: (value) {
                Provider.of<RestaurantProvider>(
                  context,
                  listen: false,
                ).searchRestaurants(value.trim());
                // Dismiss keyboard
                FocusScope.of(context).unfocus();
              },
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, _) {
                final result = provider.listResult;
                if (result is Loading<List<RestaurantSummary>>) {
                  // Show skeleton list while loading
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final mq = MediaQuery.of(context);
                      final isWide = mq.size.width > 600;
                      final imageSize = isWide ? 120.0 : 84.0;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Container(
                                width: imageSize,
                                height: imageSize,
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest
                                    .withAlpha(0x66),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 18,
                                      width: double.infinity,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha(0x66),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 14,
                                      width: 120,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceContainerHighest
                                          .withAlpha(0x66),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (result is Success<List<RestaurantSummary>>) {
                  final restaurants = provider.searchResults.isNotEmpty
                      ? provider.searchResults
                      : result.data;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: restaurants.length,
                    itemBuilder: (context, index) {
                      final item = restaurants[index];
                      final mq = MediaQuery.of(context);
                      final isWide = mq.size.width > 600;
                      final imageSize = isWide ? 120.0 : 84.0;
                      final cs = Theme.of(context).colorScheme;
                      final textTheme = Theme.of(context).textTheme;

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
                            Navigator.pushNamed(
                              context,
                              '/detail',
                              arguments: {'id': item.id},
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Hero(
                                  tag: 'restaurant-image-${item.id}',
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: item.pictureId.isNotEmpty
                                        ? Image.network(
                                            'https://restaurant-api.dicoding.dev/images/medium/${item.pictureId}',
                                            width: imageSize,
                                            height: imageSize,
                                            fit: BoxFit.cover,
                                            errorBuilder: (ctx, err, stack) =>
                                                Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  color: cs
                                                      .surfaceContainerHighest
                                                      .withAlpha(0x99),
                                                ),
                                          )
                                        : Container(
                                            width: imageSize,
                                            height: imageSize,
                                            color: cs.surfaceContainerHighest
                                                .withAlpha(0x99),
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
                                        style: textTheme.titleLarge?.copyWith(
                                          color: cs.onSurface,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.city,
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                    color: cs.onSurface
                                                        .withAlpha(0xCC),
                                                  ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxWidth: 140,
                                            ),
                                            child: FittedBox(
                                              fit: BoxFit.scaleDown,
                                              alignment: Alignment.centerRight,
                                              child: Chip(
                                                backgroundColor:
                                                    cs.primaryContainer,
                                                label: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    StarRating(
                                                      rating: item.rating
                                                          .toDouble(),
                                                      size: 12,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Text(
                                                      item.rating.toString(),
                                                      style: TextStyle(
                                                        color: cs
                                                            .onPrimaryContainer,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
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
                  final msg = result.message.isNotEmpty
                      ? result.message
                      : 'Failed to load restaurants.';
                  return ErrorRetry(
                    message: msg,
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
