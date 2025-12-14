import 'package:get/get.dart';

import '../../domain/entities/repository_entity.dart';
import '../../domain/usecases/get_repository_details_usecase.dart';

class RepositoryDetailsController extends GetxController {
  RepositoryDetailsController(this._detailsUseCase);

  final GetRepositoryDetailsUseCase _detailsUseCase;

  final repository = Rxn<RepositoryEntity>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadFromArguments();
  }

  Future<void> _loadFromArguments() async {
    final args = Get.arguments;
    if (args is RepositoryEntity) {
      repository.value = args;
      return;
    }
    if (args is int) {
      await loadFromId(args);
      return;
    }
    errorMessage.value = 'No repository data provided';
    Get.snackbar('Error', errorMessage.value);
  }

  Future<void> loadFromId(int id) async {
    try {
      isLoading.value = true;
      final result = await _detailsUseCase(id);
      if (result != null) {
        repository.value = result;
      } else {
        errorMessage.value = 'Repository not found offline';
        Get.snackbar('Error', errorMessage.value);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
