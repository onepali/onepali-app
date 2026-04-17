import 'dart:developer';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/match_bloc/match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class MatchGameScreen extends StatefulWidget {
  final SlideUpToMatchLessonContent content;
  final bool isLastContent;
  const MatchGameScreen({
    super.key,
    required this.content,
    this.isLastContent = false,
  });

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen> {
  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) => MatchBloc()..add(MatchEvent.started(widget.content)),
      child: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state.content == null) {
            return SizedBox.shrink();
          }
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: isMobile ? 60 : size.height * 0.15),
                  //TOP ROW: Items & English Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.content!.items.map((item) {
                      return TopItems(
                        image: item.image,
                        labelEn: item.nameEn,
                        labelNp: item.nameNp,
                        bgColor: colorFromHex(item.bgColor) ?? Colors.white,
                        isCorrect: item.isCorrect,
                      );
                    }).toList(),
                  ),
                  Spacer(),
                  //BOTTOM ROW: Draggable Nepali Labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.nepaliWords.map((item) {
                      return _buildDraggableLabel(item);
                    }).toList(),
                  ),
                  SizedBox(height: isMobile ? 60 : size.height * 0.15),
                ],
              ),
              if (state.isAnsweredAll & widget.isLastContent)
                Positioned.fill(
                  child: LottieHelper.fromSource(
                    path: Assets.confetti1,
                    fit: BoxFit.cover,
                  ),
                ),
              CenterLeftAlignedBackButton(
                onTap: () {
                  context.read<LessonBloc>().add(LessonEvent.previousContent());
                },
              ),
              if (!widget.isLastContent)
                CenterRightAlignedForwardButton(
                  onTap: () {
                    context.read<LessonBloc>().add(LessonEvent.nextContent());
                  },
                ),

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
  Widget _buildDraggableLabel(String text) {
    return Draggable<String>(
      data: text,
      feedback: Material(
        color: Colors.transparent,
        child: _labelContainer(text, opacity: 0.7),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _labelContainer(text)),
      child: _labelContainer(text),
    );
  }

  Widget _labelContainer(String text, {double opacity = 1.0}) {
    final isMobile = PlatformUtility.isMobile(context);
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 12,
        horizontal: isMobile ? 16 : 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.kSecondaryColor,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        text,
        style: isMobile
            ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.kWhite,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              )
            : Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.kWhite,
                fontSize: 44,
                fontFamily: AppConstants.kMuktaFont,
              ),
      ),
    );
  }
}

class TopItems extends StatelessWidget {
  const TopItems({
    super.key,
    required this.image,
    required this.labelEn,
    required this.labelNp,
    required this.bgColor,
    required this.isCorrect,
  });

  final String image;
  final String labelEn;
  final String labelNp;
  final Color bgColor;
  final bool isCorrect;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return DragTarget(
      onAcceptWithDetails: (details) {
        if (details.data == labelNp) {
          context.read<MatchBloc>().add(MatchEvent.onAccept(labelNp));
        }
      },
      builder: (context, candidateData, rejectedData) => Column(
        children: [
          SizedBox(
            width: isMobile ? 120 : 200,
            height: isMobile ? 120 : 200,
            child: CustomCachedImage(imageUrl: image, fit: BoxFit.cover),
          ),
          SizedBox(height: isMobile ? 16 : 24),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(50),
              strokeWidth: 2,
              dashPattern: [8, 8],
              color: isCorrect ? Colors.transparent : AppColors.kStoneGrey,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 8 : 12,
                horizontal: isMobile ? 16 : 32,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppColors.kButtonGreen
                    : AppColors.kButtonGrey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                isCorrect ? labelNp : labelEn,
                style: isMobile
                    ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: isCorrect ? AppColors.kWhite : AppColors.kGrey,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppConstants.kMuktaFont,
                      )
                    : Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: isCorrect ? AppColors.kWhite : AppColors.kGrey,
                        fontFamily: AppConstants.kMuktaFont,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
