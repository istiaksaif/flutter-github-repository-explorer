import '../entities/repository_entity.dart';
import '../entities/sort_option.dart';
import '../repositories/github_repository.dart';

class GetRepositoriesUseCase {
  GetRepositoriesUseCase(this.repository);

  final GithubRepository repository;

  Future<List<RepositoryEntity>> call(
    SortPreference preference, {
    bool forceRefresh = false,
    int page = 1,
  }) async {
    final repos = await repository.fetchRepositories(
      forceRefresh: forceRefresh,
      page: page,
    );
    repos.sort((a, b) {
      int comparison;
      switch (preference.field) {
        case SortField.stars:
          comparison = a.stargazersCount.compareTo(b.stargazersCount);
          break;
        case SortField.updatedAt:
          comparison = a.updatedAt.compareTo(b.updatedAt);
          break;
      }
      return preference.order == SortOrder.ascending ? comparison : -comparison;
    });
    return repos;
  }
}
