import '../../domain/entities/statistics.dart';

class StatisticsModel {
  final dynamic x;
  final double y;

  const StatisticsModel({
    required this.x,
    required this.y,
  });

  factory StatisticsModel.fromJson(Map<String, dynamic> json) {
    return StatisticsModel(
      x: json['x'],
      y: json['y'].toDouble(),
    );
  }

  factory StatisticsModel.fromEntity(Statistics entity) {
    return StatisticsModel(
      x: entity.x,
      y: entity.y,
    );
  }

  Statistics toEntity() {
    return Statistics(
      x: x,
      y: y,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'x': x,
      'y': y,
    };
  }

  static List<StatisticsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StatisticsModel.fromJson(json)).toList();
  }

  static List<Statistics> toEntityList(List<StatisticsModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}

enum StatisticsGroupBy {
  day('day', 'День'),
  weekday('weekday', 'День недели'),
  hour('hour', 'Час');

  final String value;
  final String label;

  const StatisticsGroupBy(this.value, this.label);

  static StatisticsGroupBy fromString(String value) {
    return StatisticsGroupBy.values.firstWhere(
          (e) => e.value == value,
      orElse: () => StatisticsGroupBy.day,
    );
  }
}

enum StatisticsMetric {
  count('count', 'Количество'),
  avgExcess('avg_excess', 'Средний процент'),
  avgDuration('avg_duration', 'Средняя длительность');

  final String value;
  final String label;

  const StatisticsMetric(this.value, this.label);

  static StatisticsMetric fromString(String value) {
    return StatisticsMetric.values.firstWhere(
          (e) => e.value == value,
      orElse: () => StatisticsMetric.count,
    );
  }
}