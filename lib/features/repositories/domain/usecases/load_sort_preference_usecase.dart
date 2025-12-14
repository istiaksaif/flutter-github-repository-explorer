import '../entities/sort_option.dart';
import '../repositories/sort_preference_repository.dart';

class LoadSortPreferenceUseCase {
  LoadSortPreferenceUseCase(this.repository);

  final SortPreferenceRepository repository;

  Future<SortPreference> call() => repository.loadPreference();
}
