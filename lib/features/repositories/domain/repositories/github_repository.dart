import '../entities/repository_entity.dart';

abstract class GithubRepository {
  Future<List<RepositoryEntity>> fetchRepositories();
  Future<RepositoryEntity?> getRepositoryById(int id);
}
