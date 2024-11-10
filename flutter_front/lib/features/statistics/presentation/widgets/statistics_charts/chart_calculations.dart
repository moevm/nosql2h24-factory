import '../../../data/models/statistics_model.dart';
import '../../../domain/entities/statistics.dart';

class ChartCalculations {
  static int calculateLabelInterval(double availableWidth, int dataLength) {
    const averageLabelWidth = 100.0;
    final possibleLabels = availableWidth ~/ averageLabelWidth;
    if (dataLength == 0) return 1;
    return (dataLength / possibleLabels).ceil();
  }

  static double calculateMaxY(List<Statistics> statistics, StatisticsMetric metric) {
    if (statistics.isEmpty) return 0;
    final maxY = statistics.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    if (metric == StatisticsMetric.count) {
      return maxY.ceilToDouble();
    }
    return maxY;
  }

  static double calculateBarWidth(double availableWidth, int dataLength) {
    if (dataLength == 0) return 12;
    final effectiveWidth = availableWidth - 32;
    double maxBarWidth = (effectiveWidth / dataLength) * 0.7;
    return maxBarWidth.clamp(1.0, 25.0);
  }

  static double calculateInterColumnWidth(double availableWidth, int dataLength, double leftTitleSize) {
    return (availableWidth - leftTitleSize) / (dataLength * 2);
  }
}