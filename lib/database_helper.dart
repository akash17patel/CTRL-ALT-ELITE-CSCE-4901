import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init(); // Constructor
  static Database? _database;

  DatabaseHelper._init();

  // Make a new database if we dont have one, otherwise init the db
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app.db');
    return _database!;
  }

  // Method called to use pre existing db
  Future<Database> _initDB(String filePath) async {
    print('Initializing database');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path');

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // But if we need one, create one
  Future _createDB(Database db, int version) async {
    print('Creating database');
    await db.execute('''
      CREATE TABLE user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  String hashPassword(String password) {
    return _hashPassword(password);
  }

  // Make the method private within the class
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }

  // Store, async
  Future<int> storeCredentials(String username, String password) async {
    print('Storing credentials for $username');
    try {
      final db = await instance.database;
      final hashedPassword = hashPassword(password);
      //print('Hashed password: $hashedPassword');      //testing purpose
      final data = {'username': username, 'password': hashedPassword};
      final result = await db.insert('user_credentials', data);
      //return await db.insert('user_credentials', data);

      return result;
    } catch (e) {
      print('Error storing credentials: $e');
      return -1; // Return a value that indicates an error
    }
  }

  // Fetch, async
  Future<Map<String, dynamic>?> retrieveCredentials(String username) async {
    print('Retrieving credentials for $username');
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

  // Clean up and save resources.
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
