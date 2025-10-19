import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:submission_pertama/src/data/database_helper.dart';
import 'package:submission_pertama/src/models/restaurant_model.dart';
import 'package:path/path.dart' as p;

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseHelper favorites', () {
    setUp(() async {
      // Close any open DB and remove the file to ensure a clean state for each test
      try {
        await DatabaseHelper.instance.close();
      } catch (_) {}
      final databasesPath = await getDatabasesPath();
      final dbPath = p.join(databasesPath, 'fundamental.db');
      try {
        await deleteDatabase(dbPath);
      } catch (_) {}
    });

    test(
      'insertFavorite prevents duplicates and getFavorites returns one',
      () async {
        final db = DatabaseHelper.instance;
        final r = Restaurant(
          id: 'd1',
          name: 'Dup',
          pictureId: 'p',
          city: 'C',
          rating: 4.0,
        );
        final ok1 = await db.insertFavorite(r);
        expect(ok1, isTrue);
        final ok2 = await db.insertFavorite(r);
        expect(ok2, isTrue);

        final favs = await db.getFavorites();
        // Because we use ConflictAlgorithm.replace, duplicates should not increase count
        final matches = favs.where((x) => x.id == r.id).toList();
        expect(matches.length, equals(1));
      },
    );

    test('isFavorite and removeFavorite work', () async {
      final db = DatabaseHelper.instance;
      final r = Restaurant(
        id: 't2',
        name: 'Test2',
        pictureId: 'p2',
        city: 'C2',
        rating: 3.5,
      );
      final added = await db.insertFavorite(r);
      expect(added, isTrue);

      final isFav = await db.isFavorite(r.id);
      expect(isFav, isTrue);

      final removed = await db.removeFavorite(r.id);
      expect(removed, isTrue);

      final after = await db.getFavorites();
      expect(after.any((x) => x.id == r.id), isFalse);
    });

    test('favorites persist after close and reopen', () async {
      final db = DatabaseHelper.instance;
      final r = Restaurant(
        id: 't3',
        name: 'Persist',
        pictureId: 'p3',
        city: 'C3',
        rating: 5.0,
      );
      final added = await db.insertFavorite(r);
      expect(added, isTrue);

      // Close DB and get a fresh instance
      await db.close();

      final reopened = DatabaseHelper.instance;
      final favs = await reopened.getFavorites();
      expect(favs.any((x) => x.id == r.id), isTrue);
    });
  });
}

