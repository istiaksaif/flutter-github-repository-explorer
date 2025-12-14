import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../models/repository_model.dart';
import '../../../../../core/constants/api_constants.dart';

abstract class GithubRemoteDataSource {
  Future<List<RepositoryModel>> fetchRepositories();
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  GithubRemoteDataSourceImpl(this.client);

  final http.Client client;

  @override
  Future<List<RepositoryModel>> fetchRepositories() async {
    final uri =
        Uri.parse(
          '${ApiConstants.baseUrl}${ApiConstants.searchRepositories}',
        ).replace(
          queryParameters: {
            'q': ApiConstants.defaultQuery,
            'sort': 'stars',
            'order': 'desc',
            'per_page': ApiConstants.maxItems.toString(),
          },
        );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = (data['items'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();
      return items.map(RepositoryModel.fromJson).toList();
    }

    throw Exception('Failed to fetch repositories (${response.statusCode})');
  }
}
