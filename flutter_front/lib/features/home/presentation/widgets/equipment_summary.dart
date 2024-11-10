// equipment_summary.dart
import 'package:flutter/material.dart';

enum TemperatureUnit { celsius, fahrenheit, kelvin }

class EquipmentSummary extends StatefulWidget {
  final int workingEquipmentCount;
  final double? maxTemperature;
  final EdgeInsets padding;

  const EquipmentSummary({
    super.key,
    required this.workingEquipmentCount,
    this.maxTemperature,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  _EquipmentSummaryState createState() => _EquipmentSummaryState();
}

class _EquipmentSummaryState extends State<EquipmentSummary> {
  TemperatureUnit _currentUnit = TemperatureUnit.celsius;

  void _cycleTemperatureUnit() {
    setState(() {
      switch (_currentUnit) {
        case TemperatureUnit.celsius:
          _currentUnit = TemperatureUnit.fahrenheit;
          break;
        case TemperatureUnit.fahrenheit:
          _currentUnit = TemperatureUnit.kelvin;
          break;
        case TemperatureUnit.kelvin:
          _currentUnit = TemperatureUnit.celsius;
          break;
      }
    });
  }

  String _formatTemperature(double? temperature) {
    if (temperature == null) return 'Н/Д';
    switch (_currentUnit) {
      case TemperatureUnit.celsius:
        return '${temperature.toStringAsFixed(1)}°C';
      case TemperatureUnit.fahrenheit:
        return '${(temperature * 9 / 5 + 32).toStringAsFixed(1)}°F';
      case TemperatureUnit.kelvin:
        return '${(temperature + 273.15).toStringAsFixed(1)}K';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 100),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _getSummaryText(widget.workingEquipmentCount.toString(), 'Работает'),
          ),
          const SizedBox(width: 100),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _cycleTemperatureUnit,
              child: _getSummaryText(_formatTemperature(widget.maxTemperature), 'Макс. температура'),
            ),
          ),
          const SizedBox(width: 100),
        ],
      ),
    );
  }

  Widget _getSummaryText(String value, String title){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}