import 'dart:developer';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_failure.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/local/github_local_data_source.dart';
import '../datasources/remote/github_remote_data_source.dart';

class GithubRepositoryImpl implements GithubRepository {
  GithubRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final GithubRemoteDataSource remoteDataSource;
  final GithubLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<List<RepositoryEntity>> fetchRepositories() async {
    final connected = await networkInfo.isConnected;

    if (connected) {
      try {
        final remoteRepos = await remoteDataSource.fetchRepositories();
        await localDataSource.cacheRepositories(remoteRepos);
        return remoteRepos;
      } catch (e, s) {
        log('Remote fetch failed, falling back to cache: $e', stackTrace: s);
      }
    }

    final cached = await localDataSource.getRepositories();
    if (cached.isNotEmpty) {
      return cached;
    }

    throw AppFailure('No repository data available');
  }

  @override
  Future<RepositoryEntity?> getRepositoryById(int id) {
    return localDataSource.getRepositoryById(id);
  }
}
