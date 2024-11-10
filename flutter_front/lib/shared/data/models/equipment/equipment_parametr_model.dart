import 'dart:convert';

import '../../../domain/entities/equipment/equipment_parametr_entity.dart';
import 'equipment_subparametr_model.dart';

class ParameterModel {
  final String translate;
  final String unit;
  final double? threshold;
  final Map<String, SubparameterModel> subparameters;

  ParameterModel({
    required this.translate,
    required this.unit,
    this.threshold,
    required this.subparameters,
  });

  factory ParameterModel.fromJson(String str) => ParameterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ParameterModel.fromMap(Map<String, dynamic> json) =>
      ParameterModel(
        translate: json["translate"],
        unit: json["unit"],
        threshold: json["threshold"]?.toDouble(),
        subparameters: Map.from(json["subparameters"]).map((k, v) =>
            MapEntry<String, SubparameterModel>(k, SubparameterModel.fromMap(v))),
      );

  Map<String, dynamic> toMap() =>
      {
        "translate": translate,
        "unit": unit,
        "threshold": threshold,
        "subparameters": Map.from(subparameters)
            .map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };

  factory ParameterModel.fromEntity(ParameterEntity entity) =>
      ParameterModel(
        translate: entity.translate,
        unit: entity.unit,
        threshold: entity.threshold,
        subparameters: entity.subparameters
            .map((key, value) => MapEntry(key, SubparameterModel.fromEntity(value))),
      );

  ParameterEntity toEntity() =>
      ParameterEntity(
        translate: translate,
        unit: unit,
        threshold: threshold,
        subparameters:
        subparameters.map((key, value) => MapEntry(key, value.toEntity())),
      );
}