import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();
  static Database? _database;

  static const String repositoryTable = 'repositories';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = p.join(directory.path, 'repos.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $repositoryTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            owner_name TEXT,
            owner_avatar_url TEXT,
            description TEXT,
            stargazers_count INTEGER,
            updated_at TEXT
          )
        ''');
      },
    );
  }
}
