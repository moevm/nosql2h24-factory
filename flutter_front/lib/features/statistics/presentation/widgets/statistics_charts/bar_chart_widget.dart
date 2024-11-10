import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/statistics_model.dart';
import '../../../domain/entities/statistics.dart';
import 'chart_formatters.dart';

class BarChartWidget extends StatelessWidget {
  final List<Statistics> statistics;
  final StatisticsMetric metric;
  final double maxY;
  final double barWidth;
  final double leftTitleSize;
  final double leftAxisTitleSize;
  final double bottomTitleSize;
  final int labelInterval;
  final double interval;
  final int? tooltipIndex;
  final ThemeData theme;

  const BarChartWidget({
    Key? key,
    required this.statistics,
    required this.metric,
    required this.maxY,
    required this.barWidth,
    required this.leftTitleSize,
    required this.leftAxisTitleSize,
    required this.bottomTitleSize,
    required this.labelInterval,
    required this.interval,
    required this.tooltipIndex,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: maxY * 1.1,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(enabled: false),
        titlesData: _buildTitlesData(),
        borderData: FlBorderData(show: false),
        gridData: _buildGridData(),
        barGroups: _buildBarGroups(),
      ),
    );
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: _buildBottomTitles(),
      leftTitles: _buildLeftTitles(),
    );
  }

  AxisTitles _buildBottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: bottomTitleSize,
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          if (index >= statistics.length) return const SizedBox();
          if (index % labelInterval != 0) return const SizedBox();
          return Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              statistics[index].x,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }

  AxisTitles _buildLeftTitles() {
    return AxisTitles(
      axisNameSize: leftAxisTitleSize,
      axisNameWidget: Text(
        metric.label,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
      sideTitles: SideTitles(
        showTitles: true,
        maxIncluded: false,
        reservedSize: leftTitleSize,
        interval: interval,
        getTitlesWidget: (value, meta) =>
            Text(ChartFormatters.getFormattedValue(metric, value)),
      ),
    );
  }


  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return statistics.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data.y,
            color: tooltipIndex == index ? theme.primaryColor.withOpacity(0.8) : theme.primaryColor,
            width: barWidth,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
            ),
          ),
        ],
      );
    }).toList();
  }
}