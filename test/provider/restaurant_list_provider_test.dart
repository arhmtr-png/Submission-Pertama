import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:fundamental/src/providers/restaurant_list_provider.dart';
import 'package:fundamental/src/repositories/restaurant_repository.dart';
import 'package:fundamental/src/models/restaurant_model.dart';
import 'package:fundamental/src/repositories/exceptions.dart';

import 'restaurant_list_provider_test.mocks.dart';

@GenerateMocks([RestaurantRepository])
void main() {
  late MockRestaurantRepository mockRepo;
  late RestaurantListProvider provider;

  setUp(() {
    mockRepo = MockRestaurantRepository();
    provider = RestaurantListProvider(repository: mockRepo);
  });

  test('Initial state is loading', () {
    expect(provider.state, equals(ResultState.loading));
    expect(provider.restaurants, isEmpty);
    expect(provider.message, isEmpty);
  });

  test('API success sets HasData and populates restaurants', () async {
    final r = Restaurant(id: '1', name: 'A', pictureId: 'p1', city: 'C', rating: 4.0);
    when(mockRepo.getRestaurants()).thenAnswer((_) async => [r]);

    await provider.fetchRestaurants();

  expect(provider.state, equals(ResultState.hasData));
    expect(provider.restaurants, hasLength(1));
    expect(provider.restaurants.first, equals(r));
    expect(provider.message, isEmpty);
  });

  test('API failure maps NoConnectionException to Error state and message', () async {
    when(mockRepo.getRestaurants()).thenThrow(NoConnectionException('Check internet'));

    await provider.fetchRestaurants();

  expect(provider.state, equals(ResultState.error));
    expect(provider.restaurants, isEmpty);
    expect(provider.message, contains('Check internet'));
  });
}
