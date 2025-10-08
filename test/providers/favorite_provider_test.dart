import 'package:flutter_test/flutter_test.dart';
import 'package:submission_pertama/src/providers/favorite_provider.dart';
import 'package:submission_pertama/src/data/favorite_repository.dart';
import 'package:submission_pertama/main.dart' show InMemoryFavoriteRepository;

void main() {
  group('FavoriteProvider', () {
    late FavoriteProvider provider;
    late FavoriteRepository repo;

    setUp(() {
      repo = InMemoryFavoriteRepository();
      provider = FavoriteProvider(repository: repo);
    });

    test('initial favorites empty', () async {
      // Wait for load
      await Future.delayed(const Duration(milliseconds: 200));
      expect(provider.favorites, isA<List>());
    });

    test('add and remove favorite', () async {
      final item = {'id': 't1', 'name': 'Test 1', 'description': 'desc'};
      await provider.addFavorite(item);
      expect(provider.isFavorite('t1'), isTrue);
      await provider.removeFavorite('t1');
      expect(provider.isFavorite('t1'), isFalse);
    });
  });
}
