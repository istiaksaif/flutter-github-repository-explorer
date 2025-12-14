import 'package:sqflite/sqflite.dart';

import '../../models/repository_model.dart';
import '../../../../../core/database/app_database.dart';

abstract class GithubLocalDataSource {
  Future<void> cacheRepositories(List<RepositoryModel> repositories);
  Future<List<RepositoryModel>> getRepositories();
  Future<RepositoryModel?> getRepositoryById(int id);
}

class GithubLocalDataSourceImpl implements GithubLocalDataSource {
  GithubLocalDataSourceImpl(this._database);

  final AppDatabase _database;

  @override
  Future<void> cacheRepositories(List<RepositoryModel> repositories) async {
    final db = await _database.database;
    final batch = db.batch();
    batch.delete(AppDatabase.repositoryTable);
    for (final repo in repositories) {
      batch.insert(
        AppDatabase.repositoryTable,
        repo.toDbMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<RepositoryModel>> getRepositories() async {
    final db = await _database.database;
    final maps = await db.query(AppDatabase.repositoryTable);
    return maps.map(RepositoryModel.fromDb).toList();
  }

  @override
  Future<RepositoryModel?> getRepositoryById(int id) async {
    final db = await _database.database;
    final maps = await db.query(
      AppDatabase.repositoryTable,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return RepositoryModel.fromDb(maps.first);
  }
}
