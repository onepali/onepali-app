import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/features/lessons/templates/drag_to_match/drag_to_match_bloc/drag_to_match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

const double _itemSpacing = 4.0;

class DragToMatchScreen extends StatelessWidget {
  final DragToMatchLessonContent lessonContent;

  const DragToMatchScreen({super.key, required this.lessonContent});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DragToMatchBloc()
            ..add(DragToMatchEvent.initialize(items: lessonContent.items)),
      child: _DragToMatchView(items: lessonContent.items),
    );
  }
}

// Alternative constructor if you want to pass items directly
class DragToMatchScreenDirect extends StatelessWidget {
  final List<Item> items;

  const DragToMatchScreenDirect({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DragToMatchBloc()..add(DragToMatchEvent.initialize(items: items)),
      child: _DragToMatchView(items: items),
    );
  }
}

class _DragToMatchView extends StatelessWidget {
  final List<Item> items;

  const _DragToMatchView({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocConsumer<DragToMatchBloc, DragToMatchState>(
        listenWhen: (previous, current) =>
            previous.dragStatus != current.dragStatus &&
            (current.dragStatus == DragStatus.correctMatch ||
                current.dragStatus == DragStatus.wrongMatch),
        listener: (context, state) {
          MetricsTrackingHelper.trackAnswerAttempt(
            context: context,
            isCorrect: state.dragStatus == DragStatus.correctMatch,
          );
        },
        builder: (context, state) {
          final allMatched =
              state.matchedItemIds.length == state.itemPositions.length;

          return Stack(
            children: [
              LessonContentFrame(
                reserveLeftControl: false,
                builder: (context, constraints) {
                  final contentSize = Size(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );
                  final groupWidth = contentSize.width;
                  final groupSize = Size(groupWidth, contentSize.height);
                  final rowSpacing = contentSize.height * 0.04;

                  final draggableRow = SizedBox(
                    width: groupWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(state.itemPositions.length, (
                        index,
                      ) {
                        final itemPos = state.itemPositions[index];
                        final item = items.firstWhere(
                          (i) => i.nameEn == itemPos.itemId,
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == state.itemPositions.length - 1
                                ? 0
                                : _itemSpacing,
                          ),
                          child: _DraggableItem(
                            position: itemPos,
                            item: item,
                            totalItems: state.itemPositions.length,
                            availableSize: groupSize,
                            isBeingDragged:
                                state.draggedItemId == itemPos.itemId,
                          ),
                        );
                      }),
                    ),
                  );

                  final outlineRow = SizedBox(
                    width: groupWidth,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(state.outlinePositions.length, (
                        index,
                      ) {
                        final outlinePos = state.outlinePositions[index];
                        final item = items.firstWhere(
                          (i) => i.nameEn == outlinePos.itemId,
                        );

                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == state.outlinePositions.length - 1
                                ? 0
                                : _itemSpacing,
                          ),
                          child: _OutlineTarget(
                            position: outlinePos,
                            item: item,
                            isMatched: outlinePos.isMatched,
                            totalItems: state.outlinePositions.length,
                            availableSize: groupSize,
                          ),
                        );
                      }),
                    ),
                  );

                  return SizedBox.expand(
                    child: Stack(
                      children: [
                        if (allMatched)
                          Center(child: outlineRow)
                        else
                          Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                draggableRow,
                                SizedBox(height: rowSpacing),
                                outlineRow,
                              ],
                            ),
                          ),
                        if (state.showNepaliword)
                          Positioned.fill(
                            child: Center(
                              child: LabelDisplay(
                                nameNp: state.itemPositions
                                    .firstWhere(
                                      (i) =>
                                          i.itemId == state.currentTargetItemId,
                                    )
                                    .nameNp,
                                nameEn: state.itemPositions
                                    .firstWhere(
                                      (i) => i.itemId == state.draggedItemId,
                                    )
                                    .nameNp,
                              ),
                            ),
                          ),
                        if (state.showCat)
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Image.asset(
                              Assets.goodRemark1,
                              height: contentSize.height * 0.5,
                              width: contentSize.height * 0.5,
                              fit: BoxFit.cover,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),

              // Close button
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
}

class _DraggableItem extends StatelessWidget {
  final ItemPosition position;
  final Item item;
  final bool isBeingDragged;
  final int totalItems;
  final Size availableSize;

  const _DraggableItem({
    required this.position,
    required this.item,
    required this.isBeingDragged,
    required this.totalItems,
    required this.availableSize,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DragToMatchBloc>();
    if (position.isMatched) {
      return SizedBox.shrink();
    }
    return Draggable<String>(
      data: item.nameEn,
      onDragStarted: () {
        bloc.add(DragToMatchEvent.startDrag(itemId: item.nameEn));
      },
      onDragEnd: (details) {
        // We'll handle this in DragTarget
      },
      feedback: Material(
        color: Colors.transparent,
        child: _ItemWidget(
          item: item,
          isBeingDragged: true,
          onSpeakerTap: null,
          totalItems: totalItems,
          availableSize: availableSize,
        ),
      ),
      childWhenDragging: _ItemWidget(
        item: item,
        isBeingDragged: false,
        onSpeakerTap: null,
        totalItems: totalItems,
        availableSize: availableSize,
      ),
      child: _ItemWidget(
        item: item,
        isBeingDragged: isBeingDragged,
        onSpeakerTap: () {
          bloc.add(DragToMatchEvent.playItemAudio(itemId: item.nameEn));
        },
        totalItems: totalItems,
        availableSize: availableSize,
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Item item;
  final bool isBeingDragged;
  final VoidCallback? onSpeakerTap;
  final int totalItems;
  final Size availableSize;

  const _ItemWidget({
    required this.item,
    required this.isBeingDragged,
    this.onSpeakerTap,
    required this.totalItems,
    required this.availableSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = availableSize;
    final gapCount = totalItems > 1 ? totalItems - 1 : 0;
    final width = totalItems == 0
        ? 0.0
        : ((size.width - (_itemSpacing * gapCount)) / totalItems)
              .clamp(0.0, size.width)
              .toDouble();
    final height = (size.height - size.height * 0.4) / 2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.kStoryColor.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SvgHelper.fromSource(
            path: item.image,
            type: SvgSourceType.network,

            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _OutlineTarget extends StatelessWidget {
  final ItemPosition position;
  final Item item;
  final bool isMatched;
  final int totalItems;
  final Size availableSize;

  const _OutlineTarget({
    required this.position,
    required this.item,
    required this.isMatched,
    required this.totalItems,
    required this.availableSize,
  });

  @override
  Widget build(BuildContext context) {
    final size = availableSize;
    final gapCount = totalItems > 1 ? totalItems - 1 : 0;
    final width = totalItems == 0
        ? 0.0
        : ((size.width - (_itemSpacing * gapCount)) / totalItems)
              .clamp(0.0, size.width)
              .toDouble();
    final height = (size.height - size.height * 0.4) / 2;

    final bloc = context.read<DragToMatchBloc>();

    return DragTarget<String>(
      onWillAcceptWithDetails: (details) {
        return !isMatched;
      },
      onAcceptWithDetails: (details) {
        bloc.add(
          DragToMatchEvent.endDrag(
            itemId: details.data,
            targetOutlineId: position.id,
          ),
        );
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: isMatched
                ? Colors.green.withAlpha(50)
                : isHovering
                ? AppColors.kSecondaryColor.withAlpha(50)
                : AppColors.kGrey.withAlpha(50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isMatched
                  ? AppColors.kButtonGreen
                  : isHovering
                  ? AppColors.kLightGreenBackgroundColor
                  : Colors.grey,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: SvgHelper.fromSource(
              path: isMatched ? item.image : item.imageOutline ?? '',
              type: SvgSourceType.network,

              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
