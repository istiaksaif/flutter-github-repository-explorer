class RepositoryEntity {
  const RepositoryEntity({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.ownerAvatarUrl,
    required this.description,
    required this.stargazersCount,
    required this.updatedAt,
    required this.forksCount,
    required this.openIssuesCount,
    required this.watchersCount,
    required this.htmlUrl,
    required this.homepage,
    required this.topics,
    required this.licenseName,
  });

  final int id;
  final String name;
  final String ownerName;
  final String ownerAvatarUrl;
  final String description;
  final int stargazersCount;
  final DateTime updatedAt;
  final int forksCount;
  final int openIssuesCount;
  final int watchersCount;
  final String htmlUrl;
  final String homepage;
  final List<String> topics;
  final String licenseName;
}
