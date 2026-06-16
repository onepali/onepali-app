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
  const FlipCardView({super.key, required this.content});

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
    final size = MediaQuery.of(context).size;
    final isMobile = PlatformUtility.isMobile(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 8.0 : 0),
            child: SafeArea(
              child: GridView(
                padding: EdgeInsets.all(isMobile ? 24 : size.width * 0.1),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: isMobile
                      ? size.width * 0.01
                      : size.width * 0.05,
                  crossAxisSpacing: isMobile
                      ? size.width * 0.01
                      : size.width * 0.05,
                  childAspectRatio: isMobile ? 1.5 : 1.0,
                ),
                children: widget.content.items
                    .map(
                      (e) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              print('playing audio');
                              final c =
                                  _controllers[widget.content.items.indexOf(e)];
                              c.flipcard();
                              if (!c.state!.isFront) {
                                await _audioPlayerService.playAsset(
                                  Assets.cardFlip,
                                );
                                await Future.delayed(
                                  const Duration(milliseconds: 500),
                                );
                                if (e.audioItem != null) {
                                  await _audioPlayerService.play(e.audioItem!);
                                }
                              }
                            },
                            child: FlipCard(
                              rotateSide: RotateSide.bottom,
                              animationDuration: Duration(milliseconds: 500),
                              onTapFlipping: false,
                              axis:
                                  FlipAxis.values[_random.nextInt(
                                    FlipAxis.values.length,
                                  )],
                              controller:
                                  _controllers[widget.content.items.indexOf(e)],
                              frontWidget: Transform.rotate(
                                angle: 0.15,
                                child: Container(
                                  height: isMobile ? 100 : 200,
                                  width: isMobile ? 100 : 200,
                                  decoration: BoxDecoration(
                                    color: colorFromHex(e.bgColor),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                              backWidget: Container(
                                height: isMobile ? 100 : 200,
                                width: isMobile ? 100 : 200,
                                decoration: BoxDecoration(
                                  color: colorFromHex(e.bgColor),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: CustomCachedImage(imageUrl: e.image),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            e.nameNp,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppConstants.kMuktaFont,
                                  fontSize: 40,
                                ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
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
        CenterRightAlignedForwardButton(
          onTap: () {
            context.read<LessonBloc>().add(LessonEvent.nextContent());
          },
        ),
      ],
    );
  }
}
