import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/entities/chart_point.dart';
import '../services/generate_colors.dart';
import '../services/mini_chart_service.dart';

class MiniChart extends StatelessWidget {
  final List<ChartPoint> chartPoints;
  final String title;
  final String unit;
  final double? threshold;
  final double minValue;
  final double maxValue;
  final List<Color> colors;

  MiniChart({
    super.key,
    required List<double> data,
    required this.title,
    required this.unit,
    required this.threshold,
  }) :
        chartPoints = ChartDataService().convertToChartPoints(data),
        minValue = ChartDataService().getMinValue(ChartDataService().convertToChartPoints(data)),
        maxValue = ChartDataService().getMaxValue(ChartDataService().convertToChartPoints(data)),
        colors = ColorService().generateColors(ChartDataService().convertToChartPoints(data), threshold);

  @override
  Widget build(BuildContext context) {
    final chartDataService = ChartDataService();
    return SizedBox(
      height: 60,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ${chartPoints.last.y.ceil()} $unit',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: LineChart(
              duration: const Duration(),
              LineChartData(
                minY: minValue,
                maxY: maxValue,
                lineBarsData: [
                  LineChartBarData(
                    spots: chartDataService.convertToFlSpots(chartPoints),
                    isCurved: true,
                    curveSmoothness: 0.1,
                    gradient: colors.length >= 2 ? LinearGradient(colors: colors) : null,
                    dotData: const FlDotData(show: false),
                    //color: chartPoints.last.y > threshold ? Colors.red : Colors.blue,
                  ),
                ],
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: maxValue.toStringAsFixed(0).length * 6,
                      getTitlesWidget: (value, meta) {
                        if (value == minValue || value == maxValue) {
                          return Text(
                            ((value > -1 && value < 0) ? value : value + 1)
                                .toStringAsFixed(0),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toStringAsFixed(1)} $unit',
                          TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        const FlLine(
                          color: Colors.blueGrey,
                          strokeWidth: 2,
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: colors[index],
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}