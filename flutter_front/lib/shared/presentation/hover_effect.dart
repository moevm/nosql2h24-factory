import 'package:flutter/material.dart';

class HoverScaleEffect extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;

  const HoverScaleEffect({
    super.key,
    required this.child,
    this.scale = 1.3,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeInOut,
  });

  @override
  _HoverScaleEffectState createState() => _HoverScaleEffectState();
}

class _HoverScaleEffectState extends State<HoverScaleEffect> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: widget.duration,
        curve: widget.curve,
        transform: Matrix4.identity()
          ..translate(-_getTranslation(), -_getTranslation())
          ..scale(_isHovered ? widget.scale : 1.0)
          ..translate(_getTranslation(), _getTranslation()),
        child: widget.child,
      ),
    );
  }

  double _getTranslation() {
    final scale = _isHovered ? widget.scale : 1.0;
    return -50.0 * (scale - 1.0);
  }
}