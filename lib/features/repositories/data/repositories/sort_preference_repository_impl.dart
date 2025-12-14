import 'package:get_storage/get_storage.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../domain/entities/sort_option.dart';
import '../../domain/repositories/sort_preference_repository.dart';

class SortPreferenceRepositoryImpl implements SortPreferenceRepository {
  SortPreferenceRepositoryImpl(this._storage);

  final GetStorage _storage;

  @override
  Future<SortPreference> loadPreference() async {
    final fieldValue =
        _storage.read<String>(StorageKeys.sortField) ?? SortField.stars.name;
    final orderValue =
        _storage.read<String>(StorageKeys.sortOrder) ??
        SortOrder.descending.name;

    final field = SortField.values.firstWhere(
      (value) => value.name == fieldValue,
      orElse: () => SortField.stars,
    );
    final order = SortOrder.values.firstWhere(
      (value) => value.name == orderValue,
      orElse: () => SortOrder.descending,
    );

    return SortPreference(field: field, order: order);
  }

  @override
  Future<void> savePreference(SortPreference preference) async {
    await _storage.write(StorageKeys.sortField, preference.field.name);
    await _storage.write(StorageKeys.sortOrder, preference.order.name);
  }
}
