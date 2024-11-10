import 'package:clean_architecture/features/warnings/data/models/warning_model.dart';
import 'package:clean_architecture/features/warnings/data/models/warnings_response_model.dart';
import 'package:clean_architecture/shared/data/datasources/remote_datasourse.dart';

import '../../../../core/http/api_client.dart';

abstract class WarningsRemoteDataSource extends RemoteDataSource {
  WarningsRemoteDataSource({required super.client}) : super(basePath: '/warnings');

  Future<WarningsResponseModel> getWarnings(Map<String, dynamic> params);
  Future<void> warningsViewed(Map<String, String> body);
  Future<void> addDescription(Map<String, dynamic> body);
}

class WarningsRemoteDataSourceImpl extends WarningsRemoteDataSource {
  WarningsRemoteDataSourceImpl({required super.client});

  @override
  Future<WarningsResponseModel> getWarnings(Map<String, dynamic> params) async {
    final response = await makeRequest(
      path: 'get_warnings',
      method: RequestMethod.GET,
      params: params,
    );
    return WarningsResponseModel.fromJson(response);
  }

  @override
  Future<void> warningsViewed(Map<String, String> body) async {
    return await makeRequest(
      path: 'warnings_viewed',
      method: RequestMethod.POST,
      body: body,
    );
  }

  @override
  Future<void> addDescription(Map<String, dynamic> body) async {
    await makeRequest(
      path: 'add_description',
      method: RequestMethod.POST,
      body: body,
    );
    return;
  }
}