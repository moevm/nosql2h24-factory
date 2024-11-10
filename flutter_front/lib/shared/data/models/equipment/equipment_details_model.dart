import 'dart:convert';

import '../../../domain/entities/equipment/equipment_details_entity.dart';

class EquipmentDetailsModel {
  final String serialNumber;
  final String location;
  final String manufacturer;
  final String model;
  final String status;
  final int year;
  final String group;

  EquipmentDetailsModel({
    required this.serialNumber,
    required this.location,
    required this.manufacturer,
    required this.model,
    required this.status,
    required this.year,
    required this.group,
  });

  factory EquipmentDetailsModel.fromJson(String str) =>
      EquipmentDetailsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory EquipmentDetailsModel.fromMap(Map<String, dynamic> json) =>
      EquipmentDetailsModel(
        serialNumber: json["SN"],
        location: json["location"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        status: json["status"],
        year: json["year"],
        group: json["group"],
      );

  Map<String, dynamic> toMap() => {
    "serialNumber": serialNumber,
    "location": location,
    "manufacturer": manufacturer,
    "model": model,
    "status": status,
    "year": year,
    "group": group,
  };

  factory EquipmentDetailsModel.fromEntity(EquipmentDetailsEntity entity) =>
      EquipmentDetailsModel(
        serialNumber: entity.serialNumber,
        location: entity.location,
        manufacturer: entity.manufacturer,
        model: entity.model,
        status: entity.status,
        year: entity.year,
        group: entity.group,
      );

  EquipmentDetailsEntity toEntity() => EquipmentDetailsEntity(
    serialNumber: serialNumber,
    location: location,
    manufacturer: manufacturer,
    model: model,
    status: status,
    year: year,
    group: group,
  );
}