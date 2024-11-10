import 'dart:convert';

import '../../../domain/entities/equipment/equipment_subparametr_entity.dart';

class SubparameterModel {
  final String translate;
  final String topic;

  SubparameterModel({
    required this.translate,
    required this.topic,
  });

  factory SubparameterModel.fromJson(String str) =>
      SubparameterModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SubparameterModel.fromMap(Map<String, dynamic> json) => SubparameterModel(
    translate: json["translate"],
    topic: json["topic"],
  );

  Map<String, dynamic> toMap() => {
    "translate": translate,
    "topic": topic,
  };

  factory SubparameterModel.fromEntity(SubParameterEntity entity) => SubparameterModel(
    translate: entity.translate,
    topic: entity.topic,
  );

  SubParameterEntity toEntity() => SubParameterEntity(
    translate: translate,
    topic: topic,
  );
}