import 'dart:math';

import 'package:fl_chart/fl_chart.dart';

import '../domain/entities/chart_point.dart';

class ChartDataService {
  List<ChartPoint> convertToChartPoints(List<double> data) {
    return data.asMap().entries.map((entry) =>
        ChartPoint(entry.key.toDouble(), entry.value)).toList();
  }

  double getMinValue(List<ChartPoint> points) =>
      points.map((p) => p.y).reduce(min) - 1;

  double getMaxValue(List<ChartPoint> points) =>
      points.map((p) => p.y).reduce(max) + 1;

  List<FlSpot> convertToFlSpots(List<ChartPoint> points) {
    return points.map((point) => point.toFlSpot()).toList();
  }
}