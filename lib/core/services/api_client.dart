import 'dart:developer';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../network/network_info.dart';
import '../utils/app_failure.dart';

class ApiClient {
  ApiClient({required this.client, required this.networkInfo});

  final http.Client client;
  final NetworkInfo networkInfo;

  Future<http.Response> getData({
    required String path,
    Map<String, String>? queryParameters,
    Future<void> Function()? retryCallback,
  }) async {
    final connected = await networkInfo.isConnected;
    if (!connected) throw AppFailure('No internet connection');

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}$path',
    ).replace(queryParameters: queryParameters);

    try {
      final response = await client.get(uri);
      return response;
    } catch (e, s) {
      log('ApiClient GET failed: $e', stackTrace: s);
      if (retryCallback != null) {
        // Schedule retry via provided callback.
        retryCallback();
      }
      rethrow;
    }
  }
}
