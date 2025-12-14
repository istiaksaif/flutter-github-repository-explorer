import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/database/app_database.dart';
import '../../../../core/network/network_info.dart';
import '../../data/datasources/local/github_local_data_source.dart';
import '../../data/datasources/remote/github_remote_data_source.dart';
import '../../data/repositories/github_repository_impl.dart';
import '../../data/repositories/sort_preference_repository_impl.dart';
import '../../domain/repositories/github_repository.dart';
import '../../domain/repositories/sort_preference_repository.dart';
import '../../domain/usecases/get_repositories_usecase.dart';
import '../../domain/usecases/get_repository_details_usecase.dart';
import '../../domain/usecases/load_sort_preference_usecase.dart';
import '../../domain/usecases/save_sort_preference_usecase.dart';
import '../controllers/repository_details_controller.dart';
import '../controllers/repository_list_controller.dart';

class RepositoryListBinding extends Bindings {
  @override
  void dependencies() {
    _registerCore();

    Get.lazyPut(() => GetRepositoriesUseCase(Get.find()));
    Get.lazyPut(() => LoadSortPreferenceUseCase(Get.find()));
    Get.lazyPut(() => SaveSortPreferenceUseCase(Get.find()));

    Get.lazyPut(
      () => RepositoryListController(
        getRepositoriesUseCase: Get.find(),
        saveSortPreferenceUseCase: Get.find(),
        loadSortPreferenceUseCase: Get.find(),
        networkInfo: Get.find(),
      ),
    );
  }
}

class RepositoryDetailsBinding extends Bindings {
  @override
  void dependencies() {
    _registerCore();

    Get.lazyPut(() => GetRepositoryDetailsUseCase(Get.find()));
    Get.lazyPut(() => RepositoryDetailsController(Get.find()));
  }
}

void _registerCore() {
  if (!Get.isRegistered<GetStorage>()) {
    Get.put(GetStorage(), permanent: true);
  }
  if (!Get.isRegistered<Connectivity>()) {
    Get.put(Connectivity(), permanent: true);
  }
  if (!Get.isRegistered<NetworkInfo>()) {
    Get.put(NetworkInfo(Get.find()), permanent: true);
  }
  if (!Get.isRegistered<AppDatabase>()) {
    Get.put(AppDatabase.instance, permanent: true);
  }
  if (!Get.isRegistered<http.Client>()) {
    Get.put(http.Client(), permanent: true);
  }
  if (!Get.isRegistered<GithubRemoteDataSource>()) {
    Get.put<GithubRemoteDataSource>(
      GithubRemoteDataSourceImpl(Get.find()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<GithubLocalDataSource>()) {
    Get.put<GithubLocalDataSource>(
      GithubLocalDataSourceImpl(Get.find()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<GithubRepository>()) {
    Get.put<GithubRepository>(
      GithubRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
      ),
      permanent: true,
    );
  }
  if (!Get.isRegistered<SortPreferenceRepository>()) {
    Get.put<SortPreferenceRepository>(
      SortPreferenceRepositoryImpl(Get.find()),
      permanent: true,
    );
  }
}
