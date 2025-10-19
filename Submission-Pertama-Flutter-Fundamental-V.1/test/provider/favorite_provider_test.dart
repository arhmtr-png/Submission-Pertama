import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fundamental/src/providers/favorite_provider.dart';
import 'package:fundamental/src/repositories/restaurant_repository.dart';
import 'package:fundamental/src/models/restaurant_model.dart';

import 'favorite_provider_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  late MockRestaurantRepository mockRepo;
  late FavoriteProvider provider;

  setUp(() {
    mockRepo = MockRestaurantRepository();
    // ensure SharedPreferences calls succeed in unit tests
    SharedPreferences.setMockInitialValues({});
  });

  test('Initial load fetches favorites from repository', () async {
    final r = Restaurant(
      id: '1',
      name: 'Fav',
      pictureId: 'p',
      city: 'C',
      rating: 5.0,
    );
    when(mockRepo.getFavorites()).thenAnswer((_) async => [r]);

    provider = FavoriteProvider(repository: mockRepo);

    // Wait to allow async init to complete
    await Future.delayed(Duration(milliseconds: 50));

    expect(provider.favorites, contains(r));
    expect(provider.error, isEmpty);
  });

  test('addFavorite adds and notifies', () async {
    final r = Restaurant(
      id: '2',
      name: 'Add',
      pictureId: 'p',
      city: 'C',
      rating: 4.5,
    );
    when(mockRepo.addFavorite(r)).thenAnswer((_) async => true);
    when(mockRepo.getFavorites()).thenAnswer((_) async => []);

    provider = FavoriteProvider(repository: mockRepo);
    await Future.delayed(Duration(milliseconds: 50));

    final added = await provider.addFavorite(r);
    expect(added, isTrue);
    expect(provider.favorites, contains(r));
  });

  test('removeFavorite removes and notifies', () async {
    final r = Restaurant(
      id: '3',
      name: 'Rem',
      pictureId: 'p',
      city: 'C',
      rating: 4.0,
    );
    when(mockRepo.getFavorites()).thenAnswer((_) async => [r]);
    when(mockRepo.removeFavorite(r.id)).thenAnswer((_) async => true);

    provider = FavoriteProvider(repository: mockRepo);
    await Future.delayed(Duration(milliseconds: 50));

    final removed = await provider.removeFavorite(r.id);
    expect(removed, isTrue);
    expect(provider.favorites.any((x) => x.id == r.id), isFalse);
  });

  test('isFavoriteSync reflects initial loaded favorites', () async {
    final r = Restaurant(
      id: '10',
      name: 'SyncFav',
      pictureId: 'p',
      city: 'C',
      rating: 4.2,
    );
    when(mockRepo.getFavorites()).thenAnswer((_) async => [r]);

    provider = FavoriteProvider(repository: mockRepo);
    await Future.delayed(const Duration(milliseconds: 50));

    expect(provider.isFavoriteSync('10'), isTrue);
  });

  test('isFavoriteSync updates after addFavorite and removeFavorite', () async {
    final r = Restaurant(
      id: '20',
      name: 'AddSync',
      pictureId: 'p',
      city: 'C',
      rating: 3.9,
    );
    when(mockRepo.getFavorites()).thenAnswer((_) async => []);
    when(mockRepo.addFavorite(r)).thenAnswer((_) async => true);
    when(mockRepo.removeFavorite(r.id)).thenAnswer((_) async => true);

    provider = FavoriteProvider(repository: mockRepo);
    await Future.delayed(const Duration(milliseconds: 50));

    expect(provider.isFavoriteSync(r.id), isFalse);
    final added = await provider.addFavorite(r);
    expect(added, isTrue);
    expect(provider.isFavoriteSync(r.id), isTrue);

    final removed = await provider.removeFavorite(r.id);
    expect(removed, isTrue);
    expect(provider.isFavoriteSync(r.id), isFalse);
  });

  test(
    'addFavorite handles repository failure and does not mark sync',
    () async {
      final r = Restaurant(
        id: '30',
        name: 'FailAdd',
        pictureId: 'p',
        city: 'C',
        rating: 4.0,
      );
      when(mockRepo.getFavorites()).thenAnswer((_) async => []);
      when(mockRepo.addFavorite(r)).thenThrow(Exception('db fail'));

      provider = FavoriteProvider(repository: mockRepo);
      await Future.delayed(const Duration(milliseconds: 50));

      final added = await provider.addFavorite(r);
      expect(added, isFalse);
      expect(provider.isFavoriteSync(r.id), isFalse);
    },
  );
}
