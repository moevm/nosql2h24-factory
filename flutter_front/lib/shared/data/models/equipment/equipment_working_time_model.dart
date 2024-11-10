import 'dart:convert';

import '../../../domain/entities/equipment/equipment_working_time_entity.dart';

class WorkingTimeModel {
  final int work;
  final int allTime;
  final int notWork;
  final int turnOn;
  final int turnOff;

  WorkingTimeModel({
    required this.work,
    required this.allTime,
    required this.notWork,
    required this.turnOn,
    required this.turnOff,
  });

  factory WorkingTimeModel.fromJson(String str) =>
      WorkingTimeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkingTimeModel.fromMap(Map<String, dynamic> json) => WorkingTimeModel(
    work: json["work"] ?? 0,
    allTime: json["all_time"] ?? 0,
    notWork: json["not_work"] ?? 0,
    turnOn: json["turn_on"] ?? 0,
    turnOff: json["turn_off"] ?? 0,
  );

  Map<String, dynamic> toMap() => {
    "work": work,
    "allTime": allTime,
    "notWork": notWork,
    "turnOn": turnOn,
    "turnOff": turnOff,
  };

  factory WorkingTimeModel.fromEntity(WorkingTimeEntity entity) => WorkingTimeModel(
    work: entity.work,
    allTime: entity.allTime,
    notWork: entity.notWork,
    turnOn: entity.turnOn,
    turnOff: entity.turnOff,
  );

  WorkingTimeEntity toEntity() => WorkingTimeEntity(
    work: work,
    allTime: allTime,
    notWork: notWork,
    turnOn: turnOn,
    turnOff: turnOff,
  );
}