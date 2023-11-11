import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'user.dart' as myUser;


class User {
  final int? id;
  final String username;
  final String passwordHash;

  User({
    this.id, // Provide a default value or make it nullable
    required this.username,
    required this.passwordHash,
  });
}



class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }
Future<int> signUp(myUser.User user) async {
  final db = await instance.database;

    // Hash the password before storing it
     final hashedPassword = hashPassword(user.passwordHash);

    final data = {
      'username': user.username,
      'password': hashedPassword,
    };

    return await db.insert('user_credentials', data);
  }

  Future<int> storeCredentials(String username, String password) async {
    final db = await instance.database;
    final hashedPassword = hashPassword(password);
    final data = {'username': username, 'password': hashedPassword};
    return await db.insert('user_credentials', data);
  }

  Future<Map<String, dynamic>?> retrieveCredentials(String username) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'user_credentials',
      columns: ['username', 'password'],
      where: 'username = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  String hashPassword(String password) {
    final List<int> bytes = utf8.encode(password);
    final Digest digest = sha256.convert(bytes);
    return base64.encode(digest.bytes);
  }

  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
