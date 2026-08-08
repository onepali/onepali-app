import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/slide_up_to_match/match_bloc/match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class MatchGameScreen extends StatefulWidget {
  final SlideUpToMatchLessonContent content;
  final bool isLastContent;
  final VoidCallback onNext;
  final VoidCallback? onLessonCompleted;

  const MatchGameScreen({
    super.key,
    required this.content,
    required this.onNext,
    this.onLessonCompleted,
    this.isLastContent = false,
  });

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen>
    with AutoAdvanceMixin<MatchGameScreen> {
  static const _autoAdvanceDelay = Duration(seconds: 1);

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return BlocProvider(
      create: (context) => MatchBloc()..add(MatchEvent.started(widget.content)),
      child: BlocConsumer<MatchBloc, MatchState>(
        listenWhen: (previous, current) =>
            !previous.completionFeedbackReady &&
            current.completionFeedbackReady,
        listener: (context, state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scheduleAutoAdvance(_autoAdvanceDelay, () {
              if (widget.isLastContent) {
                widget.onLessonCompleted?.call();
                return;
              }
              widget.onNext();
            });
          });
        },
        builder: (context, state) {
          if (state.content == null) {
            return SizedBox.shrink();
          }
          return Stack(
            children: [
              LessonContentFrame(
                builder: (context, constraints) {
                  final frameSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final metrics = _MatchLayoutMetrics.fromFrame(
                    frameSize: frameSize,
                    isMobile: isMobile,
                    itemCount: state.content!.items.length,
                  );
                  return Column(
                    children: [
                      SizedBox(height: metrics.edgeSpacer),
                      //TOP ROW: Items & English Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: state.content!.items.map((item) {
                          return _TopItems(
                            image: item.image,
                            labelEn: item.nameEn,
                            labelNp: item.nameNp,
                            bgColor: colorFromHex(item.bgColor) ?? Colors.white,
                            isCorrect: item.isCorrect,
                            metrics: metrics,
                          );
                        }).toList(),
                      ),
                      Spacer(),
                      //BOTTOM ROW: Draggable Nepali Labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: state.nepaliWords.map((item) {
                          return _buildDraggableLabel(
                            item.word,
                            item.isMatched,
                            metrics,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: metrics.edgeSpacer),
                    ],
                  );
                },
              ),
              CenterLeftAlignedBackButton(
                onTap: () {
                  context.read<LessonBloc>().add(LessonEvent.previousContent());
                },
              ),
              if (state.isAnsweredAll && !widget.isLastContent)
                CenterRightAlignedForwardButton(onTap: widget.onNext),

              TopRightPositionedCloseButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper for the Draggable Nepali words at the bottom
  Widget _buildDraggableLabel(
    String text,
    bool isMatched,
    _MatchLayoutMetrics metrics,
  ) {
    return Draggable<String>(
      data: text,
      feedback: Material(
        color: Colors.transparent,
        child: _labelContainer(
          text,
          opacity: 0.7,
          isMatched: isMatched,
          metrics: metrics,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _labelContainer(text, isMatched: isMatched, metrics: metrics),
      ),
      child: _labelContainer(text, isMatched: isMatched, metrics: metrics),
    );
  }

  Widget _labelContainer(
    String text, {
    double opacity = 1.0,
    bool isMatched = false,
    required _MatchLayoutMetrics metrics,
  }) {
    if (isMatched) {
      return SizedBox(width: metrics.labelWidth, height: metrics.labelHeight);
    }
    return Container(
      width: metrics.labelWidth,
      height: metrics.labelHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
        vertical: metrics.labelVerticalPadding,
        horizontal: metrics.labelHorizontalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: isMatched
          ? SizedBox.shrink()
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.kWhite,
                  fontSize: metrics.labelFontSize,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppConstants.kMuktaFont,
                ),
              ),
            ),
    );
  }
}

class _MatchLayoutMetrics {
  const _MatchLayoutMetrics({
    required this.imageSize,
    required this.labelWidth,
    required this.labelHeight,
    required this.labelFontSize,
    required this.labelVerticalPadding,
    required this.labelHorizontalPadding,
    required this.itemLabelGap,
    required this.edgeSpacer,
  });

  final double imageSize;
  final double labelWidth;
  final double labelHeight;
  final double labelFontSize;
  final double labelVerticalPadding;
  final double labelHorizontalPadding;
  final double itemLabelGap;
  final double edgeSpacer;

  factory _MatchLayoutMetrics.fromFrame({
    required Size frameSize,
    required bool isMobile,
    required int itemCount,
  }) {
    final safeItemCount = max(1, itemCount);
    final laneWidth = frameSize.width / safeItemCount;
    final maxLabelWidth = isMobile ? 180.0 : 250.0;
    final labelWidth = min(
      maxLabelWidth,
      max(0.0, laneWidth - (isMobile ? 8.0 : 16.0)),
    );
    final labelFontSize = min(
      isMobile ? 24.0 : 44.0,
      max(16.0, labelWidth * 0.18),
    );
    final labelVerticalPadding = isMobile ? 8.0 : 12.0;
    final labelHorizontalPadding = min(
      isMobile ? 16.0 : 32.0,
      labelWidth * 0.12,
    );
    final labelHeight = (labelFontSize * 1.35) + (labelVerticalPadding * 2);
    final itemLabelGap = min(isMobile ? 16.0 : 24.0, frameSize.height * 0.04);
    final maxImageSize = isMobile ? 120.0 : 200.0;
    final imageSize = min(
      maxImageSize,
      min(labelWidth, frameSize.height * 0.32),
    );
    final topItemHeight = imageSize + itemLabelGap + labelHeight;
    final availableSpacerHeight = max(
      0.0,
      frameSize.height - topItemHeight - labelHeight,
    );
    final desiredEdgeSpacer = isMobile ? 60.0 : frameSize.height * 0.15;
    final edgeSpacer = min(desiredEdgeSpacer, availableSpacerHeight / 2);

    return _MatchLayoutMetrics(
      imageSize: imageSize,
      labelWidth: labelWidth,
      labelHeight: labelHeight,
      labelFontSize: labelFontSize,
      labelVerticalPadding: labelVerticalPadding,
      labelHorizontalPadding: labelHorizontalPadding,
      itemLabelGap: itemLabelGap,
      edgeSpacer: edgeSpacer,
    );
  }
}

class _TopItems extends StatelessWidget {
  const _TopItems({
    required this.image,
    required this.labelEn,
    required this.labelNp,
    required this.bgColor,
    required this.isCorrect,
    required this.metrics,
  });

  final String image;
  final String labelEn;
  final String labelNp;
  final Color bgColor;
  final bool isCorrect;
  final _MatchLayoutMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (details) {
        final isCorrect = details.data == labelNp;
        MetricsTrackingHelper.trackAnswerAttempt(
          context: context,
          isCorrect: isCorrect,
        );
        if (isCorrect) {
          context.read<MatchBloc>().add(MatchEvent.onAccept(labelNp));
        } else {
          context.read<MatchBloc>().add(const MatchEvent.onWrongAccept());
        }
      },
      builder: (context, candidateData, rejectedData) => Column(
        children: [
          SizedBox(
            width: metrics.imageSize,
            height: metrics.imageSize,
            child: CustomCachedImage(imageUrl: image, fit: BoxFit.cover),
          ),
          SizedBox(height: metrics.itemLabelGap),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(50),
              strokeWidth: 2,
              dashPattern: [8, 8],
              color: isCorrect ? Colors.transparent : AppColors.kStoneGrey,
            ),
            child: Container(
              width: metrics.labelWidth,
              height: metrics.labelHeight,
              padding: EdgeInsets.symmetric(
                vertical: metrics.labelVerticalPadding,
                horizontal: metrics.labelHorizontalPadding,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.kButtonGreen
                    : AppColors.kButtonGrey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isCorrect ? labelNp : labelEn,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: isCorrect ? AppColors.kWhite : AppColors.kGrey,
                    fontWeight: FontWeight.w600,
                    fontSize: metrics.labelFontSize,
                    fontFamily: AppConstants.kMuktaFont,
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
