import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../database/app_database.dart';
import '../network/network_info.dart';
import '../services/api_client.dart';
import '../../features/repositories/data/datasources/local/github_local_data_source.dart';
import '../../features/repositories/data/datasources/remote/github_remote_data_source.dart';
import '../../features/repositories/data/repositories/github_repository_impl.dart';
import '../../features/repositories/data/repositories/sort_preference_repository_impl.dart';
import '../../features/repositories/domain/repositories/github_repository.dart';
import '../../features/repositories/domain/repositories/sort_preference_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStorage(), permanent: true);
    Get.put(Connectivity(), permanent: true);
    Get.put(NetworkInfo(Get.find()), permanent: true);
    Get.put(AppDatabase.instance, permanent: true);
    Get.put(http.Client(), permanent: true);
    Get.put(
      ApiClient(client: Get.find(), networkInfo: Get.find()),
      permanent: true,
    );

    Get.put<GithubRemoteDataSource>(
      GithubRemoteDataSourceImpl(Get.find()),
      permanent: true,
    );
    Get.put<GithubLocalDataSource>(
      GithubLocalDataSourceImpl(Get.find()),
      permanent: true,
    );
    Get.put<GithubRepository>(
      GithubRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
        networkInfo: Get.find(),
        storage: Get.find(),
      ),
      permanent: true,
    );
    Get.put<SortPreferenceRepository>(
      SortPreferenceRepositoryImpl(Get.find()),
      permanent: true,
    );
  }
}
