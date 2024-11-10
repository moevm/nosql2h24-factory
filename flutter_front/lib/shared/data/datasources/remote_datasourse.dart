import 'dart:convert';

import '../../../core/error/exception.dart';
import '../../../core/http/api_client.dart';

abstract class RemoteDataSource {
  final ApiClient client;
  final String basePath;

  RemoteDataSource({required this.client, required this.basePath});

  String getFullPath(String path) => '$basePath/$path';

  Future<dynamic> makeRequest({
    required String path,
    required RequestMethod method,
    Map<String, dynamic>? params,
    dynamic body,
  }) async {
    final response = await client.request(
      path: getFullPath(path),
      method: method,
      params: params,
      body: body,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException();
    }
  }
}