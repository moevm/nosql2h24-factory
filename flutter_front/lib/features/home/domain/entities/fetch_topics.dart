import 'package:clean_architecture/shared/domain/entities/equipment/equipment_entity.dart';
import 'package:flutter/foundation.dart';

class EquipmentMiniChart {
  final String name;
  final List<ParameterMiniChart> params;

  EquipmentMiniChart({required this.name, required this.params});

  Map<String, Map<String, List<String>>> toMap() {
    return {
      name: Map.fromEntries(params.map((topic) => MapEntry(topic.name, topic.subParams)))
    };
  }
}

class ParameterMiniChart {
  final String name;
  final List<String> subParams;

  ParameterMiniChart({required this.name, required this.subParams});
}

class FetchMiniChartsTopics {
  final List<EquipmentMiniChart> equipment;

  FetchMiniChartsTopics({required this.equipment});

  factory FetchMiniChartsTopics.fromMap(Map<dynamic, dynamic> map) {
    List<EquipmentMiniChart> equipmentList = [];

    map.forEach((equipmentName, topicsMap) {
      List<ParameterMiniChart> topics = [];

      (topicsMap as Map<dynamic, dynamic>).forEach((topicName, subtopicsList) {
        topics.add(ParameterMiniChart(
          name: topicName.toString(),
          subParams: (subtopicsList as List).map((e) => e.toString()).toList(),
        ));
      });

      equipmentList.add(EquipmentMiniChart(name: equipmentName.toString(), params: topics));
    });

    return FetchMiniChartsTopics(equipment: equipmentList);
  }

  Map<String, Map<String, List<String>>> toMap() {
    Map<String, Map<String, List<String>>> result = {};
    for (var equip in equipment) {
      result.addAll(equip.toMap());
    }
    return result;
  }
}

class UpdatedMiniChartsSettings {
  EquipmentEntity equipment;
  Map<String, List<String>> settings;
  bool forAll;

  UpdatedMiniChartsSettings(this.equipment, this.settings, this.forAll);
}