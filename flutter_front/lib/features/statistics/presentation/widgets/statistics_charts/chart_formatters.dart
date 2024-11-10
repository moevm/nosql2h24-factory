import '../../../../../core/types/formatDuration.dart';
import '../../../data/models/statistics_model.dart';

class ChartFormatters {
  static String getFormattedValue(StatisticsMetric metric, double value) {
    switch (metric) {
      case StatisticsMetric.avgDuration:
        return formatDuration(value);
      case StatisticsMetric.count:
        return value.toInt().toString();
      case StatisticsMetric.avgExcess:
        return '${value.toStringAsFixed(2)}%';
      default:
        return value.toStringAsFixed(2);
    }
  }
}