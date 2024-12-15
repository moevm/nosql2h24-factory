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

    DateTime? minTime;
    DateTime? maxTime;

    // Получаем размер виджета
    final size = MediaQuery.of(context).size;
    final chartWidth = _cardSizes.values.first.width - 40; // Примерная ширина графика

    parameterData.forEach((_, subParams) {
      subParams.forEach((_, dataPoints) {
        if (dataPoints != null && dataPoints.isNotEmpty) {
          final times = dataPoints.map((point) => point.time);
          final currentMin = times.reduce((a, b) => a.isBefore(b) ? a : b);
          final currentMax = times.reduce((a, b) => a.isAfter(b) ? a : b);

          minTime = minTime == null || currentMin.isBefore(minTime!) ? currentMin : minTime;
          maxTime = maxTime == null || currentMax.isAfter(maxTime!) ? currentMax : maxTime;
        }
      });
    });

    if (minTime == null || maxTime == null) {
      return LineChartData(lineBarsData: []);
    }

    // Вычисляем оптимальный интервал меток в зависимости от ширины
    double calculateInterval(double availableWidth) {
      final totalSeconds = maxTime!.difference(minTime!).inSeconds.toDouble();
      final pixelsPerLabel = 80.0; // Минимальное количество пикселей между метками
      final maxLabels = (availableWidth / pixelsPerLabel).floor();
      final rawInterval = totalSeconds / maxLabels;

      // Округляем до ближайшего удобного интервала
      if (rawInterval <= 60) return 60; // 1 минута
      if (rawInterval <= 300) return 300; // 5 минут
      if (rawInterval <= 600) return 600; // 10 минут
      if (rawInterval <= 1800) return 1800; // 30 минут
      if (rawInterval <= 3600) return 3600; // 1 час
      if (rawInterval <= 7200) return 7200; // 2 часа
      if (rawInterval <= 14400) return 14400; // 4 часа
      return 21600; // 6 часов
    }

    final interval = calculateInterval(chartWidth);

    // Форматирование времени в зависимости от интервала
    String formatTime(DateTime time, double interval) {
      if (interval <= 300) { // До 5 минут
        return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
      } else if (interval <= 3600) { // До часа
        return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
      } else if (interval <= 86400) { // До суток
        return '${time.hour}:00';
      } else { // Больше суток
        return '${time.day}/${time.month} ${time.hour}:00';
      }
    }

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
            lineColor = hslColor.withSaturation(saturation).withLightness(lightness).toColor();
          } else {
            lineColor = baseColor;
          }

          lines.add(
            LineChartBarData(
              spots: dataPoints.map((point) {
                final double xValue = point.time.difference(minTime!).inSeconds.toDouble();
                return FlSpot(xValue, point.value);
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
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 32,
            getTitlesWidget: (value, meta) {
              final DateTime time = minTime!.add(Duration(seconds: value.toInt()));

              // Показываем метку только если она попадает на интервал
              if (value % interval != 0) {
                return const SizedBox.shrink();
              }

              return Transform.rotate(
                angle: -0.5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    formatTime(time, interval),
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              );
            },
            interval: interval,
          ),
        ),
      ),
      borderData: FlBorderData(show: true),
      lineBarsData: lines,
    );
  }
}