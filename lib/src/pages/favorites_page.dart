import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorite_provider.dart';
import '../widgets/star_rating.dart';

class FavoritesPage extends StatelessWidget {
  static const routeName = '/favorites';

  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          final favs = provider.favorites;
          if (favs.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: favs.length,
            itemBuilder: (context, index) {
              final item = favs[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: item.pictureId.isNotEmpty
                      ? Image.network(
                          'https://restaurant-api.dicoding.dev/images/medium/${item.pictureId}',
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(width: 72, height: 72, child: Container()),
                  title: Text(item.name),
                  subtitle: Text(item.city),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StarRating(rating: item.rating, size: 12),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await provider.removeFavorite(item.id);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: {'id': item.id});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
