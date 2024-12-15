import '../../../../core/http/api_client.dart';
import '../../../../shared/data/models/equipment/equipment_list_model.dart';
import '../remote_datasourse.dart';

abstract class EquipmentRemoteDataSource extends RemoteDataSource {
  EquipmentRemoteDataSource({required super.client}) : super(basePath: '/equipment');

  Future<EquipmentListModel> getEquipment({Map<String, dynamic>? params});
}

class EquipmentRemoteDataSourceImpl extends EquipmentRemoteDataSource {
  EquipmentRemoteDataSourceImpl({required super.client});

  @override
  Future<EquipmentListModel> getEquipment({Map<String, dynamic>? params}) async {
    final response = await makeRequest(
      path: 'equipment_info',
      method: RequestMethod.GET,
      params: params
    );
    return EquipmentListModel.fromJson(response);
  }
}