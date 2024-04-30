/*
What do we need database for?
1. Pincode
2. Conversation History
3. Emotion History
4. Emergency Contacts
5. Goals
 */

// Import our two packages

import 'dart:async';

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
  static final MindliftDatabase instance =
      MindliftDatabase._privateConstructor();

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
    await _createTable(db, 'ConversationHistory',
        'id INTEGER PRIMARY KEY, sender TEXT, text TEXT, timestamp DATETIME');
    await _createTable(db, 'EmotionHistory',
        'id INTEGER PRIMARY KEY, emotion TEXT, timestamp DATETIME');
    await _createTable(db, 'EmergencyContacts',
        'id INTEGER PRIMARY KEY, name TEXT, phone TEXT');
    await _createTable(
        db, 'Goals', 'id INTEGER PRIMARY KEY, goal TEXT, dueDate DATETIME');

    // Create a table for settings
    await _createTable(
        db, 'Settings', 'id INTEGER PRIMARY KEY, key TEXT, value TEXT');

    await _createTable(
        db, 'CrisisDetection', 'id INTEGER PRIMARY KEY, value TEXT');
  }

  // Generic method to create a table
  Future<void> _createTable(
      Database db, String tableName, String fields) async {
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

  // Add message to DB
  Future<void> insertChatMessage(
      String sender, String text, DateTime timestamp) async {
    // Format the timestamp to a SQLite compatible string
    String formattedTimestamp = timestamp.toIso8601String();

    // Prepare the data map
    Map<String, dynamic> data = {
      'sender': sender,
      'text': text,
      'timestamp': formattedTimestamp,
    };

    await insert('ConversationHistory', data);
  }

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

  // Insert the emotion into the db
  Future<void> insertEmotion(String emotion, DateTime date) async {
    final db = await database;
    await db.insert(
      'EmotionHistory',
      {
        'emotion': emotion,
        'timestamp': date.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch the emotions on a date
  Future<List<Map<String, dynamic>>> fetchEmotionsForDate(DateTime date) async {
    final db = await database;
    // Manually format the date to 'YYYY-MM-DD' string
    String dateStr =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> emotions = await db.query(
      'EmotionHistory',
      where: "strftime('%Y-%m-%d', timestamp) = ?",
      whereArgs: [dateStr],
    );
    return emotions;
  }

  // Emergency contacts

  // Method to insert a new contact
  Future<void> insertContact(Map<String, dynamic> contact) async {
    final db = await database;
    await db.insert(
      'EmergencyContacts',
      contact,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to fetch all contacts
  Future<List<Map<String, dynamic>>> fetchAllContacts() async {
    final db = await database;
    return await db.query('EmergencyContacts');
  }

  // Method to delete a contact by phone number
  Future<int> deleteContact(String phoneNumber) async {
    final db = await database;
    return await db.delete(
      'EmergencyContacts',
      where: 'phone = ?',
      whereArgs: [phoneNumber],
    );
  }

  // Method to set the pincode
  Future<void> setPincode(String pincode) async {
    final db = await database;
    await db.insert(
      'Pincode',
      {'id': 1, 'pincode': pincode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPincode() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('Pincode', where: 'id = ?', whereArgs: [1]);
    if (results.isNotEmpty) {
      return results.first['pincode'];
    } else {
      return null;
    }
  }

  // New Method: Verify Pincode
  Future<bool> verifyPincode(String pincode) async {
    final db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'Pincode',
      where: 'pincode = ?',
      whereArgs: [pincode],
    );
    return results.isNotEmpty;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    final db = await database;
    await db.insert(
      'Settings',
      {'key': 'darkMode', 'value': isDarkMode ? '1' : '0'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> getDarkMode() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('Settings', where: 'key = ?', whereArgs: ['darkMode']);
    if (results.isNotEmpty) {
      return results.first['value'] == '1';
    } else {
      return false; // Default value if not found
    }
  }

  Future<bool> getCrisisDetection() async {
    final db = await database;
    List<Map<String, dynamic>> results =
        await db.query('CrisisDetection', where: 'id = 1');
    if (results.isNotEmpty) {
      return results.first['value'] == '1';
    } else {
      return false; // Default value if not found
    }
  }

  Future<void> setCrisisDetection(bool detect) async {
    final db = await database;
    print("insert crisis");
    await db.insert(
      'CrisisDetection',
      {'id': 1, 'value': detect ? '1' : '0'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
