import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/templates/balloon_fill/balloon_fill_bloc/balloon_fill_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class BalloonFillView extends StatefulWidget {
  final BalloonFillLessonContent content;
  final VoidCallback onNext;

  const BalloonFillView({
    super.key,
    required this.content,
    required this.onNext,
  });

  @override
  State<BalloonFillView> createState() => _BalloonFillViewState();
}

class _BalloonFillViewState extends State<BalloonFillView>
    with AutoAdvanceMixin<BalloonFillView> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);

    return BlocProvider(
      create: (context) =>
          BalloonFillBloc()..add(BalloonFillEvent.started(widget.content)),
      child: BlocConsumer<BalloonFillBloc, BalloonFillState>(
        listenWhen: (previous, current) =>
            !_isReadyToAdvance(previous) && _isReadyToAdvance(current),
        listener: (context, state) {
          scheduleAutoAdvance(_autoAdvanceDelay, widget.onNext);
        },
        builder: (context, state) {
          final isReadyToAdvance = _isReadyToAdvance(state);
          return Stack(
            children: [
              LessonContentFrame(
                builder: (context, constraints) {
                  final frameSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  return isMobile
                      ? MobileView(availableSize: frameSize)
                      : Center(
                          child: SizedBox(
                            width: frameSize.width * 0.96,
                            child: GridView.builder(
                              itemCount: widget.content.items.length,
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 48,
                                    crossAxisSpacing: 48,
                                  ),
                              itemBuilder: (context, index) {
                                final item = widget.content.items[index];
                                return BlocBuilder<
                                  BalloonFillBloc,
                                  BalloonFillState
                                >(
                                  builder: (context, state) {
                                    final isFillingNow =
                                        state.fillingIndex == index;

                                    return FillBalloon(
                                      balloonImage: item.image,
                                      nameNp: item.nameNp,
                                      fillColorHex: item.bgColor ?? '#FF0000',
                                      isFilled: state.filledIndexes.contains(
                                        index,
                                      ),
                                      isFillingNow: isFillingNow,
                                      onTap: state.isLocked
                                          ? null
                                          : () {
                                              if (state.filledIndexes.contains(
                                                index,
                                              )) {
                                                context.read<BalloonFillBloc>().add(
                                                  BalloonFillEvent.filledBalloonTapped(
                                                    index,
                                                  ),
                                                );
                                                return;
                                              }

                                              context.read<BalloonFillBloc>().add(
                                                BalloonFillEvent.balloonTapped(
                                                  index,
                                                ),
                                              );
                                            },
                                      onFillComplete: isFillingNow
                                          ? () => context
                                                .read<BalloonFillBloc>()
                                                .add(
                                                  const BalloonFillEvent.fillAnimationCompleted(),
                                                )
                                          : null,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                },
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: BackgroundImage(
                    bgImageMb: widget.content.bgImage,
                    bgImageTb: widget.content.bgImageTb,
                  ),
                ),
              ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.pop(context),
              ),
              if (isReadyToAdvance)
                CenterRightAlignedForwardButton(onTap: widget.onNext),
              if (isReadyToAdvance)
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    LessonEvent.previousContent(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  bool _hasFilledAllBalloons(BalloonFillState state) {
    final itemCount = state.content?.items.length ?? 0;
    return itemCount > 0 && state.filledIndexes.length == itemCount;
  }

  bool _isReadyToAdvance(BalloonFillState state) {
    return _hasFilledAllBalloons(state) &&
        state.status == BalloonFillStatus.idle;
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
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: balloonImage,
              colorBlendMode: BlendMode.srcIn,
              fit: BoxFit.contain,
            ),
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
                      fit: BoxFit.contain,
                      width: double.infinity,
                      height: double.infinity,
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
  const MobileView({super.key, required this.availableSize});

  final Size availableSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BalloonFillBloc, BalloonFillState>(
      builder: (context, state) {
        final itemCount = state.content?.items.length ?? 0;
        final rowWidth = availableSize.width * 0.96;
        final itemSize = itemCount == 0 ? 0.0 : rowWidth / itemCount;
        return Center(
          child: SizedBox(
            width: rowWidth,
            child: Wrap(
              alignment: WrapAlignment.center,
              children:
                  state.content?.items.asMap().entries.map((entry) {
                    final item = entry.value;
                    final isFillingNow = state.fillingIndex == entry.key;

                    return SizedBox(
                      width: itemSize,
                      height: itemSize,
                      child: FillBalloon(
                        balloonImage: item.image,
                        nameNp: item.nameNp,
                        fillColorHex: item.bgColor ?? '#FF0000',
                        isFilled: state.filledIndexes.contains(entry.key),
                        isFillingNow: state.fillingIndex == entry.key,
                        onTap: state.isLocked
                            ? null
                            : () {
                                if (state.filledIndexes.contains(entry.key)) {
                                  context.read<BalloonFillBloc>().add(
                                    BalloonFillEvent.filledBalloonTapped(
                                      entry.key,
                                    ),
                                  );
                                  return;
                                }

                                context.read<BalloonFillBloc>().add(
                                  BalloonFillEvent.balloonTapped(entry.key),
                                );
                              },
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
          ),
        );
      },
    );
  }
}
