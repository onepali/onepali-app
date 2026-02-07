import 'package:flutter/material.dart';

class ShrinkOnTap extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTapComplete;

  const ShrinkOnTap({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 250),
    this.onTapComplete,
  });

  @override
  State<ShrinkOnTap> createState() => _ShrinkOnTapState();
}

class _ShrinkOnTapState extends State<ShrinkOnTap>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _isGone = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scale = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInBack),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isGone = true);
        widget.onTapComplete?.call();
      }
    });
  }

  void _shrink() {
    if (!_controller.isAnimating && !_isGone) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isGone) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _shrink,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
