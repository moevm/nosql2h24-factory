import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/entities/chart_point.dart';

class ColorService {
  List<Color> generateColors(List<ChartPoint> points, double? threshold) {
    return points.map((point) {
      if(threshold == null) return CupertinoColors.activeBlue;
      if (point.y > threshold * 1.2) {
        return Colors.red;
      } else if (point.y > threshold) {
        return Color.lerp(
          Colors.orange,
          Colors.red,
          (point.y / threshold - 1).clamp(0, 1),
        )!;
      } else {
        return CupertinoColors.activeBlue;
      }
    }).toList();
  }
}