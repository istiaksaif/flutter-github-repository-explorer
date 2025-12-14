import 'package:get/get.dart';

import '../../../../core/utils/app_failure.dart';
import '../../domain/entities/repository_entity.dart';
import '../../domain/entities/sort_option.dart';
import '../../domain/usecases/get_repositories_usecase.dart';
import '../../domain/usecases/load_sort_preference_usecase.dart';
import '../../domain/usecases/save_sort_preference_usecase.dart';
import '../../../../core/network/network_info.dart';

class RepositoryListController extends GetxController {
  RepositoryListController({
    required this.getRepositoriesUseCase,
    required this.saveSortPreferenceUseCase,
    required this.loadSortPreferenceUseCase,
    required this.networkInfo,
  });

  final GetRepositoriesUseCase getRepositoriesUseCase;
  final SaveSortPreferenceUseCase saveSortPreferenceUseCase;
  final LoadSortPreferenceUseCase loadSortPreferenceUseCase;
  final NetworkInfo networkInfo;

  final repositories = <RepositoryEntity>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final offlineMode = false.obs;
  final sortPreference = const SortPreference(
    field: SortField.stars,
    order: SortOrder.descending,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    loadRepositories();
  }

  Future<void> loadRepositories() async {
    isLoading.value = true;
    errorMessage.value = '';
    final currentPreference = await loadSortPreferenceUseCase();
    sortPreference.value = currentPreference;

    final connected = await networkInfo.isConnected;
    offlineMode.value = !connected;

    try {
      final result = await getRepositoriesUseCase(currentPreference);
      repositories.assignAll(result);
    } catch (e) {
      final message = e is AppFailure ? e.message : 'Something went wrong';
      errorMessage.value = message;
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateSort(SortField field, SortOrder order) async {
    final newPreference = SortPreference(field: field, order: order);
    sortPreference.value = newPreference;
    await saveSortPreferenceUseCase(newPreference);
    _sortInMemory(newPreference);
  }

  void _sortInMemory(SortPreference preference) {
    final updated = [...repositories];
    updated.sort((a, b) {
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
    repositories.assignAll(updated);
  }
}
