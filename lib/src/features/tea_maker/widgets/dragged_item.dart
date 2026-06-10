import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DraggedItem extends StatefulWidget {
  const DraggedItem({
    super.key,
    required this.draggedItem,
    required this.index,
  });
  final String draggedItem;
  final int index;
  @override
  State<DraggedItem> createState() => _DraggedItemState();
}

class _DraggedItemState extends State<DraggedItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(DraggedItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.draggedItem != widget.draggedItem) {
      _controller.reset();
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
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: SvgPicture.asset(
        widget.draggedItem,
        key: ValueKey<String>(widget.draggedItem),
        height: size.height * 0.50,
        width: size.width * 0.7,
        fit: BoxFit.cover,
      ),
    );
  }
}
