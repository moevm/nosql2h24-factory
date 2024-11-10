
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HoverColorDecoration extends StatelessWidget {
  final bool isHovering;
  final Color color;
  final Widget child;
  final double blurRadiusStart;

  const HoverColorDecoration({
    super.key,
    required this.isHovering,
    required this.color,
    required this.child,
    this.blurRadiusStart = 4,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDarkMode ? [
          BoxShadow(
            color: color.withOpacity(isHovering ? 0.5 : 0.2),
            blurRadius: isHovering ? 8 : blurRadiusStart,
            spreadRadius: isHovering ? 2 : 0,
          ),
        ] : null,
      ),
      child: child,
    );
  }
}