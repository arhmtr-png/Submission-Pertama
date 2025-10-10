import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fundamental/src/repositories/local_restaurant_repository.dart';
import 'package:fundamental/src/models/restaurant_model.dart';
import 'package:fundamental/src/data/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('LocalRestaurantRepository favorites', () {
    late LocalRestaurantRepository repo;

    setUp(() async {
      // Ensure a clean DB for each test by deleting the existing DB file if present
      final databasesPath = await getDatabasesPath();
      final dbPath = p.join(databasesPath, 'fundamental.db');
      try {
        await deleteDatabase(dbPath);
      } catch (_) {}

      repo = LocalRestaurantRepository(dbHelper: DatabaseHelper.instance);
    });

    test('add, get, isFavorite, remove flow', () async {
      final r = Restaurant(id: 't1', name: 'Test', pictureId: 'p', city: 'C', rating: 4.2);

      final added = await repo.addFavorite(r);
      expect(added, isTrue);

      final favs = await repo.getFavorites();
      expect(favs.any((x) => x.id == r.id), isTrue);

      final isFav = await repo.isFavorite(r.id);
      expect(isFav, isTrue);

      final removed = await repo.removeFavorite(r.id);
      expect(removed, isTrue);

      final after = await repo.getFavorites();
      expect(after.any((x) => x.id == r.id), isFalse);
    });
  });
}
