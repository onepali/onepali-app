import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/balloon_fill_bloc/balloon_fill_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class BalloonFillView extends StatefulWidget {
  final BalloonFillLessonContent content;

  const BalloonFillView({super.key, required this.content});

  @override
  State<BalloonFillView> createState() => _BalloonFillViewState();
}

class _BalloonFillViewState extends State<BalloonFillView> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) =>
          BalloonFillBloc()..add(BalloonFillEvent.started(widget.content)),
      child: Stack(
        children: [
          Positioned.fill(
            child: isMobile
                ? MobileView()
                : GridView.builder(
                    itemCount: widget.content.items.length,
                    padding: EdgeInsets.all(size.width * 0.12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 48,
                      crossAxisSpacing: 48,
                    ),
                    itemBuilder: (context, index) {
                      final item = widget.content.items[index];
                      return BlocBuilder<BalloonFillBloc, BalloonFillState>(
                        builder: (context, state) {
                          final isFillingNow = state.fillingIndex == index;

                          return FillBalloon(
                            balloonImage: item.image,
                            nameNp: item.nameNp,
                            fillColorHex: item.bgColor ?? '#FF0000',
                            isFilled: state.filledIndexes.contains(index),
                            isFillingNow: isFillingNow,
                            onTap: state.isLocked
                                ? null
                                : () {
                                    if (state.filledIndexes.contains(index)) {
                                      context.read<BalloonFillBloc>().add(
                                        BalloonFillEvent.filledBalloonTapped(
                                          index,
                                        ),
                                      );
                                    }
                                    context.read<BalloonFillBloc>().add(
                                      BalloonFillEvent.balloonTapped(index),
                                    );
                                  },
                            onFillComplete: isFillingNow
                                ? () => context.read<BalloonFillBloc>().add(
                                    const BalloonFillEvent.fillAnimationCompleted(),
                                  )
                                : null,
                          );
                        },
                      );
                    },
                  ),
          ),
          ColorLabel(size: size),
          Positioned.fill(
            child: IgnorePointer(
              child: BackgroundImage(
                bgImageMb: widget.content.bgImage,
                bgImageTb: widget.content.bgImageTb,
              ),
            ),
          ),
          TopRightPositionedCloseButton(onTap: () => Navigator.pop(context)),
          BlocBuilder<BalloonFillBloc, BalloonFillState>(
            builder: (context, state) {
              final isAllFilled =
                  state.filledIndexes.length == widget.content.items.length;
              return isAllFilled
                  ? CenterRightAlignedForwardButton(
                      onTap: () => context.read<LessonBloc>().add(
                        LessonEvent.nextContent(),
                      ),
                    )
                  : Positioned(child: Container());
            },
          ),
          BlocBuilder<BalloonFillBloc, BalloonFillState>(
            builder: (context, state) {
              final isAllFilled =
                  state.filledIndexes.length == widget.content.items.length;
              return isAllFilled
                  ? CenterLeftAlignedBackButton(
                      onTap: () => context.read<LessonBloc>().add(
                        LessonEvent.previousContent(),
                      ),
                    )
                  : Positioned(child: Container());
            },
          ),
        ],
      ),
    );
  }
}

class ColorLabel extends StatelessWidget {
  const ColorLabel({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return Positioned(
      top: isMobile ? size.height * 0.1 : 32,
      left: 0,
      right: 0,
      child: BlocBuilder<BalloonFillBloc, BalloonFillState>(
        builder: (context, state) {
          final isVisible = state.colorLabelNp != null;

          return IgnorePointer(
            child: Center(
              child: AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0,
                duration: 300.ms,
                child: AnimatedScale(
                  scale: isVisible ? 1.0 : 1.3,
                  duration: 300.ms,
                  curve: Curves.easeIn,
                  child: state.colorLabelNp != null
                      ? CorrectNameDisplay(
                          nameNp: state.colorLabelNp ?? '',
                          nameEn: '',
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FillBalloon extends StatelessWidget {
  const FillBalloon({
    super.key,
    required this.balloonImage,
    required this.fillColorHex,
    required this.isFilled,
    required this.isFillingNow,
    required this.onTap,
    required this.onFillComplete,
    required this.nameNp,
  });

  final String balloonImage;
  final String fillColorHex;
  final bool isFilled;
  final bool isFillingNow;
  final VoidCallback? onTap;
  final VoidCallback? onFillComplete;
  final String nameNp;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CachedNetworkImage(
            imageUrl: balloonImage,
            colorBlendMode: BlendMode.srcIn,
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: isFilled || isFillingNow ? 1 : 0),
            duration: 800.ms,
            curve: Curves.easeInOut,
            onEnd: isFillingNow ? onFillComplete : null,
            builder: (context, value, child) {
              return ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: value,
                  child: child,
                ),
              );
            },
            child:
                CachedNetworkImage(
                      imageUrl: balloonImage,
                      color: colorFromHex(fillColorHex),
                      colorBlendMode: BlendMode.srcIn,
                    )
                    .animate(key: ValueKey('shimmer_$isFilled'))
                    .shimmer(
                      delay: 100.ms,
                      duration: 800.ms,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
          ),
          if (isFilled)
            Center(
              child: IgnorePointer(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 12 : 16,
                    vertical: 4,
                  ),

                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.kWhite,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    nameNp,
                    textAlign: TextAlign.center,
                    style: isMobile
                        ? Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontFamily: AppConstants.kMuktaFont,
                            fontWeight: FontWeight.bold,
                          )
                        : Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontFamily: AppConstants.kMuktaFont,
                            fontWeight: FontWeight.bold,
                            fontSize: 48,
                          ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocBuilder<BalloonFillBloc, BalloonFillState>(
      builder: (context, state) {
        return Center(
          child: Wrap(
            children:
                state.content?.items.asMap().entries.map((entry) {
                  final item = entry.value;
                  final isFillingNow = state.fillingIndex == entry.key;

                  return SizedBox(
                    width: size.width / state.content!.items.length - 32,
                    height: size.width / state.content!.items.length - 32,
                    child: FillBalloon(
                      balloonImage: item.image,
                      nameNp: item.nameNp,
                      fillColorHex: item.bgColor ?? '#FF0000',
                      isFilled: state.filledIndexes.contains(entry.key),
                      isFillingNow: state.fillingIndex == entry.key,
                      onTap: state.isLocked
                          ? null
                          : () => context.read<BalloonFillBloc>().add(
                              BalloonFillEvent.balloonTapped(entry.key),
                            ),
                      onFillComplete: isFillingNow
                          ? () => context.read<BalloonFillBloc>().add(
                              const BalloonFillEvent.fillAnimationCompleted(),
                            )
                          : null,
                    ),
                  );
                }).toList() ??
                [],
          ),
        );
      },
    );
  }
}
