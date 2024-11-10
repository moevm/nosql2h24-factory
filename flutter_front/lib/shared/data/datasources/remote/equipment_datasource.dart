import '../../../../core/http/api_client.dart';
import '../../../../shared/data/models/equipment/equipment_list_model.dart';
import '../remote_datasourse.dart';

abstract class EquipmentRemoteDataSource extends RemoteDataSource {
  EquipmentRemoteDataSource({required super.client}) : super(basePath: '/equipment');

  Future<EquipmentListModel> getEquipment();
}

class EquipmentRemoteDataSourceImpl extends EquipmentRemoteDataSource {
  EquipmentRemoteDataSourceImpl({required super.client});

  @override
  Future<EquipmentListModel> getEquipment() async {
    final response = await makeRequest(
      path: 'equipment_info',
      method: RequestMethod.GET,
    );
    return EquipmentListModel.fromJson(response);
  }
}