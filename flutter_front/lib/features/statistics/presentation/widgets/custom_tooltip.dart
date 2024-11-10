import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/types/formatDuration.dart';
import '../../data/models/statistics_model.dart';

class CustomTooltip extends StatelessWidget {
  final double barValue;
  final double percentageValue;
  final StatisticsMetric metric;
  final Color barColor;
  final Color lineColor;
  final bool needPercent;

  const CustomTooltip({super.key,
    required this.barValue,
    required this.percentageValue,
    required this.metric,
    required this.barColor,
    required this.lineColor,
    required this.needPercent,
  });

  String _getFormattedBarValue() {
    switch (metric) {
      case StatisticsMetric.avgDuration:
        return formatDuration(barValue);
      case StatisticsMetric.count:
        return barValue.toInt().toString();
      case StatisticsMetric.avgExcess:
        return '${barValue.toStringAsFixed(2)}%';
      default:
        return barValue.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: barColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '${metric.label}: ${_getFormattedBarValue()}',
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 2),
          if(needPercent) Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: lineColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Процент работы: ${percentageValue.toStringAsFixed(1)}%',
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}