import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../models/repository_model.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/api_client.dart';

abstract class GithubRemoteDataSource {
  Future<List<RepositoryModel>> fetchRepositories();
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  GithubRemoteDataSourceImpl(this.apiClient);

  final ApiClient apiClient;

  @override
  Future<List<RepositoryModel>> fetchRepositories() async {
    final response = await apiClient.getData(
      path: ApiConstants.searchRepositories,
      queryParameters: {
        'q': ApiConstants.defaultQuery,
        'sort': 'stars',
        'order': 'desc',
        'per_page': ApiConstants.maxItems.toString(),
      },
    );

    if (response.statusCode == 200) {
      return compute(_parseRepositories, response.body);
    }

    throw Exception('Failed to fetch repositories (${response.statusCode})');
  }
}

List<RepositoryModel> _parseRepositories(String body) {
  final data = json.decode(body) as Map<String, dynamic>;
  final items = (data['items'] as List<dynamic>? ?? [])
      .cast<Map<String, dynamic>>();
  return items.map(RepositoryModel.fromJson).toList();
}
