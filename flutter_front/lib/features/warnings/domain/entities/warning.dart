import 'package:clean_architecture/features/warnings/domain/entities/description.dart';

const _sentinel = Object();

class Warning {
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

  Warning({
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

  Warning copyWith({
    String? id,
    DateTime? date,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? equipment,
    double? excessPercent,
    String? text,
    String? type,
    String? value,
    bool? viewed,
    Object? description = _sentinel, // Меняем тип на Object? и добавляем значение по умолчанию
  }) {
    return Warning(
      id: id ?? this.id,
      date: date ?? this.date,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      equipment: equipment ?? this.equipment,
      excessPercent: excessPercent ?? this.excessPercent,
      text: text ?? this.text,
      type: type ?? this.type,
      value: value ?? this.value,
      viewed: viewed ?? this.viewed,
      description: description == _sentinel ? this.description : (description as Description?),
    );
  }
}