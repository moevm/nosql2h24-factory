import '../../../../core/http/api_client.dart';
import '../../../../shared/data/datasources/remote_datasourse.dart';

abstract class SettingsRemoteDataSource extends RemoteDataSource{
  SettingsRemoteDataSource({required super.client}): super(basePath: '/settings');
  Future<void> exportSettings(Map<String, dynamic> body);
  Future<Map<String, dynamic>> importSettings();
}

class SettingsRemoteDataSourceImpl extends SettingsRemoteDataSource {
  SettingsRemoteDataSourceImpl({required super.client});

  @override
  Future<void> exportSettings(Map<String, dynamic> body) async {
    await makeRequest(
      path: 'export_settings',
      method: RequestMethod.POST,
      body: body
    );
    return;
  }

  @override
  Future<Map<String, dynamic>> importSettings() async {
    return await makeRequest(
        path: 'import_settings',
        method: RequestMethod.GET,
    );
  }
}