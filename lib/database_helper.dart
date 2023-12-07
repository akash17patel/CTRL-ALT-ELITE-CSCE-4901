import 'package:sqflite/sqflite.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('ML.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    print('Initializing database');
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path');

    // Increment the version to trigger table creation
    return await openDatabase(path, version: 4, onCreate: (db, version) async {
      await _createDB(db, version);
    });
  }

  Future _createDB(Database db, int version) async {
    print('Creating database');
    try {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      );

      CREATE TABLE IF NOT EXISTS chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        sender TEXT NOT NULL,
        timestamp TEXT NOT NULL
      );
    ''');
    } catch (e) {
      print('Error creating database: $e');
      rethrow; // Re-throw the exception to get more details in the console
    }
  }

  String hashPassword(String password) {
    return _hashPassword(password);
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }

  Future<int> storeCredentials(String username, String password) async {
    print('Storing credentials for $username');
    try {
      final db = await instance.database;
      final hashedPassword = hashPassword(password);
      final data = {'username': username, 'password': hashedPassword};
      final result = await db.insert('user_credentials', data);
      return result;
    } catch (e) {
      print('Error storing credentials: $e');
      return -1;
    }
  }

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

  Future<int> storeChatMessage(
      String message, bool isUser, String timestamp) async {
    print('Storing chat message: $message');
    try {
      final db = await instance.database;
      final data = {
        'text': message,
        'sender': isUser ? 'User' : 'AI',
        'timestamp': timestamp,
      };
      final result = await db.insert('chat_messages', data);
      return result;
    } catch (e) {
      print('Error storing chat message: $e');
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> getChatMessagesForDate(String date) async {
    final db = await instance.database;
    return await db.query(
      'chat_messages',
      columns: ['text', 'sender', 'timestamp'],
      where: 'timestamp LIKE ?',
      whereArgs: ['$date%'],
    );
  }

/*
  // Debug
  Future<void> getAllTablesInDataBase() async {
    await DatabaseHelper.instance.getAllTablesInDataBase();
    final db = await instance.database;
    List<Map> list = await db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');

    for (int i = 0; i < list.length; i++) {
      print(list[i].values);
    }
  }
*/
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
