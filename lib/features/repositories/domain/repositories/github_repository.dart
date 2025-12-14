import '../entities/repository_entity.dart';

abstract class GithubRepository {
  Future<List<RepositoryEntity>> fetchRepositories({bool forceRefresh});
  Future<RepositoryEntity?> getRepositoryById(int id);
}
