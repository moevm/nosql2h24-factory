import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> workPercentage;
  final int dataLength;
  final double leftTitleSize;
  final double leftAxisTitleSize;
  final double bottomTitleSize;
  final double interColumnWidth;
  final int? tooltipIndex;

  const LineChartWidget({
    super.key,
    required this.workPercentage,
    required this.dataLength,
    required this.leftTitleSize,
    required this.leftAxisTitleSize,
    required this.bottomTitleSize,
    required this.interColumnWidth,
    required this.tooltipIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftTitleSize + interColumnWidth + leftAxisTitleSize,
        right: interColumnWidth,
        bottom: bottomTitleSize,
      ),
      child: LineChart(
        LineChartData(
          maxY: 100*1.1,
          minY: 0,
          titlesData: const FlTitlesData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          lineBarsData: [_buildLineChartBarData()],
        ),
      ),
    );
  }

  LineChartBarData _buildLineChartBarData() {
    return LineChartBarData(
      spots: List.generate(
        dataLength,
            (index) => FlSpot(index.toDouble(), workPercentage[index]),
      ),
      color: Colors.grey,
      barWidth: 2,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: tooltipIndex == index ? 3 : 0,
            color: Colors.grey,
          );
        },
      ),
      isCurved: true,
      preventCurveOverShooting: true,
      isStrokeCapRound: true,
    );
  }
}