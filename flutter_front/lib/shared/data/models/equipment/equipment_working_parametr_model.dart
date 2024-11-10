import 'dart:convert';

import '../../../domain/entities/equipment/equipment_working_parametr_entity.dart';

class WorkingParameterModel {
  final String name;
  final double threshold;

  WorkingParameterModel({
    required this.name,
    required this.threshold,
  });

  factory WorkingParameterModel.fromJson(String str) =>
      WorkingParameterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkingParameterModel.fromMap(Map<String, dynamic> json) =>
      WorkingParameterModel(
        name: json["name"],
        threshold: json["threshold"]?.toDouble(),
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "threshold": threshold,
  };

  factory WorkingParameterModel.fromEntity(WorkingParameterEntity entity) =>
      WorkingParameterModel(
        name: entity.name,
        threshold: entity.threshold,
      );

  WorkingParameterEntity toEntity() => WorkingParameterEntity(
    name: name,
    threshold: threshold,
  );
}