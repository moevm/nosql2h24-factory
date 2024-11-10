import 'dart:convert';

import '../../../domain/entities/equipment/equipment_metadata_entity.dart';

class MetadataModel {
  final DateTime? lastUpdated;
  final List<String>? tags;
  final String? qrCode;

  MetadataModel({
    this.lastUpdated,
    this.tags,
    this.qrCode,
  });

  factory MetadataModel.fromJson(String str) => MetadataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MetadataModel.fromMap(Map<String, dynamic> json) => MetadataModel(
    lastUpdated: json["lastUpdated"] != null ? DateTime.parse(json["lastUpdated"]) : null,
    tags: json["tags"] != null ? List<String>.from(json["tags"]) : null,
    qrCode: json["qrCode"],
  );

  Map<String, dynamic> toMap() => {
    "lastUpdated": lastUpdated?.toIso8601String(),
    "tags": tags != null ? List<dynamic>.from(tags!) : null,
    "qrCode": qrCode,
  };

  factory MetadataModel.fromEntity(MetadataEntity entity) => MetadataModel(
    lastUpdated: entity.lastUpdated,
    tags: entity.tags != null ? List<String>.from(entity.tags!) : null,
    qrCode: entity.qrCode,
  );

  MetadataEntity toEntity() => MetadataEntity(
    lastUpdated: lastUpdated,
    tags: tags != null ? List<String>.from(tags!) : null,
    qrCode: qrCode,
  );
}