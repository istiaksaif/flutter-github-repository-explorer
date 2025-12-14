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
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $repositoryTable(
            id INTEGER PRIMARY KEY,
            name TEXT,
            owner_name TEXT,
            owner_avatar_url TEXT,
            description TEXT,
            stargazers_count INTEGER,
            updated_at TEXT,
            forks_count INTEGER,
            open_issues_count INTEGER,
            watchers_count INTEGER,
            html_url TEXT,
            homepage TEXT,
            topics TEXT,
            license_name TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN forks_count INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN open_issues_count INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN watchers_count INTEGER DEFAULT 0');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN html_url TEXT DEFAULT ""');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN homepage TEXT DEFAULT ""');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN topics TEXT DEFAULT ""');
          await db.execute(
              'ALTER TABLE $repositoryTable ADD COLUMN license_name TEXT DEFAULT ""');
        }
      },
    );
  }
}
