import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  Future<void> copyRepositoryUrl() async {
    final repo = repository.value;
    if (repo == null || repo.htmlUrl.isEmpty) {
      Get.snackbar('Error', 'No repository URL available');
      return;
    }
    await Clipboard.setData(ClipboardData(text: repo.htmlUrl));
    Get.snackbar('Copied', 'Repository URL copied to clipboard');
  }

  Future<void> openForkPage() async {
    final repo = repository.value;
    if (repo == null || repo.htmlUrl.isEmpty) return;
    await _launchExternal('${repo.htmlUrl}/fork', 'Could not open fork page');
  }

  Future<void> downloadRepositoryArchive() async {
    final repo = repository.value;
    if (repo == null || repo.htmlUrl.isEmpty) return;
    final urls = <String>[
      '${repo.htmlUrl}/archive/refs/heads/main.zip',
      '${repo.htmlUrl}/archive/refs/heads/master.zip',
    ];
    for (final url in urls) {
      final launched = await _launchExternal(
        url,
        'Could not start download',
      );
      if (launched) {
        Get.snackbar('Download', 'Opening repository download in browser');
        return;
      }
    }
  }

  Future<bool> _launchExternal(String url, String errorMessage) async {
    final launched = await launchUrlString(url);
    if (!launched) {
      Get.snackbar('Error', errorMessage);
    }
    return launched;
  }
}
