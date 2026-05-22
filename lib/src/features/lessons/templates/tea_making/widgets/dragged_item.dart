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
  String? _currentItem;
  String? _previousItem;

  @override
  void initState() {
    super.initState();
    _currentItem = widget.draggedItem;
  }

  @override
  void didUpdateWidget(DraggedItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.draggedItem != widget.draggedItem) {
      _previousItem = _currentItem;
      _currentItem = widget.draggedItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SvgPicture.network(
      widget.draggedItem,
      key: ValueKey<String>(widget.draggedItem),
      height: size.height * 0.50,
      width: size.width * 0.7,
      fit: BoxFit.cover,
    );
  }
}
