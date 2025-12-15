import 'dart:developer';

import '../../../../core/network/network_info.dart';
import '../../../../core/utils/app_failure.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/local/github_local_data_source.dart';
import '../datasources/remote/github_remote_data_source.dart';
import '../../../../../core/constants/storage_keys.dart';
import 'package:get_storage/get_storage.dart';

import '../models/repository_model.dart';

class GithubRepositoryImpl implements GithubRepository {
  GithubRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.storage,
  });

  final GithubRemoteDataSource remoteDataSource;
  final GithubLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final GetStorage storage;

  @override
  Future<List<RepositoryEntity>> fetchRepositories({
    bool forceRefresh = false,
    int page = 1,
  }) async {
    final connected = await networkInfo.isConnected;

    final cached = await localDataSource.getRepositories();
    final lastSyncIso = storage.read<String>(StorageKeys.lastSync);
    final lastSync = lastSyncIso != null
        ? DateTime.tryParse(lastSyncIso)
        : null;
    final isStale =
        lastSync == null ||
        DateTime.now().difference(lastSync) > const Duration(hours: 24);

    final shouldHitRemote =
        forceRefresh || isStale || cached.isEmpty || page > 1;

    if (connected && shouldHitRemote) {
      try {
        final remoteRepos =
            await remoteDataSource.fetchRepositories(page: page);
        final merged = _mergeRepositories(cached, remoteRepos, page);
        await localDataSource.cacheRepositories(merged);
        await storage.write(
          StorageKeys.lastSync,
          DateTime.now().toIso8601String(),
        );
        return merged;
      } catch (e, s) {
        log('Remote fetch failed, falling back to cache: $e', stackTrace: s);
      }
    }

    final fallback = await localDataSource.getRepositories();
    if (fallback.isNotEmpty) {
      return fallback;
    }

    throw AppFailure('No repository data available');
  }

  @override
  Future<RepositoryEntity?> getRepositoryById(int id) {
    return localDataSource.getRepositoryById(id);
  }
}

List<RepositoryModel> _mergeRepositories(
  List<RepositoryModel> existing,
  List<RepositoryModel> incoming,
  int page,
) {
  if (page <= 1 || existing.isEmpty) return incoming;
  final ids = existing.map((e) => e.id).toSet();
  final combined = [...existing];
  for (final repo in incoming) {
    if (ids.add(repo.id)) {
      combined.add(repo);
    }
  }
  return combined;
}
