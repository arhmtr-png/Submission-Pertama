import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/providers/favorite_provider.dart';
import '../src/providers/details_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Expecting route arguments to contain a Map<String, dynamic> restaurant
    final args = ModalRoute.of(context)?.settings.arguments;
    // Support either full restaurant map passed via arguments or just an id.
    Map<String, dynamic>? restaurantArg;
    String? restaurantId;
    if (args is Map<String, dynamic>) {
      restaurantArg = args;
      restaurantId = args['id']?.toString();
    } else if (args is String) {
      restaurantId = args;
    }

    // Create a local DetailsProvider for this page so we can fetch by id
    // without FutureBuilder. The provider will be created synchronously and
    // perform an async fetch if necessary.
    return ChangeNotifierProvider<DetailsProvider>(
      create: (_) => DetailsProvider(data: restaurantArg, id: restaurantId),
      child: Consumer2<DetailsProvider, FavoriteProvider>(
        builder: (context, detailsProv, favProv, _) {
          final restaurant =
              detailsProv.data ??
              <String, dynamic>{
                'id': restaurantId ?? 'unknown',
                'name': 'Unknown',
              };
          final isFav = favProv.isFavorite(restaurant['id']?.toString() ?? '');

          return Scaffold(
            appBar: AppBar(
              title: Text(restaurant['name']?.toString() ?? 'Details Page'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  key: const Key('detail_favorite_toggle'),
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  color: isFav ? Colors.redAccent : null,
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    if (isFav) {
                      await favProv.removeFavorite(
                        restaurant['id']?.toString() ?? '',
                      );
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Removed from favorites')),
                      );
                    } else {
                      // store minimal fields; repository stores a Map
                      final item = {
                        'id':
                            restaurant['id']?.toString() ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        'name': restaurant['name']?.toString() ?? 'Unknown',
                        'description':
                            restaurant['description']?.toString() ?? '',
                      };
                      await favProv.addFavorite(item);
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Added to favorites')),
                      );
                    }
                  },
                ),
              ],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image / hero area: try several common keys and provide a
                        // graceful fallback to a bundled placeholder asset.
                        Builder(
                          builder: (context) {
                            String? imageUrl;
                            if (restaurant['url'] != null &&
                                restaurant['url'].toString().isNotEmpty) {
                              imageUrl = restaurant['url'].toString();
                            } else if (restaurant['image'] != null &&
                                restaurant['image'].toString().isNotEmpty) {
                              imageUrl = restaurant['image'].toString();
                            } else if (restaurant['pictureUrl'] != null &&
                                restaurant['pictureUrl']
                                    .toString()
                                    .isNotEmpty) {
                              imageUrl = restaurant['pictureUrl'].toString();
                            } else if (restaurant['pictureId'] != null &&
                                restaurant['pictureId'].toString().isNotEmpty) {
                              // Some data sources supply only an id; use a stable picsum
                              // seed so the UI still shows an image during demos.
                              imageUrl =
                                  'https://picsum.photos/seed/${restaurant['pictureId']}/800/450';
                            }

                            return SizedBox(
                              width: double.infinity,
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: imageUrl != null
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Image.asset(
                                                  'assets/placeholder.png',
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.broken_image,
                                                    size: 48,
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              },
                                        )
                                      : Image.asset(
                                          'assets/placeholder.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          restaurant['name']?.toString() ?? 'Unknown',
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 20 : 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Show loading or error states from the details provider
                        if (detailsProv.loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: LinearProgressIndicator(),
                          ),
                        if (detailsProv.error != null)
                          Text('Error: ${detailsProv.error}'),
                        Text(
                          restaurant['description']?.toString() ??
                              'No description available.',
                        ),
                        const SizedBox(height: 20),
                        // Additional details can be shown here
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
