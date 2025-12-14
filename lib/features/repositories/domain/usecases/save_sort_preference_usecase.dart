import '../entities/sort_option.dart';
import '../repositories/sort_preference_repository.dart';

class SaveSortPreferenceUseCase {
  SaveSortPreferenceUseCase(this.repository);

  final SortPreferenceRepository repository;

  Future<void> call(SortPreference preference) =>
      repository.savePreference(preference);
}
