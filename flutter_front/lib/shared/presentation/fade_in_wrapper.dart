import 'package:flutter/material.dart';

class FadeInWrapper<T extends Widget> extends StatefulWidget {
  final T child;
  final Duration duration;
  final Curve curve;
  final int delayIndex;
  final Duration delayDuration;
  final bool playOnce;

  const FadeInWrapper({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeIn,
    this.delayIndex = 0,
    this.delayDuration = const Duration(milliseconds: 100),
    this.playOnce = false,
  });

  @override
  _FadeInWrapperState<T> createState() => _FadeInWrapperState<T>();
}

class _FadeInWrapperState<T extends Widget> extends State<FadeInWrapper<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasPlayed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    );

    if (!_hasPlayed || !widget.playOnce) {
      Future.delayed(widget.delayDuration * widget.delayIndex, () {
        if (mounted) {
          _controller.forward();
          _hasPlayed = true;
        }
      });
    }
  }

  @override
  void didUpdateWidget(FadeInWrapper<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.playOnce) {
      _controller.reset();
      Future.delayed(widget.delayDuration * widget.delayIndex, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasPlayed && widget.playOnce) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}