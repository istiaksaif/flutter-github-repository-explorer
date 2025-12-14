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
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
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
    };
  }
}
