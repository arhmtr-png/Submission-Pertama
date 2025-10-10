import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant_model.dart';

/// Database helper to manage favorites using SQLite.
abstract class FavoritesDataSource {
  Future<bool> insertFavorite(Restaurant restaurant);
  Future<bool> removeFavorite(String id);
  Future<bool> isFavorite(String id);
  Future<List<Restaurant>> getFavorites();
}

class DatabaseHelper implements FavoritesDataSource {
  static const _dbName = 'fundamental.db';
  static const _dbVersion = 1;
  static const favoritesTable = 'favorites';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _dbName);

    // Open the database, create favorites table if it doesn't exist
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $favoritesTable (
            id TEXT PRIMARY KEY,
            name TEXT,
            pictureId TEXT,
            city TEXT,
            rating REAL
          )
        ''');
      },
    );
  }

  /// Insert a restaurant into favorites. Returns true on success.
  @override
  Future<bool> insertFavorite(Restaurant restaurant) async {
    try {
      final db = await database;
      await db.insert(
        favoritesTable,
        restaurant.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      // Log or handle error appropriately in production code.
      return false;
    }
  }

  /// Remove a favorite by id. Returns true if a row was deleted.
  @override
  Future<bool> removeFavorite(String id) async {
    try {
      final db = await database;
      final count = await db.delete(
        favoritesTable,
        where: 'id = ?',
        whereArgs: [id],
      );
      return count > 0;
    } catch (e) {
      return false;
    }
  }

  /// Check whether a restaurant is favorited.
  @override
  Future<bool> isFavorite(String id) async {
    try {
      final db = await database;
      final maps = await db.query(
        favoritesTable,
        columns: ['id'],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );
      return maps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get all favorites as a list of Restaurant models.
  @override
  Future<List<Restaurant>> getFavorites() async {
    try {
      final db = await database;
      final maps = await db.query(favoritesTable);
      return maps.map((m) => Restaurant.fromMap(m)).toList();
    } catch (e) {
      return <Restaurant>[];
    }
  }

  /// Close database (useful for tests).
  Future<void> close() async {
    final db = _database;
    if (db != null && db.isOpen) {
      await db.close();
    }
    _database = null;
  }
}

