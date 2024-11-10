import 'package:clean_architecture/features/warnings/domain/entities/warning.dart';
import 'package:clean_architecture/features/warnings/domain/entities/description.dart';
import 'package:clean_architecture/features/warnings/data/models/description_model.dart';

class WarningModel {
  final String id;
  final DateTime date;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String equipment;
  final double excessPercent;
  final String text;
  final String type;
  final String value;
  final bool viewed;
  final Description? description;

  WarningModel({
    required this.id,
    required this.date,
    required this.dateFrom,
    required this.dateTo,
    required this.equipment,
    required this.excessPercent,
    required this.text,
    required this.type,
    required this.value,
    required this.viewed,
    required this.description,
  });

  factory WarningModel.fromJson(Map<String, dynamic> json) {
    return WarningModel(
      id: json['_id'],
      date: DateTime.parse(json['date']),
      dateFrom: DateTime.parse(json['date_from']),
      dateTo: DateTime.parse(json['date_to']),
      equipment: json['equipment'],
      excessPercent: json['excess_percent'],
      text: json['text'],
      type: json['type'],
      value: json['value'],
      viewed: json['viewed'] ?? false,
      description: json['description'] != null
          ? DescriptionModel.fromJson(json['description']).toEntity()
          : null,
    );
  }

  Warning toEntity() => Warning(
    id: id,
    date: date,
    dateFrom: dateFrom,
    dateTo: dateTo,
    equipment: equipment,
    excessPercent: excessPercent,
    text: text,
    type: type,
    value: value,
    viewed: viewed,
    description: description,
  );
}