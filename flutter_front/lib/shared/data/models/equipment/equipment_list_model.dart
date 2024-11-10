import 'dart:convert';
import 'package:clean_architecture/shared/data/models/equipment/equipment_model.dart';
import 'package:clean_architecture/shared/domain/entities/equipment/equipment_list_entity.dart';

class EquipmentListModel {
  final List<EquipmentModel> equipment;

  EquipmentListModel({required this.equipment});

  factory EquipmentListModel.fromJson(List<dynamic> json) =>
      EquipmentListModel.fromList(json);

  String toJson() => json.encode(equipment.map((e) => e.toMap()).toList());

  factory EquipmentListModel.fromList(List<dynamic> list) =>
      EquipmentListModel(
        equipment: list.map((x) => EquipmentModel.fromMap(x)).toList(),
      );

  EquipmentListEntity toEntity() {
    return EquipmentListEntity(
      equipment: equipment.map((e) => e.toEntity()).toList(),
    );
  }

  factory EquipmentListModel.fromEntity(EquipmentListEntity entity) {
    return EquipmentListModel(
      equipment: entity.equipment.map((e) => EquipmentModel.fromEntity(e)).toList(),
    );
  }
}