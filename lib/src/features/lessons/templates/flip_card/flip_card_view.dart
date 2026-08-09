import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
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
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.content.items.length,
      (_) => FlipCardController(),
    );
  }

  @override
  void dispose() {
    _audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Stack(
      children: [
        LessonContentFrame(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.all(isMobile ? 8.0 : 0),
              child: LayoutBuilder(
                builder: (context, gridConstraints) {
                  const crossAxisCount = 3;
                  final itemCount = widget.content.items.length;
                  final rowCount = max(1, (itemCount / crossAxisCount).ceil());
                  final gridPadding = isMobile
                      ? 24.0
                      : gridConstraints.maxWidth * 0.1;
                  final crossSpacing = isMobile
                      ? gridConstraints.maxWidth * 0.01
                      : gridConstraints.maxWidth * 0.05;
                  final mainSpacing = crossSpacing;
                  final tileWidth =
                      (gridConstraints.maxWidth -
                          (gridPadding * 2) -
                          (crossSpacing * (crossAxisCount - 1))) /
                      crossAxisCount;
                  final tileHeight =
                      (gridConstraints.maxHeight -
                          (gridPadding * 2) -
                          (mainSpacing * (rowCount - 1))) /
                      rowCount;
                  final labelGap = isMobile ? 8.0 : 12.0;
                  final labelHeight = isMobile ? 44.0 : 56.0;
                  final maxCardSize = isMobile ? 100.0 : 200.0;
                  final cardSize = min(
                    maxCardSize,
                    min(tileWidth, tileHeight - labelGap - labelHeight),
                  ).clamp(0.0, maxCardSize);

                  return GridView(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(gridPadding),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: mainSpacing,
                      crossAxisSpacing: crossSpacing,
                      childAspectRatio: tileWidth / max(1.0, tileHeight),
                    ),
                    children: widget.content.items.asMap().entries.map((entry) {
                      return _FlipCardTile(
                        item: entry.value,
                        controller: _controllers[entry.key],
                        cardSize: cardSize,
                        labelHeight: labelHeight,
                        labelGap: labelGap,
                        axis: FlipAxis
                            .values[_random.nextInt(FlipAxis.values.length)],
                        onCardRevealed: () async {
                          await _audioPlayerService.playAsset(Assets.cardFlip);
                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );
                          if (!mounted ||
                              _controllers[entry.key].state?.isFront != false) {
                            return;
                          }
                          final audioItem = entry.value.audioItem;
                          if (audioItem != null && audioItem.isNotEmpty) {
                            await _audioPlayerService.play(audioItem);
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            );
          },
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

class _FlipCardTile extends StatelessWidget {
  const _FlipCardTile({
    required this.item,
    required this.controller,
    required this.cardSize,
    required this.labelHeight,
    required this.labelGap,
    required this.axis,
    required this.onCardRevealed,
  });

  final Item item;
  final FlipCardController controller;
  final double cardSize;
  final double labelHeight;
  final double labelGap;
  final FlipAxis axis;
  final Future<void> Function() onCardRevealed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            controller.flipcard();
            if (!controller.state!.isFront) {
              await onCardRevealed();
            }
          },
          child: FlipCard(
            rotateSide: RotateSide.bottom,
            animationDuration: Duration(milliseconds: 500),
            onTapFlipping: false,
            axis: axis,
            controller: controller,
            frontWidget: Transform.rotate(
              angle: 0.15,
              child: Container(
                height: cardSize,
                width: cardSize,
                decoration: BoxDecoration(
                  color: colorFromHex(item.bgColor),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            backWidget: Container(
              height: cardSize,
              width: cardSize,
              decoration: BoxDecoration(
                color: colorFromHex(item.bgColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomCachedImage(imageUrl: item.image),
            ),
          ),
        ),
        SizedBox(height: labelGap),
        SizedBox(
          height: labelHeight,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.nameNp,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: AppConstants.kMuktaFont,
                fontSize: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
