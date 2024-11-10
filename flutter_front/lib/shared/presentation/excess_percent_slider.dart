import 'package:flutter/material.dart';

class ExcessPercentSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const ExcessPercentSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  _ExcessPercentSliderState createState() => _ExcessPercentSliderState();
}

class _ExcessPercentSliderState extends State<ExcessPercentSlider> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Превышение: ${_currentValue.toStringAsFixed(0)}%',
        ),
        Slider(
          value: _currentValue,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() {
              _currentValue = value;
            });
          },
          onChangeEnd: widget.onChanged,
        ),
      ],
    );
  }
}