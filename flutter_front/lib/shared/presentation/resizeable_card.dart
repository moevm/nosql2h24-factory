// resizeable_card.dart
import 'package:flutter/material.dart';

class ResizeableCard extends StatefulWidget {
  final Widget child;
  final double initialWidth;
  final double initialHeight;
  final double? maxWidth;
  final void Function(Size)? onSizeChanged;

  const ResizeableCard({
    super.key,
    required this.child,
    required this.initialWidth,
    required this.initialHeight,
    this.maxWidth,
    this.onSizeChanged,
  });

  @override
  State<ResizeableCard> createState() => _ResizeableCardState();
}

class _ResizeableCardState extends State<ResizeableCard> {
  late double height;
  late double width;
  final resizeHandleSize = 32.0; // Увеличенная область для resize

  @override
  void initState() {
    super.initState();
    height = widget.initialHeight;
    width = widget.initialWidth;
  }

  @override
  void didUpdateWidget(ResizeableCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialWidth != widget.initialWidth ||
        oldWidget.initialHeight != widget.initialHeight) {
      height = widget.initialHeight;
      width = widget.initialWidth;
    }
  }

  void _updateSize(double newWidth, double newHeight) {
    final maxWidth = widget.maxWidth ?? 800.0;
    setState(() {
      width = newWidth.clamp(200.0, maxWidth);
      height = newHeight.clamp(200.0, 800.0);
      widget.onSizeChanged?.call(Size(width, height));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: height,
              width: width,
              child: widget.child,
            ),
          ),
          Positioned(
            right: -resizeHandleSize / 2,
            bottom: -resizeHandleSize / 2,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeDownRight,
              child: GestureDetector(
                onPanUpdate: (details) {
                  _updateSize(
                    width + details.delta.dx,
                    height + details.delta.dy,
                  );
                },
                child: Container(
                  width: resizeHandleSize,
                  height: resizeHandleSize,
                  color: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}