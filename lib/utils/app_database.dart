import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class AppDatabase {
  static Database? _database;
  static Future<Database> get database async{
    if(_database!=null){
      return _database!;
    }
    _database=await _openDatabase();
    return _database!;
  }
  static Future<Database> _openDatabase()async{
    return await databaseFactory.openDatabase(
      'app.db',
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db,version)async{
          await _createTables(db);
        },
        onUpgrade: (db,oldversion,currentVersion)async{
          await _migrate(db,oldversion,currentVersion);
        }
      )
    );
  }
  static Future<void> _migrate(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // migrations go here
  }

  static Future<void> _createTables(Database db) async {
    await db.execute('''
          CREATE TABLE clients (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            mobile TEXT NOT NULL,
            email TEXT NOT NULL,
            twitter TEXT,
            instagram TEXT,
            facebook TEXT,
            website TEXT,
            description TEXT NOT NULL,
            notes TEXT NOT NULL,
            status TEXT NOT NULL
          );
      ''');

      await db.execute('''
          CREATE TABLE milestones (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          project_id INTEGER NOT NULL,
          start TEXT NOT NULL,
          end TEXT NOT NULL,
          title TEXT NOT NULL,
          description TEXT NOT NULL,

          FOREIGN KEY (project_id)
            REFERENCES projects(id)
            ON DELETE CASCADE
        );
    ''');
    await db.execute(
      '''
          CREATE TABLE projects (
          id INTEGER PRIMARY KEY,
          title TEXT NOT NULL,
          description TEXT NOT NULL,
          type TEXT NOT NULL,
          notes TEXT NOT NULL
        );
      '''
    );
  }
}