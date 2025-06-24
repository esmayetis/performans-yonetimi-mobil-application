import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";

  /// **Veritabanını başlatır ve açar**
  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path =
          await getDatabasesPath() + '/tasks.db'; // **Dosya yolu düzeltildi**
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          print("Creating a new database...");
          return db.execute(
            "CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
            "title TEXT, note TEXT, date TEXT,"
            "startTime TEXT, endTime TEXT,"
            "remind INTEGER, repeat TEXT,"
            "color INTEGER,"
            "isCompleted INTEGER DEFAULT 0)", // **Varsayılan değer eklendi**
          );
        },
      );
      print("Database initialized successfully.");
    } catch (e) {
      print("Database initialization error: $e");
    }
  }

  /// **Yeni bir görev ekler, başarısız olursa -1 döner**
  static Future<int> insert(Task? task) async {
    if (_db == null) {
      print("Database not initialized.");
      return -1;
    }
    print("Insert function called.");
    return await _db!.insert(_tableName, task!.toJson());
  }

  /// **Tüm görevleri getirir**
  static Future<List<Map<String, dynamic>>> query() async {
    if (_db == null) {
      print("Database not initialized.");
      return [];
    }
    print("Query function called.");
    return await _db!.query(_tableName);
  }

  /// **Görevi ID'ye göre siler**
  static Future<int> delete(Task task) async {
    if (_db == null) {
      print("Database not initialized.");
      return -1;
    }
    print("Delete function called for task ID: ${task.id}");
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  /// **Veritabanını kapatır**
  static Future<void> closeDb() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
      print("Database closed.");
    }
  }
}
