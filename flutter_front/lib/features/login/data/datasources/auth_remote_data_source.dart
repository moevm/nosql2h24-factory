// lib/features/auth/data/datasources/auth_remote_datasource.dart

import '../../../../core/http/api_client.dart';
import '../../../../shared/data/datasources/remote_datasourse.dart';
import '../../../../shared/data/models/logo_model.dart';
import '../models/auth_response.dart';

abstract class AuthRemoteDataSource extends RemoteDataSource {
  AuthRemoteDataSource({required super.client}) : super(basePath: '/auth');

  Future<AuthResponseModel> login(String username, String password);
  Future<LogoModel> getLogo();
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required super.client});

  @override
  Future<AuthResponseModel> login(String username, String password) async {
    final response = await makeRequest(
      path: 'login',
      method: RequestMethod.POST,
      body: {'username': username, 'password': password},
    );
    return AuthResponseModel.fromJson(response);
  }

  @override
  Future<LogoModel> getLogo() async {
    final response = await makeRequest(
      path: 'logo',
      method: RequestMethod.GET,
    );
    return LogoModel.fromJson(response);
  }
}