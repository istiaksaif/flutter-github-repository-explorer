import '../entities/repository_entity.dart';
import '../repositories/github_repository.dart';

class GetRepositoryDetailsUseCase {
  GetRepositoryDetailsUseCase(this.repository);

  final GithubRepository repository;

  Future<RepositoryEntity?> call(int id) {
    return repository.getRepositoryById(id);
  }
}
