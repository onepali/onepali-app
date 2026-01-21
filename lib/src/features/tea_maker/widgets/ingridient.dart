import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Ingridient extends StatefulWidget {
  const Ingridient({
    super.key,
    required this.isSelected,
    required this.ingridient,
  });
  final String ingridient;
  final bool isSelected;
  @override
  State<Ingridient> createState() => _IngridientState();
}

class _IngridientState extends State<Ingridient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isSelected) {
      return SvgPicture.asset(widget.ingridient);
    }

    return ScaleTransition(
      scale: _animation,
      child: SvgPicture.asset(widget.ingridient),
    );
  }
}
