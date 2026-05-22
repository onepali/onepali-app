import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DraggedItem extends StatelessWidget {
  const DraggedItem({
    super.key,
    required this.draggedItem,
    required this.index,
  });
  final String draggedItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SvgPicture.network(
      draggedItem,
      key: ValueKey<String>(draggedItem),
      height: size.height * 0.50,
      width: size.width * 0.7,
      fit: BoxFit.cover,
    );
  }
}
