import 'package:get/get.dart';

import '../../domain/usecases/get_repositories_usecase.dart';
import '../../domain/usecases/get_repository_details_usecase.dart';
import '../../domain/usecases/load_sort_preference_usecase.dart';
import '../../domain/usecases/save_sort_preference_usecase.dart';
import '../controllers/repository_details_controller.dart';
import '../controllers/repository_list_controller.dart';

class RepositoryListBinding extends Bindings {
  @override
  void dependencies() {
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
    Get.lazyPut(() => GetRepositoryDetailsUseCase(Get.find()));
    Get.lazyPut(() => RepositoryDetailsController(Get.find()));
  }
}
