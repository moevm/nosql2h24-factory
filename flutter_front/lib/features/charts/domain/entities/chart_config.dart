// lib/features/charts/domain/entities/chart_config.dart

enum AggregationType {
  min,
  max,
  mean,
}

enum TimeRange {
  day,
  halfDay,
  hour,
  fifteenMinutes,
  custom,
}

String getInfluxString(TimeRange range) {
  switch (range) {
    case TimeRange.day:
      return '-1d';
    case TimeRange.halfDay:
      return '-12h';
    case TimeRange.hour:
      return '-1h';
    case TimeRange.fifteenMinutes:
      return '-15m';
    case TimeRange.custom:
      return '-5s'; // значение по умолчанию
  }
}


class ChartConfiguration {
  final bool showWarnings;
  final bool showAnomalies;
  final Set<AggregationType> selectedAggregations;
  final TimeRange timeRange;
  final DateTime customStartDate;
  final DateTime customEndDate;
  final Duration pointsDistance;
  final bool realTime;

  ChartConfiguration({
    this.showWarnings = false,
    this.showAnomalies = false,
    this.selectedAggregations = const {AggregationType.mean},
    this.timeRange = TimeRange.hour,
    DateTime? customStartDate,
    DateTime? customEndDate,
    this.pointsDistance = const Duration(minutes: 1),
    this.realTime = false,
  }) :
        customStartDate = customStartDate ?? DateTime.now().subtract(const Duration(days: 7)),
        customEndDate = customEndDate ?? DateTime.now();

  ChartConfiguration copyWith({
    bool? showWarnings,
    bool? showAnomalies,
    Set<AggregationType>? selectedAggregations,
    TimeRange? timeRange,
    DateTime? customStartDate,
    DateTime? customEndDate,
    Duration? pointsDistance,
    bool? realTime,
  }) {
    return ChartConfiguration(
      showWarnings: showWarnings ?? this.showWarnings,
      showAnomalies: showAnomalies ?? this.showAnomalies,
      selectedAggregations: selectedAggregations ?? this.selectedAggregations,
      timeRange: timeRange ?? this.timeRange,
      customStartDate: customStartDate ?? this.customStartDate,
      customEndDate: customEndDate ?? this.customEndDate,
      pointsDistance: pointsDistance ?? this.pointsDistance,
      realTime: realTime ?? this.realTime,
    );
  }
}