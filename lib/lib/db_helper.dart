//importing necessary packages for database helper

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//To manage SQLite DB interactions, we create a db_helper class
class DBHelper {
  static Database? _db; // variable that will store database instance

  // We create a method so we can get the db instance
  Future<Database> get database async {
    return _db ??= await initDB();
  }

  // this code was causing problem, the code above resolved it
  // if (_db != null) return _db;
  // Return the database instance if it is present already.
  //_db = await initDB(); // else, initialize the db as well return the instance
  //return _db;
  //}

  // Method that initializes the db
  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(),
        'your_db.db'); // Gets the path of db-file storage location
    return await openDatabase(
      //creates db at designated path
      path,
      // DB schema version
      version: 1,
      onCreate: (db, version) {
        //When db is created, the callback function is called.
        // Edit here to Define your database tables and initial data
      },
    );
  }

  // Method to get data from db
  Future<List<Map<String, dynamic>>> getData() async {
    Database db = await database; //get db instance
    return await db.query('my_table'); // run a query to get data from a table
  }

  // Method to insert new data into db
  Future<void> insertData(Map<String, dynamic> data) async {
    Database db = await database; // Get db instance
    await db.insert('my_table', data); // Insert data in a table
  }

  // edit here(if required) - add methods as needed for any more CRUD operations
}
