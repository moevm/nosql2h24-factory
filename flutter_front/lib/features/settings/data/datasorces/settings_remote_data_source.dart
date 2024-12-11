import '../../../../core/http/api_client.dart';
import '../../../../shared/data/datasources/remote_datasourse.dart';

abstract class SettingsRemoteDataSource extends RemoteDataSource{
  SettingsRemoteDataSource({required super.client}): super(basePath: '/settings');
  Future<void> exportSettings(Map<String, dynamic> body);
  Future<Map<String, dynamic>> importSettings();
  Future<SettingsSnapshot> importData();
  Future<void> exportData(String mongoData, String influxData);
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

  @override
  Future<void> exportData(String mongoData, String influxData) async {
    final snapshot = SettingsSnapshot(
      mongo: mongoData,
      influx: influxData,
    );

    await makeRequest(
        path: 'load_snapshot',
        method: RequestMethod.POST,
        body: snapshot.toJson()
    );
  }

  @override
  Future<SettingsSnapshot> importData() async {
    final res = await makeRequest(
      path: 'get_snapshot',
      method: RequestMethod.GET,
    );
    return SettingsSnapshot.fromJson(res);
  }
}

class SettingsSnapshot {
  final String mongo;
  final String influx;

  SettingsSnapshot({required this.mongo, required this.influx});

  Map<String, dynamic> toJson() => {
    'mongo': mongo,
    'influx': influx,
  };

  factory SettingsSnapshot.fromJson(Map<String, dynamic> json) {
    return SettingsSnapshot(
      mongo: json['mongo'] as String,
      influx: json['influx'] as String,
    );
  }
}