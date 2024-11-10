import 'dart:convert';

import '../../../domain/entities/equipment/equipment_entity.dart';
import 'equipment_details_model.dart';
import 'equipment_metadata_model.dart';
import 'equipment_parametr_model.dart';
import 'equipment_working_parametr_model.dart';
import 'equipment_working_time_model.dart';

class EquipmentModel {
  final String id;
  final String key;
  final String name;
  final EquipmentDetailsModel details;
  final Map<String, ParameterModel> parameters;
  final WorkingParameterModel? workingParameter;
  final MetadataModel? metadata;
  final WorkingTimeModel workingTime;

  EquipmentModel({
    required this.id,
    required this.key,
    required this.name,
    required this.details,
    required this.parameters,
    this.workingParameter,
    required this.metadata,
    required this.workingTime,
  });

  factory EquipmentModel.fromJson(String str) => EquipmentModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EquipmentModel.fromMap(Map<String, dynamic> json) => EquipmentModel(
        id: json["_id"],
        key: json["key"],
        name: json["name"],
        details: EquipmentDetailsModel.fromMap(json["details"]),
        parameters: Map.from(json["parameters"]).map(
            (k, v) => MapEntry<String, ParameterModel>(k, ParameterModel.fromMap(v))),
        workingParameter: json["working_parameter"] == null
            ? null
            : (json["working_parameter"]["name"] == "" ? null : WorkingParameterModel.fromMap(json["working_parameter"])),
        metadata: json["metadata"] == null ? null : MetadataModel.fromMap(json["metadata"]),
        workingTime:  WorkingTimeModel.fromMap(json["working_time"] ?? {}),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "name": name,
        "details": details.toMap(),
        "parameters": Map.from(parameters)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "workingParameter": workingParameter?.toMap(),
        "metadata": metadata?.toMap(),
        "workingTime": workingTime.toMap(),
      };

  factory EquipmentModel.fromEntity(EquipmentEntity entity) => EquipmentModel(
        id: entity.id,
        key: entity.key,
        name: entity.name,
        details: EquipmentDetailsModel.fromEntity(entity.details),
        parameters: entity.parameters
            .map((key, value) => MapEntry(key, ParameterModel.fromEntity(value))),
        workingParameter: entity.workingParameter != null
            ? WorkingParameterModel.fromEntity(entity.workingParameter!)
            : null,
    metadata: entity.metadata != null
        ? MetadataModel.fromEntity(entity.metadata!)
        : null,
        workingTime: WorkingTimeModel.fromEntity(entity.workingTime),
      );

  EquipmentEntity toEntity() => EquipmentEntity(
        id: id,
        key: key,
        name: name,
        details: details.toEntity(),
        parameters:
            parameters.map((key, value) => MapEntry(key, value.toEntity())),
        workingParameter: workingParameter?.toEntity(),
        metadata: metadata?.toEntity(),
        workingTime: workingTime.toEntity(),
      );
}