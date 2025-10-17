import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteRepository {
  static const _dbName = 'favorites.db';
  static const _tableName = 'favorites';
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE $_tableName (
          id TEXT PRIMARY KEY,
          name TEXT,
          description TEXT
        )
      ''');
      },
    );
    return _db!;
  }

  Future<void> insertFavorite(Map<String, dynamic> item) async {
    final db = await database;
    await db.insert(
      _tableName,
      item,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final result = await db.query(_tableName, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result;
  }
}
