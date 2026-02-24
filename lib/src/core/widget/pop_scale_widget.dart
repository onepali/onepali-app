import 'package:flutter/material.dart';

class PopScaleOnTap extends StatefulWidget {
  final Widget child;
  final double maxScale;
  final Duration duration;
  final VoidCallback? onTap;

  const PopScaleOnTap({
    super.key,
    required this.child,
    this.maxScale = 1.2,
    this.duration = const Duration(milliseconds: 180),
    this.onTap,
  });

  @override
  State<PopScaleOnTap> createState() => _PopScaleOnTapState();
}

class _PopScaleOnTapState extends State<PopScaleOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: widget.duration);

    _scale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: widget.maxScale),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(begin: widget.maxScale, end: 1.0),
        weight: 40,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  void _pop() {
    if (!_controller.isAnimating) {
      _controller.forward(from: 0);
      if (widget.onTap != null) {
        widget.onTap!();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap == null ? null : _pop,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(scale: _scale.value, child: child);
        },
        child: widget.child,
      ),
    );
  }
}
