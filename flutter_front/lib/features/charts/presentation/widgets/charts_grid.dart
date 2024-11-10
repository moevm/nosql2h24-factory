import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:reorderables/reorderables.dart';
import '../../../../shared/data/models/minichart_data_model.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../shared/data/models/minichart_data_model.dart';
import '../../../../shared/presentation/resizeable_card.dart';

class ChartsGrid extends StatefulWidget {
  final MiniChartDataModel chartData;

  const ChartsGrid({
    super.key,
    required this.chartData,
  });

  @override
  State<ChartsGrid> createState() => _ChartsGridState();
}

class _ChartsGridState extends State<ChartsGrid> {
  List<Color> _getThemeColors(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.dark) {
      return [
        const Color(0xFF2196F3),
        const Color(0xFF4CAF50),
        const Color(0xFFE91E63),
        const Color(0xFFFFA726),
        const Color(0xFF9C27B0),
        const Color(0xFF00BCD4),
        const Color(0xFFFF5722),
        const Color(0xFF3F51B5),
      ];
    }

    return [
      const Color(0xFF1E88E5),
      const Color(0xFF43A047),
      const Color(0xFFD81B60),
      const Color(0xFFFC8E34),
      const Color(0xFF8E24AA),
      const Color(0xFF00ACC1),
      const Color(0xFFFF7043),
      const Color(0xFF5E35B1),
    ];
  }

  final Map<String, Size> _cardSizes = {};

  @override
  Widget build(BuildContext context) {
    Map<String, Map<String, Map<String, List<ChartDataPoint>?>>> parameterGroups = {};
    final size = MediaQuery.of(context).size;
    final initialWidth = size.width / 2 - 100;
    final initialHeight = size.height / 2 - 100;

    widget.chartData.data.forEach((equipKey, equipValue) {
      equipValue.forEach((paramKey, paramValue) {
        parameterGroups[paramKey] ??= {};
        parameterGroups[paramKey]![equipKey] = paramValue;
      });
    });

    return LayoutBuilder(
        builder: (context, constraints) {
          return ReorderableWrap(
            spacing: 8,
            runSpacing: 8,
            padding: const EdgeInsets.all(8),
            minMainAxisCount: 1, // Минимум 1 элемент в строке
            maxMainAxisCount: (constraints.maxWidth / 200).floor(), // Максимальное количество элементов в строке
            onReorder: (oldIndex, newIndex) {
              setState(() {
                // Реализация перемещения, если необходимо
              });
            },
            children: List.generate(
              parameterGroups.length,
                  (index) {
                String paramKey = parameterGroups.keys.elementAt(index);
                _cardSizes[paramKey] ??= Size(initialWidth, initialHeight);

                return ResizeableCard(
                  key: ValueKey(paramKey),
                  initialWidth: _cardSizes[paramKey]!.width,
                  initialHeight: _cardSizes[paramKey]!.height,
                  onSizeChanged: (newSize) {
                    setState(() {
                      _cardSizes[paramKey] = newSize;
                    });
                  },
                  maxWidth: constraints.maxWidth - 16, // Максимальная ширина с учетом отступов
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        paramKey,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: LineChart(
                          _createChartData(context, parameterGroups[paramKey]!),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }
    );
  }

  LineChartData _createChartData(BuildContext context, Map<String, Map<String, List<ChartDataPoint>?>> parameterData) {
    List<LineChartBarData> lines = [];
    int equipmentIndex = 0;
    final baseColors = _getThemeColors(context);

    parameterData.forEach((equipKey, subParams) {
      Color baseColor = baseColors[equipmentIndex % baseColors.length];
      int subParamIndex = 0;
      int totalSubParams = subParams.length;

      subParams.forEach((subParamKey, dataPoints) {
        if (dataPoints != null && dataPoints.isNotEmpty) {
          Color lineColor;
          if (totalSubParams > 1) {
            final hslColor = HSLColor.fromColor(baseColor);
            double saturation = (hslColor.saturation - 0.3 * subParamIndex).clamp(0.3, 1.0);
            double lightness = (hslColor.lightness + 0.1 * subParamIndex).clamp(0.3, 0.7);

            lineColor = hslColor
                .withSaturation(saturation)
                .withLightness(lightness)
                .toColor();
          } else {
            lineColor = baseColor;
          }

          lines.add(
            LineChartBarData(
              spots: dataPoints.asMap().entries.map((entry) {
                return FlSpot(
                  entry.key.toDouble(),
                  entry.value.value,
                );
              }).toList(),
              color: lineColor,
              dotData: const FlDotData(show: false),
              isCurved: true,
              barWidth: 2,
            ),
          );
          subParamIndex++;
        }
      });
      equipmentIndex++;
    });

    return LineChartData(
      gridData: const FlGridData(show: true),
      titlesData: const FlTitlesData(
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: lines,
    );
  }
}