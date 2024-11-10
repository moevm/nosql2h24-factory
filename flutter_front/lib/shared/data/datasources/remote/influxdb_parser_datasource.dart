import 'package:clean_architecture/shared/domain/entities/chart_point.dart';
import 'package:clean_architecture/shared/services/mini_chart_service.dart';

import '../../../../core/http/api_client.dart';
import '../../../../shared/data/models/equipment/equipment_list_model.dart';
import '../../models/minichart_data_model.dart';
import '../remote_datasourse.dart';

abstract class InfluxdbParserRemoteDataSource extends RemoteDataSource {
  InfluxdbParserRemoteDataSource({required super.client}) : super(basePath: '/influx_parser');

  Future<MiniChartDataModel> getLiveCharts(Map<String, dynamic> body);
  Future<Map<String, dynamic>> getEquipmentWorkingPercentage(Map<String, dynamic> body);
  Future<List<double>> getStatisticWorkingPercentage(Map<String, dynamic> body);
}

class InfluxdbParserRemoteDataSourceImpl extends InfluxdbParserRemoteDataSource {
  InfluxdbParserRemoteDataSourceImpl({required super.client});

  @override
  Future<MiniChartDataModel> getLiveCharts(Map<String, dynamic> body) async {
    final response = await makeRequest(
        path: 'live-charts',
        method: RequestMethod.POST,
        body: body
    );
    return(MiniChartDataModel.fromJson(response));
  }

  @override
  Future<Map<String, dynamic>> getEquipmentWorkingPercentage(Map<String, dynamic> body) async {
    final res = await makeRequest(
        path: 'get_working_percentage',
        method: RequestMethod.POST,
        body: body
    );
    return res;
  }

  @override
  Future<List<double>> getStatisticWorkingPercentage(Map<String, dynamic> body) async {
    final res = await makeRequest(
        path: 'work_percent',
        method: RequestMethod.POST,
        body: body
    );
    return (res as List).map((item) => (item as num).toDouble()).toList();
  }
}