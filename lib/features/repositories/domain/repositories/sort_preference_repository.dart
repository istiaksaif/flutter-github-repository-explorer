import '../entities/sort_option.dart';

abstract class SortPreferenceRepository {
  Future<SortPreference> loadPreference();
  Future<void> savePreference(SortPreference preference);
}
