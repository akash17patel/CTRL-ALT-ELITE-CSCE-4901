/*
What do we need database for?
1. Pincode
2. Conversation History
3. Emotion History
4. Emergency Contacts
5. Goals
 */

// Import our two packages

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Usage examples
// Insert example: await db.insert('Goals', {'id': 1, 'goal': 'Learn Flutter', 'dueDate': '2023-12-31'});
// Fetch all records from Goals: var allGoals = await db.fetchAll('Goals');
// Fetch a single record by id from Goals: var goal = await db.fetchById('Goals', 1);
// Update a record in Goals: await db.update('Goals', {'id': 1, 'goal': 'Master Flutter', 'dueDate': '2024-06-30'});
// Delete a record from Goals: await db.delete('Goals', 1);

class MindliftDatabase {
  MindliftDatabase._privateConstructor(); // Private constructor for the singleton
  static final MindliftDatabase instance = MindliftDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  // Method to create tables
  Future<void> _onCreate(Database db, int version) async {
    await _createTable(db, 'Pincode', 'id INTEGER PRIMARY KEY, pincode TEXT');
    await _createTable(db, 'ConversationHistory', 'id INTEGER PRIMARY KEY, conversation TEXT, timestamp DATETIME');
    await _createTable(db, 'EmotionHistory', 'id INTEGER PRIMARY KEY, emotion TEXT, timestamp DATETIME');
    await _createTable(db, 'EmergencyContacts', 'id INTEGER PRIMARY KEY, name TEXT, phone TEXT');
    await _createTable(db, 'Goals', 'id INTEGER PRIMARY KEY, goal TEXT, dueDate DATETIME');
  }

  // Generic method to create a table
  Future<void> _createTable(Database db, String tableName, String fields) async {
    await db.execute('CREATE TABLE $tableName ($fields)');
  }

  // Generic method to insert data into any table
  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all records from any table
  Future<List<Map<String, dynamic>>> fetchAll(String table) async {
    final db = await database;
    return await db.query(table);
  }

  // Fetch a single record by id from any table
  Future<Map<String, dynamic>?> fetchById(String table, int id) async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  // Update a record in any table
  Future<int> update(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
    );
  }

  // Delete a record from any table
  Future<int> delete(String table, int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /****************************************************/
  // Specific methods

  // Method to fetch chat messages for a specific date
  Future<List<Map<String, dynamic>>> getChatMessagesForDate(String date) async {
    final db = await database;
    // Timestamp format is 'YYYY-MM-DD'
    final List<Map<String, dynamic>> messages = await db.query(
      'ConversationHistory',
      where: "strftime('%Y-%m-%d', timestamp) = ?",
      whereArgs: [date],
    );
    return messages;
  }
}

