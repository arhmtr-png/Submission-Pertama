import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../src/providers/favorite_provider.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Expecting route arguments to contain a Map<String, dynamic> restaurant
    final args = ModalRoute.of(context)?.settings.arguments;
    final restaurant = (args is Map<String, dynamic>)
        ? args
        : <String, dynamic>{'id': 'unknown', 'name': 'Unknown'};

    final favProvider = Provider.of<FavoriteProvider>(context);
    final isFav = favProvider.isFavorite(restaurant['id']?.toString() ?? '');

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
                await favProvider.removeFavorite(
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
                  'description': restaurant['description']?.toString() ?? '',
                };
                await favProvider.addFavorite(item);
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
                  Text(
                    restaurant['name']?.toString() ?? 'Unknown',
                    style: TextStyle(
                      fontSize: screenWidth < 600 ? 20 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
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
  }
}
