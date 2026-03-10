import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class FlipCardView extends StatefulWidget {
  final FlipCardLessonContent content;
  final VoidCallback onNext;
  const FlipCardView({super.key, required this.content, required this.onNext});

  @override
  State<FlipCardView> createState() => _FlipCardViewState();
}

class _FlipCardViewState extends State<FlipCardView> {
  List<FlipCardController> _controllers = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.content.items.length,
      (_) => FlipCardController(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _preloadImages();
    });
  }

  Future<void> _preloadImages() async {
    for (final item in widget.content.items) {
      precacheImage(CachedNetworkImageProvider(item.image), context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(
          child: GridView(
            padding: EdgeInsets.all(size.width * 0.1),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: size.width * 0.05,
              crossAxisSpacing: size.width * 0.05,
            ),
            children: widget.content.items
                .map(
                  (e) => Column(
                    children: [
                      FlipCard(
                        rotateSide: RotateSide.bottom,
                        animationDuration: Duration(milliseconds: 500),
                        onTapFlipping: true,
                        axis: FlipAxis
                            .values[_random.nextInt(FlipAxis.values.length)],
                        controller:
                            _controllers[widget.content.items.indexOf(e)],
                        frontWidget: Transform.rotate(
                          angle: 0.15,
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: colorFromHex(e.bgColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        backWidget: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: colorFromHex(e.bgColor),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.sports_soccer,
                                color: Colors.white,
                                size: 60,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        e.nameNp,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        TopRightPositionedCloseButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
        CenterLeftAlignedBackButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.previousContent());
          },
        ),
        CenterRightAlignedForwardButton(onTap: widget.onNext),
      ],
    );
  }
}
