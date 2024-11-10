import '../../../../core/types/formatDuration.dart';

class WarningStatisticsEntity {
  final DurationEntity duration;
  final ExcessPercentEntity excessPercent;
  final int totalCount;

  WarningStatisticsEntity({
    required this.duration,
    required this.excessPercent,
    required this.totalCount,
  });
}

class DurationEntity {
  final String avgFormatted;
  final String maxFormatted;
  final String minFormatted;
  final String totalFormatted;
  final double avg;
  final double max;
  final double min;
  final double total;

  DurationEntity({
    required this.avg,
    required this.max,
    required this.min,
    required this.total,
  }) :
        avgFormatted = formatDuration(avg),
        maxFormatted = formatDuration(max),
        minFormatted = formatDuration(min),
        totalFormatted = formatDuration(total);
}

class ExcessPercentEntity {
  final String avgFormatted;
  final String maxFormatted;
  final String minFormatted;
  final double avg;
  final double max;
  final double min;

  ExcessPercentEntity({
    required this.avg,
    required this.max,
    required this.min,
  }) :
        avgFormatted = '${avg.toStringAsFixed(2)}%',
        maxFormatted = '${max.toStringAsFixed(2)}%',
        minFormatted = '${min.toStringAsFixed(2)}%';
}