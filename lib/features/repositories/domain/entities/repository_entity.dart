class RepositoryEntity {
  const RepositoryEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.description,
    required this.stargazersCount,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final String ownerName;
  final String ownerAvatarUrl;
  final String description;
  final int stargazersCount;
  final DateTime updatedAt;
}
