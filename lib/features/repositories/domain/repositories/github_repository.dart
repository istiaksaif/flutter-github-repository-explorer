import '../entities/repository_entity.dart';

abstract class GithubRepository {
  Future<List<RepositoryEntity>> fetchRepositories({
    bool forceRefresh = false,
    int page = 1,
  });
  Future<RepositoryEntity?> getRepositoryById(int id);
}
