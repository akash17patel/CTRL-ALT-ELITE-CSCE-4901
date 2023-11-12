import 'package:mindlift_flutter/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseRepository {
  Database? _database;

  static final DatabaseRepository instance = DatabaseRepository._init();
  DatabaseRepository._init();

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('mindlift.db');
    return _database!;
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
create table Users ( 
  id integer primary key autoincrement, 
  firstname text not null,
  lastname text not null,
  email text not null,
  password text not null)
''');
  }

  Future<int> insert({required UserModel user}) async {
    try {
      final db = await database;
      return db.insert('Users', user.toMap());
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  Future<List<UserModel>> getAllTodos() async {
    final db = await instance.database;

    final result = await db.query('Users');

    return result.map((json) => UserModel.fromJson(json)).toList();
  }
}
