import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../../data/models/statistics_model.dart';
import '../../../domain/entities/statistics.dart';
import '../custom_tooltip.dart';
import 'bar_chart_widget.dart';
import 'chart_calculations.dart';
import 'line_chart_widget.dart';
class StatisticsChart extends StatefulWidget {
  final List<Statistics> statistics;
  final StatisticsMetric metric;
  final List<double> workPercentage;

  const StatisticsChart({
    super.key,
    required this.statistics,
    required this.metric,
    required this.workPercentage,
  });

  @override
  State<StatisticsChart> createState() => _StatisticsChartState();
}

class _StatisticsChartState extends State<StatisticsChart> {
  bool _showWorkPercentage = true;
  final double leftTitleSize = 70;
  final double bottomTitleSize = 30;
  final double leftAxisTitleSize = 25;
  int? _tooltipIndex;
  Offset? _tooltipPosition;

  Widget _buildTooltip(int index, Offset position, BoxConstraints constraints) {
    if (index >= widget.statistics.length) return const SizedBox();

    const tooltipWidth = 230.0;
    const tooltipHeight = 100.0;
    final maxX = constraints.maxWidth;
    final maxY = constraints.maxHeight;

    double left = position.dx;
    if (left + tooltipWidth > maxX) {
      left = maxX - tooltipWidth - 16;
    }
    if (left < leftTitleSize) {
      left = leftTitleSize + 8;
    }

    double top = position.dy;
    if (top + tooltipHeight > maxY) {
      top = maxY - tooltipHeight - 16;
    }
    if (top < 8) {
      top = 8;
    }

    return Positioned(
      left: left,
      top: top,
      child: CustomTooltip(
        barValue: widget.statistics[index].y,
        percentageValue: widget.workPercentage[index],
        metric: widget.metric,
        barColor: Theme.of(context).primaryColor,
        lineColor: Colors.grey,
        needPercent: _showWorkPercentage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final labelInterval = ChartCalculations.calculateLabelInterval(
            constraints.maxWidth,
            widget.statistics.length,
          );

          final maxY = ChartCalculations.calculateMaxY(
            widget.statistics,
            widget.metric,
          );

          final interval = widget.metric == StatisticsMetric.count
              ? math.max((maxY / 5).ceilToDouble(), 1.0)
              : math.max(maxY / 5, 0.1);

          final barWidth = ChartCalculations.calculateBarWidth(
            constraints.maxWidth,
            widget.statistics.length,
          );

          final interColumnWidth = ChartCalculations.calculateInterColumnWidth(
            constraints.maxWidth,
            widget.statistics.length,
            leftTitleSize,
          );

          return Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MouseRegion(
                onHover: _handleMouseHover(constraints),
                onExit: (_) {
                  setState(() => _tooltipIndex = null);
                },
                child: Stack(
                  children: [
                    BarChartWidget(
                      statistics: widget.statistics,
                      metric: widget.metric,
                      maxY: maxY,
                      barWidth: barWidth,
                      leftTitleSize: leftTitleSize,
                      leftAxisTitleSize: leftAxisTitleSize,
                      bottomTitleSize: bottomTitleSize,
                      labelInterval: labelInterval,
                      interval: interval,
                      tooltipIndex: _tooltipIndex,
                      theme: Theme.of(context),
                    ),
                    if (_showWorkPercentage)
                      LineChartWidget(
                        workPercentage: widget.workPercentage,
                        dataLength: widget.statistics.length,
                        leftTitleSize: leftTitleSize,
                        leftAxisTitleSize: leftAxisTitleSize,
                        bottomTitleSize: bottomTitleSize,
                        interColumnWidth: interColumnWidth,
                        tooltipIndex: _tooltipIndex,
                      ),
                    if (_tooltipIndex != null)
                      _buildTooltip(_tooltipIndex!, _tooltipPosition!, constraints),
                    _buildPercentageSwitch(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPercentageSwitch() {
    return Positioned(
      top: 0,
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: _showWorkPercentage,
            onChanged: (value) {
              setState(() => _showWorkPercentage = value);
            },
          ),
          const Text(
            'Показать % работы',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  void Function(PointerHoverEvent) _handleMouseHover(BoxConstraints constraints) {
    return (event) {
      final chartWidth = constraints.maxWidth - leftTitleSize - 32;
      final x = event.localPosition.dx - leftTitleSize - 16;

      if (x >= 0 && x <= chartWidth) {
        final columnWidth = chartWidth / (widget.statistics.length + 2);
        final index = (x / columnWidth).floor();

        if (index != _tooltipIndex && index < widget.statistics.length) {
          setState(() {
            _tooltipIndex = index;
            _tooltipPosition = event.localPosition;
          });
        }
      } else {
        setState(() => _tooltipIndex = null);
      }
    };
  }
}