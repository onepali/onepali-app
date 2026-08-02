import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/bottom_right_cat.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/templates/gun_fill/gun_fill_bloc/gun_fill_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/src.dart';
import 'package:path_drawing/path_drawing.dart';

class GunFillLessonView extends StatefulWidget {
  final GunFillLessonContent content;
  const GunFillLessonView({super.key, required this.content});

  @override
  State<GunFillLessonView> createState() => _GunFillLessonViewState();
}

class _GunFillLessonViewState extends State<GunFillLessonView> {
  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return BlocProvider(
      create: (context) =>
          GunFillBloc()..add(GunFillEvent.started(widget.content, isMobile)),
      child: BlocBuilder<GunFillBloc, GunFillState>(
        builder: (context, state) {
          if (state.content == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == GunFillStatus.failed) {
            return Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(color: AppColors.kDrawerBgColor),
                ),
                const Center(
                  child: Text(
                    'Unable to load this lesson.',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    LessonEvent.previousContent(),
                  ),
                ),
                CenterRightAlignedForwardButton(
                  onTap: () =>
                      context.read<LessonBloc>().add(LessonEvent.nextContent()),
                ),
                TopRightPositionedCloseButton(),
              ],
            );
          }

          final gunParts = state.gunParts;
          final colorChipRadius = isMobile ? 35.0 : 60.0;
          final colorSelectionTickSize = colorChipRadius * 1.25;
          final gunShapeHighlightOffset = Offset(
            isMobile ? -2.0 : -3.0,
            isMobile ? -2.0 : -3.0,
          );
          return Stack(
            children: [
              Positioned.fill(
                child: ColoredBox(color: AppColors.kDrawerBgColor),
              ),
              // Main content area
              Column(
                children: [
                  // Colors
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...gunParts.map(
                          (part) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Draggable(
                              data: part.id,
                              feedback: CircleAvatar(
                                radius: colorChipRadius,
                                backgroundColor: colorFromHex(
                                  part.id,
                                )?.withValues(alpha: 0.8),
                              ),
                              childWhenDragging: CircleAvatar(
                                radius: colorChipRadius,
                                backgroundColor: colorFromHex(
                                  part.id,
                                )?.withValues(alpha: 0.5),
                              ),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: colorChipRadius,
                                    backgroundColor: colorFromHex(part.id),
                                  ),
                                  if (part.isFilled)
                                    Positioned.fill(
                                      child: Center(
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: AppColors.kButtonGreen,
                                          size: colorSelectionTickSize,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        log('Constraints: $constraints');
                        double svgWidth = isMobile
                            ? constraints.maxWidth * 0.6
                            : constraints.maxWidth;
                        double svgHeight = constraints.maxHeight;

                        return Center(
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              width: svgWidth,
                              height: svgHeight,
                              child: Stack(
                                children: [
                                  ...gunParts.map(
                                    (part) => _GunPathHighlight(
                                      path: part.path,
                                      width: svgWidth,
                                      height: svgHeight,
                                      offset: gunShapeHighlightOffset,
                                    ),
                                  ),
                                  ...state.labelPaths.map(
                                    (labelPath) => _GunPathHighlight(
                                      path: labelPath.path,
                                      width: svgWidth,
                                      height: svgHeight,
                                      offset: gunShapeHighlightOffset,
                                    ),
                                  ),
                                  // Gun parts
                                  ...gunParts.map(
                                    (part) => part.isFilled
                                        ? ClipPath(
                                                clipper: PartClipper(part.path),
                                                child: Container(
                                                  width: svgWidth,
                                                  height: svgHeight,
                                                  color: colorFromHex(part.id),
                                                ),
                                              )
                                              .animate()
                                              .shake(
                                                hz: 3,
                                                duration: const Duration(
                                                  milliseconds: 600,
                                                ),
                                              )
                                              .then()
                                              .shimmer(
                                                duration: const Duration(
                                                  milliseconds: 800,
                                                ),
                                              )
                                        : ClipPath(
                                            clipper: PartClipper(part.path),
                                            child: DragTarget(
                                              onWillAcceptWithDetails:
                                                  (details) {
                                                    return details.data
                                                        is String;
                                                  },
                                              onAcceptWithDetails: (details) {
                                                final draggedPartId =
                                                    details.data;
                                                if (draggedPartId != part.id) {
                                                  context.read<GunFillBloc>().add(
                                                    const GunFillEvent.wrongColorDropped(),
                                                  );
                                                  return;
                                                }
                                                context.read<GunFillBloc>().add(
                                                  GunFillEvent.colorFilled(
                                                    part.id,
                                                  ),
                                                );
                                              },
                                              builder:
                                                  (
                                                    context,
                                                    candidateItems,
                                                    rejectedItems,
                                                  ) => Container(
                                                    width: svgWidth,
                                                    height: svgHeight,
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                          ),
                                  ),
                                  // Labels
                                  ...state.labelPaths.map(
                                    (labelPath) => ClipPath(
                                      clipper: PartClipper(labelPath.path),
                                      child: DragTarget(
                                        onWillAcceptWithDetails: (details) {
                                          final gunPartId = labelPath.gunPartId;
                                          if (gunPartId == null) return false;
                                          return details.data is String;
                                        },
                                        onAcceptWithDetails: (details) {
                                          final gunPartId = labelPath.gunPartId;
                                          if (gunPartId == null) return;
                                          final draggedPartId = details.data;
                                          if (draggedPartId != gunPartId) {
                                            context.read<GunFillBloc>().add(
                                              const GunFillEvent.wrongColorDropped(),
                                            );
                                            return;
                                          }
                                          context.read<GunFillBloc>().add(
                                            GunFillEvent.colorFilled(gunPartId),
                                          );
                                        },
                                        builder:
                                            (
                                              context,
                                              candidateItems,
                                              rejectedItems,
                                            ) {
                                              return Container(
                                                width: svgWidth,
                                                height: svgHeight,
                                                color:
                                                    colorFromHex(
                                                      labelPath.color ??
                                                          '#B1B1B1',
                                                    ) ??
                                                    Colors.grey,
                                              );
                                            },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (state.isCompleted) const BottomRightCat(),
              // Navigation buttons
              if (state.isCompleted)
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    LessonEvent.previousContent(),
                  ),
                ),
              if (state.isCompleted)
                CenterRightAlignedForwardButton(
                  onTap: () =>
                      context.read<LessonBloc>().add(LessonEvent.nextContent()),
                ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PartClipper extends CustomClipper<Path> {
  final String pathData;

  PartClipper(this.pathData);

  @override
  Path getClip(Size size) {
    try {
      return parseSvgPathData(pathData);
    } catch (error, stackTrace) {
      log(
        'Failed to parse gun fill SVG path',
        error: error,
        stackTrace: stackTrace,
      );
      return Path();
    }
  }

  @override
  bool shouldReclip(covariant PartClipper oldClipper) =>
      oldClipper.pathData != pathData;
}

class _GunPathHighlight extends StatelessWidget {
  const _GunPathHighlight({
    required this.path,
    required this.width,
    required this.height,
    required this.offset,
  });

  final String path;
  final double width;
  final double height;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: ClipPath(
        clipper: PartClipper(path),
        child: SizedBox(
          width: width,
          height: height,
          child: ColoredBox(color: AppColors.kWhite.withValues(alpha: 0.20)),
        ),
      ),
    );
  }
}
