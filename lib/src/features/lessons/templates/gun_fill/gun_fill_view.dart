import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          final gunParts = state.gunParts;
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
                              onDragCompleted: () {
                                context.read<GunFillBloc>().add(
                                  GunFillEvent.colorFilled(part.id),
                                );
                              },
                              feedback: CircleAvatar(
                                radius: isMobile ? 35 : 60,
                                backgroundColor: colorFromHex(
                                  part.id,
                                )?.withValues(alpha: 0.8),
                              ),
                              childWhenDragging: CircleAvatar(
                                radius: isMobile ? 35 : 60,
                                backgroundColor: colorFromHex(
                                  part.id,
                                )?.withValues(alpha: 0.5),
                              ),
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: isMobile ? 35 : 60,
                                    backgroundColor: colorFromHex(part.id),
                                  ),
                                  if (part.isFilled)
                                    Positioned.fill(
                                      child: SvgPicture.asset(
                                        Assets.check,
                                        colorFilter: ColorFilter.mode(
                                          AppColors.kButtonGreen,
                                          BlendMode.srcIn,
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
                                                    return details.data ==
                                                        part.id;
                                                  },
                                              onAcceptWithDetails: (details) {
                                                final isCorrect = details.data == part.id;
                                                context.read<PzMetricsProvider>().trackAnswer1(isCorrect: isCorrect);
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
                                          return details.data ==
                                              labelPath.gunPartId;
                                        },
                                        onAcceptWithDetails: (details) {
                                          context.read<GunFillBloc>().add(
                                            GunFillEvent.colorFilled(
                                              labelPath.gunPartId!,
                                            ),
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
             if (state.isCompleted)  BottomRightCat(),
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

// class PartClipper extends CustomClipper<Path> {
//   final String pathData;
//   final String? fillColor;

//   PartClipper(this.pathData, {this.fillColor});

//   @override
//   Path getClip(Size size) {
//     // Parse the SVG path data
//     final path = parseSvgPathData(pathData);
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }

class PartClipper extends CustomClipper<Path> {
  final String pathData;

  PartClipper(this.pathData);

  @override
  Path getClip(Size size) {
    Path path = parseSvgPathData(pathData);

    // Scale the path to fit the actual widget size
    Rect boundingBox = path.getBounds();
    Matrix4 matrix = Matrix4.identity();

    // This scales the path coordinates to the current container size
    double scaleX = size.width / boundingBox.width;
    double scaleY = size.height / boundingBox.height;

    // Note: You may need more complex transformation logic depending
    // on how your SVG data is exported (viewBox vs absolute)
    return path.transform(Float64List.fromList(matrix.storage));
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
