import 'dart:convert';
import 'package:clean_architecture/features/login/domain/repositories/auth_repository.dart';
import 'package:clean_architecture/features/splash/domain/repositories/splash_repository.dart';
import 'package:clean_architecture/locator_service.dart';
import 'package:clean_architecture/shared/domain/repositories/hive_repository.dart';
import 'package:clean_architecture/shared/domain/usecases/no_params.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/splash/domain/usecases/logout_usecase.dart';
import '../../shared/data/datasources/local/hive_datasource.dart';

enum RequestMethod { GET, POST, PUT, DELETE }

class ApiClient {
  final String baseUrl;
  final HiveRepository hiveRepository;

  final LogoutUseCase logoutUseCase;
  final router = GetIt.I<GoRouter>();

  ApiClient({required this.baseUrl, required this.hiveRepository, required this.logoutUseCase});

  Future<http.Response> request({
    required String path,
    required RequestMethod method,
    Map<String, dynamic>? params,
    dynamic body,
  }) async {
    final url = Uri.parse('$baseUrl$path');
    final headers = await _getHeaders();
    http.Response response;
    try {
      switch (method) {
        case RequestMethod.GET:
          response = await http.get(url.replace(queryParameters: params), headers: headers);
          break;
        case RequestMethod.POST:
          response = await http.post(url, headers: headers, body: jsonEncode(body));
          break;
        case RequestMethod.PUT:
          response = await http.put(url, headers: headers, body: jsonEncode(body));
          break;
        case RequestMethod.DELETE:
          response = await http.delete(url, headers: headers);
          break;
      }

      if (response.statusCode == 401) {
        final isRefreshed = await _refreshToken();
        if (isRefreshed) {
          return request(path: path, method: method, params: params, body: body);
        } else {
          await logoutUseCase(NoParams());
          router.go('/login');
        }
      }
      return response;
    } catch (e) {
      throw Exception('Failed to perform request: $e');
    }
  }

  Future<Map<String, String>> _getHeaders() async {
    final tokenResult = await hiveRepository.getToken();
    return tokenResult.fold(
          (exception) => {'Content-Type': 'application/json'},
          (token) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  Future<bool> _refreshToken() async {
    final refreshTokenResult = await hiveRepository.getRefreshToken();
    return refreshTokenResult.fold(
          (exception) => false,
          (refreshToken) async {
        final response = await http.post(
          Uri.parse('$baseUrl/auth/refresh_token'),
          headers: {
            'Authorization': 'Bearer $refreshToken',
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          await hiveRepository.saveToken(data['access_token']);
          await hiveRepository.saveRefreshToken(data['refresh_token']);
          return true;
        }
        return false;
      },
    );
  }
}
