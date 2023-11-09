import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// We really only need 1 db, singleton to be everywhere
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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // But if we need one, create one
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_credentials (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');
  }

  // Store, async
  Future<int> storeCredentials(String username, String password) async {
    final db = await instance.database;
    final data = {'username': username, 'password': password};
    return await db.insert('user_credentials', data);
  }

  // Fetch, async
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

  // Clean up and save resources.
  Future close() async {
    final db = await instance.database;
    await db.close();
  }
}
