import 'package:clean_architecture/features/statistics/domain/entities/warning_statistics_entity.dart';
import 'package:clean_architecture/features/warnings/data/models/warning_model.dart';
import 'package:clean_architecture/features/warnings/data/models/warnings_response_model.dart';
import 'package:clean_architecture/shared/data/datasources/remote_datasourse.dart';

import '../../../../core/http/api_client.dart';
import '../models/statistics_model.dart';
import '../models/warning_statistics.dart';

abstract class StatisticsDatasource extends RemoteDataSource {
  StatisticsDatasource({required super.client}) : super(basePath: '/statistics');

  Future<List<StatisticsModel>> getWarningStatistics(Map<String, dynamic> params);
  Future<Map<String, dynamic>> getEquipmentWarningsStatistics(Map<String, dynamic> params);
}

class StatisticsDatasourceImpl extends StatisticsDatasource {
  StatisticsDatasourceImpl({required super.client});

  @override
  Future<List<StatisticsModel>> getWarningStatistics(Map<String, dynamic> params) async {
    final res = await makeRequest(
      path: 'warning_statistics',
      method: RequestMethod.GET,
      params: params,
    );
    return StatisticsModel.fromJsonList(res);
  }

  @override
  Future<Map<String, dynamic>> getEquipmentWarningsStatistics(Map<String, dynamic> params) async {
    print(params);
    final res = await makeRequest(
      path: 'equipment_warning_statistics',
      method: RequestMethod.GET,
      params: params,
    );
    print(res);
    return res;
  }
}