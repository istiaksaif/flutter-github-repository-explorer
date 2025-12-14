enum SortField { stars, updatedAt }

enum SortOrder { ascending, descending }

class SortPreference {
  const SortPreference({required this.field, required this.order});

  final SortField field;
  final SortOrder order;
}
