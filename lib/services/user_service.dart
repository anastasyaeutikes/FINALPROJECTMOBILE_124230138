// lib/services/user_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserService {
  final Database _database;
  final String _tableName = 'users';

  UserService(this._database);

  // ================================
  // INIT DATABASE
  // ================================
  static Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'beauty_app_data.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            username TEXT UNIQUE,
            email TEXT UNIQUE,
            password TEXT
          )
        ''');
      },
    );
  }

  // ================================
  // REGISTER USER
  // ================================
  Future<int> insertUser(User user) async {
    final map = user.toJson();

    // hash password sebelum disimpan
    map['password'] = _hashPassword(user.password);

    return await _database.insert(
      _tableName,
      map,
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  // ================================
  // LOGIN
  // ================================
  Future<User?> getUserByCredentials(String username, String password) async {
    final hashedPassword = _hashPassword(password);

    final result = await _database.query(
      _tableName,
      where: 'username = ? AND password = ?',
      whereArgs: [username, hashedPassword],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    }
    return null;
  }

  // ================================
  // GET USER BY ID
  // ================================
  Future<User?> getLoggedInUser(int userId) async {
    final result = await _database.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return User.fromJson(result.first);
    }
    return null;
  }

  // ================================
  // UPDATE USER
  // ================================
  Future<void> updateUser(User user) async {
    final map = user.toJson();

    if (map['password'] != null && map['password']!.isNotEmpty) {
      map['password'] = _hashPassword(map['password']);
    }

    await _database.update(
      _tableName,
      map,
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // ================================
  // PASSWORD HASHING (SHA256)
  // ================================
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }
}
