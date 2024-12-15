import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';

import 'equipment_parametr_entity.dart';

class EquipmentListEntity {
  final List<EquipmentEntity> equipment;

  Map<String, String> getKeysAndNames(){
    Map<String, String> res = {};
    for(EquipmentEntity entity in equipment){
      res[entity.key] = entity.name;
    }
    return res;
  }

  Map<String, ParameterEntity> getCommonParameters(List<String> equipmentKeys) {
    if (equipmentKeys.isEmpty) return {};

    var firstEquipment = equipment.firstWhere((e) => e.key == equipmentKeys[0]);
    Map<String, ParameterEntity> commonParams = Map.from(firstEquipment.parameters);

    for (var key in equipmentKeys.skip(1)) {
      var equip = equipment.firstWhere((e) => e.key == key);
      commonParams.removeWhere((paramKey, parameter) {
        return !equip.parameters.containsKey(paramKey) ||
            equip.parameters[paramKey]?.unit != parameter.unit;
      });
    }

    return commonParams;
  }

  const EquipmentListEntity({required this.equipment});

  EquipmentListEntity filterEquipment(Map<String, dynamic> filters) {
    if (filters.isEmpty) return this;

    List<EquipmentEntity> filteredEquipment = equipment.where((item) {
      // Check name filter
      if (filters.containsKey('name')) {
        String nameFilter = filters['name'].toString().toLowerCase();
        if (!item.name.toLowerCase().contains(nameFilter)) {
          return false;
        }
      }

      // Check location filter
      if (filters.containsKey('location')) {
        String locationFilter = filters['location'].toString().toLowerCase();
        if (!item.details.location.toLowerCase().contains(locationFilter)) {
          return false;
        }
      }

      // Check group filter
      if (filters.containsKey('group')) {
        String groupFilter = filters['group'].toString().toLowerCase();
        if (!item.details.group.toLowerCase().contains(groupFilter)) {
          return false;
        }
      }

      // Check year filter
      if (filters.containsKey('year')) {
        String yearRange = filters['year'];
        List<String> years = yearRange.split('-');
        int startYear = int.parse(years[0]);
        int endYear = int.parse(years[1]);

        if (item.details.year < startYear || item.details.year > endYear) {
          return false;
        }
      }

      // Check status filter
      if (filters.containsKey('status')) {
        String statusFilter = filters['status'].toString().toLowerCase();
        if (!item.details.status.toLowerCase().contains(statusFilter)) {
          return false;
        }
      }

      return true;
    }).toList();

    return EquipmentListEntity(equipment: filteredEquipment);
  }
}