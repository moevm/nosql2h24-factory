import '../../domain/entities/warning_statistics_entity.dart';

class WarningStatisticsModel {
  final Duration duration;
  final ExcessPercent excessPercent;
  final int totalCount;

  WarningStatisticsModel({
    required this.duration,
    required this.excessPercent,
    required this.totalCount,
  });

  factory WarningStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WarningStatisticsModel(
      duration: Duration.fromJson(json['duration'] as Map<String, dynamic>),
      excessPercent: ExcessPercent.fromJson(json['excess_percent'] as Map<String, dynamic>),
      totalCount: json['total_count'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'duration': duration.toJson(),
    'excess_percent': excessPercent.toJson(),
    'total_count': totalCount,
  };

  WarningStatisticsEntity toEntity() => WarningStatisticsEntity(
    duration: duration.toEntity(),
    excessPercent: excessPercent.toEntity(),
    totalCount: totalCount,
  );
}

class Duration {
  final double avg;
  final double max;
  final double min;
  final double total;

  Duration({
    required this.avg,
    required this.max,
    required this.min,
    required this.total,
  });

  factory Duration.fromJson(Map<String, dynamic> json) {
    return Duration(
      avg: json['avg'] as double,
      max: json['max'] as double,
      min: json['min'] as double,
      total: json['total'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    'avg': avg,
    'max': max,
    'min': min,
    'total': total,
  };

  DurationEntity toEntity() => DurationEntity(
    avg: avg,
    max: max,
    min: min,
    total: total,
  );
}

class ExcessPercent {
  final double avg;
  final double max;
  final double min;

  ExcessPercent({
    required this.avg,
    required this.max,
    required this.min,
  });

  factory ExcessPercent.fromJson(Map<String, dynamic> json) {
    return ExcessPercent(
      avg: json['avg'] as double,
      max: json['max'] as double,
      min: json['min'] as double,
    );
  }

  Map<String, dynamic> toJson() => {
    'avg': avg,
    'max': max,
    'min': min,
  };

  ExcessPercentEntity toEntity() => ExcessPercentEntity(
    avg: avg,
    max: max,
    min: min,
  );
}