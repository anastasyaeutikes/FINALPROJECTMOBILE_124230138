// lib/database/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('beauty_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        username $textType UNIQUE,
        email $textType UNIQUE,
        password $textType
      )
    ''');
  }

  // CREATE - Insert User
  Future<User> createUser(User user) async {
    final db = await instance.database;
    final id = await db.insert('users', user.toJson());
    return user.copy(id: id);
  }

  // READ - Get User by Username
  Future<User?> getUserByUsername(String username) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // READ - Get User by Email
  Future<User?> getUserByEmail(String email) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // READ - Get User by ID
  Future<User?> getUserById(int id) async {
    final db = await instance.database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // READ - Get All Users
  Future<List<User>> getAllUsers() async {
    final db = await instance.database;
    final result = await db.query('users');
    return result.map((json) => User.fromJson(json)).toList();
  }

  // UPDATE - Update User
  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db.update(
      'users',
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // DELETE - Delete User
  Future<int> deleteUser(int id) async {
    final db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // LOGIN - Authenticate User
  Future<User?> authenticateUser(String username, String password) async {
    final db = await instance.database;
    final maps = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // CHECK - Username exists
  Future<bool> usernameExists(String username) async {
    final user = await getUserByUsername(username);
    return user != null;
  }

  // CHECK - Email exists
  Future<bool> emailExists(String email) async {
    final user = await getUserByEmail(email);
    return user != null;
  }

  // CLOSE - Close database
  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
