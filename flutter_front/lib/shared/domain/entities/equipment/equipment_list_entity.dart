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
}