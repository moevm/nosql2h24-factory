import 'package:flutter/material.dart';

class AnomalyWarningsControl extends StatelessWidget {
  final bool showWarnings;
  final bool showAnomalies;
  final Function(bool) onWarningsChanged;
  final Function(bool) onAnomaliesChanged;

  const AnomalyWarningsControl({
    super.key,
    required this.showWarnings,
    required this.showAnomalies,
    required this.onWarningsChanged,
    required this.onAnomaliesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        SizedBox(
          width: 180,
          child: CheckboxListTile(
            dense: true,
            title: const Text('Превышения'),
            value: showWarnings,
            onChanged: (value) => onWarningsChanged(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 160,
          child: CheckboxListTile(
            dense: true,
            title: const Text('Аномалии'),
            value: showAnomalies,
            onChanged: (value) => onAnomaliesChanged(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ),
      ],
    );
  }
}
