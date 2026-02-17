import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/features/lessons/blocs/drag_to_match_bloc/drag_to_match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';

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

  const DragToMatchScreenDirect({Key? key, required this.items})
    : super(key: key);

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
    final size = MediaQuery.sizeOf(context);
    final Size padding = Size(size.width * 0.1, size.height * 0.2);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocBuilder<DragToMatchBloc, DragToMatchState>(
        builder: (context, state) {
          final allMatched =
              state.matchedItemIds.length == state.itemPositions.length;

          return Stack(
            children: [
              // 1. Draggable Items Row (Top)
              // We use AnimatedOpacity to fade it out when finished
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: allMatched ? 0.0 : 1.0,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: padding.height),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: state.itemPositions.map((itemPos) {
                        final item = items.firstWhere(
                          (i) => i.nameEn == itemPos.itemId,
                        );

                        final isCurrentTarget =
                            state.currentTargetItemId == itemPos.itemId;
                        return Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Opacity(
                            opacity: isCurrentTarget ? 1.0 : 0.8,
                            child: _DraggableItem(
                              position: itemPos,
                              item: item,
                              totalItems: state.itemPositions.length,
                              isBeingDragged:
                                  state.draggedItemId == itemPos.itemId,
                              isPlayingAudio:
                                  state.currentPlayingAudioId == itemPos.itemId,
                              isCurrentTarget: isCurrentTarget,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              // 2. Animated Outline Target Row
              // This will move from the bottom area to the center
              AnimatedAlign(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOutBack, // Adds a nice "pop" effect
                alignment: allMatched
                    ? Alignment.center
                    : const Alignment(0, 0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: state.outlinePositions.map((outlinePos) {
                    final item = items.firstWhere(
                      (i) => i.nameEn == outlinePos.itemId,
                    );
                    return _OutlineTarget(
                      position: outlinePos,
                      item: item,
                      isMatched: outlinePos.isMatched,
                      totalItems: state.outlinePositions.length,
                    );
                  }).toList(),
                ),
              ),

              if (state.showNepaliword)
                Positioned.fill(
                  child: Center(
                    child: CorrectNameDisplay(
                      nameNp: state.itemPositions
                          .firstWhere(
                            (i) => i.itemId == state.currentTargetItemId,
                          )
                          .nameNp,
                      nameEn: state.itemPositions
                          .firstWhere((i) => i.itemId == state.draggedItemId)
                          .nameNp,
                    ),
                  ),
                ),

              // Close button
              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
              if (state.showCat)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset(
                    Assets.goodRemark1,
                    height: size.height * 0.5,
                    width: size.height * 0.5,
                    fit: BoxFit.cover,
                  ),
                ),
              if (state.showCat)
                Positioned.fill(
                  child: IgnorePointer(
                    child: LottieHelper.fromSource(path: Assets.confetti1),
                  ),
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
  final bool isPlayingAudio;
  final bool isCurrentTarget;
  final int totalItems;

  const _DraggableItem({
    required this.position,
    required this.item,
    required this.isBeingDragged,
    required this.isPlayingAudio,
    required this.isCurrentTarget,
    required this.totalItems,
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
          isPlayingAudio: false,
          isCurrentTarget: false,
          onSpeakerTap: null,
          totalItems: totalItems,
        ),
      ),
      childWhenDragging: _ItemWidget(
        item: item,
        isBeingDragged: false,
        isPlayingAudio: false,
        isCurrentTarget: false,
        onSpeakerTap: null,
        totalItems: totalItems,
      ),
      child: _ItemWidget(
        item: item,
        isBeingDragged: isBeingDragged,
        isPlayingAudio: isPlayingAudio,
        isCurrentTarget: isCurrentTarget,
        onSpeakerTap: () {
          bloc.add(DragToMatchEvent.playItemAudio(itemId: item.nameEn));
        },
        totalItems: totalItems,
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Item item;
  final bool isBeingDragged;
  final bool isPlayingAudio;
  final bool isCurrentTarget;
  final VoidCallback? onSpeakerTap;
  final int totalItems;

  const _ItemWidget({
    required this.item,
    required this.isBeingDragged,
    required this.isPlayingAudio,
    required this.isCurrentTarget,
    this.onSpeakerTap,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - size.width * 0.15) / totalItems;
    final height = (size.height - size.height * 0.45) / 2;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.kStoneGrey,
        borderRadius: BorderRadius.circular(12),

        border: isCurrentTarget
            ? Border.all(color: AppColors.kGreen, width: 2)
            : isPlayingAudio
            ? Border.all(color: Colors.orange, width: 3)
            : null,
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

  const _OutlineTarget({
    required this.position,
    required this.item,
    required this.isMatched,
    required this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - size.width * 0.15) / totalItems;
    final height = (size.height - size.height * 0.45) / 2;

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
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorFromHex(item.outlineBgColor),
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
