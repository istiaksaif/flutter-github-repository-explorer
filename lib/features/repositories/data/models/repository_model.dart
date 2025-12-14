import '../../domain/entities/repository_entity.dart';

class RepositoryModel extends RepositoryEntity {
  RepositoryModel({
    required super.id,
    required super.name,
    required super.ownerName,
    required super.ownerAvatarUrl,
    required super.description,
    required super.stargazersCount,
    required super.updatedAt,
    required super.forksCount,
    required super.openIssuesCount,
    required super.watchersCount,
    required super.htmlUrl,
    required super.homepage,
    required super.topics,
    required super.licenseName,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    final license = json['license'] as Map<String, dynamic>?;
    final topics = (json['topics'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();
    return RepositoryModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      ownerName: owner['login'] as String? ?? '',
      ownerAvatarUrl: owner['avatar_url'] as String? ?? '',
      description: json['description'] as String? ?? '',
      stargazersCount: json['stargazers_count'] as int? ?? 0,
      updatedAt:
          DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      forksCount: json['forks_count'] as int? ?? 0,
      openIssuesCount: json['open_issues_count'] as int? ?? 0,
      watchersCount: json['watchers_count'] as int? ?? 0,
      htmlUrl: json['html_url'] as String? ?? '',
      homepage: json['homepage'] as String? ?? '',
      topics: topics,
      licenseName: license?['name'] as String? ?? '',
    );
  }

  factory RepositoryModel.fromDb(Map<String, dynamic> map) {
    return RepositoryModel(
      id: map['id'] as int,
      name: map['name'] as String? ?? '',
      ownerName: map['owner_name'] as String? ?? '',
      ownerAvatarUrl: map['owner_avatar_url'] as String? ?? '',
      description: map['description'] as String? ?? '',
      stargazersCount: map['stargazers_count'] as int? ?? 0,
      updatedAt:
          DateTime.tryParse(map['updated_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      forksCount: map['forks_count'] as int? ?? 0,
      openIssuesCount: map['open_issues_count'] as int? ?? 0,
      watchersCount: map['watchers_count'] as int? ?? 0,
      htmlUrl: map['html_url'] as String? ?? '',
      homepage: map['homepage'] as String? ?? '',
      topics: ((map['topics'] as String? ?? '').isEmpty)
          ? <String>[]
          : (map['topics'] as String).split(','),
      licenseName: map['license_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'owner_name': ownerName,
      'owner_avatar_url': ownerAvatarUrl,
      'description': description,
      'stargazers_count': stargazersCount,
      'updated_at': updatedAt.toIso8601String(),
      'forks_count': forksCount,
      'open_issues_count': openIssuesCount,
      'watchers_count': watchersCount,
      'html_url': htmlUrl,
      'homepage': homepage,
      'topics': topics.join(','),
      'license_name': licenseName,
    };
  }
}
