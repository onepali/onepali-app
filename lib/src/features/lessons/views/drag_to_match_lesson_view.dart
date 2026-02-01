import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/blocs/drag_to_match_bloc/drag_to_match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/tap_to_reveal_lesson_view.dart';

class DragToMatchScreen extends StatelessWidget {
  const DragToMatchScreen({super.key, required this.lessonContent});

  final DragToMatchLessonContent lessonContent;

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

class DragToMatchScreenDirect extends StatelessWidget {
  const DragToMatchScreenDirect({super.key, required this.items});

  final List<Item> items;

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
  const _DragToMatchView({required this.items});

  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = Size(size.width * 0.05, size.height * 0.05);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: BlocBuilder<DragToMatchBloc, DragToMatchState>(
          builder: (context, state) {
            final allMatched =
                state.matchedItemIds.length == state.itemPositions.length;

            return Stack(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: allMatched ? 0.0 : 1.0,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: padding.height),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: state.itemPositions.map((itemPos) {
                          final item = items.firstWhere(
                            (i) => i.nameEn == itemPos.itemId,
                          );

                          final isCurrentTarget =
                              state.currentTargetItemId == itemPos.itemId;
                          return Padding(
                            padding: const EdgeInsets.only(right: 4),
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
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOutBack,
                  alignment: allMatched
                      ? Alignment.center
                      : const Alignment(0, 0.8),
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
              ],
            );
          },
        ),
      ),
    );
  }
}

class _DraggableItem extends StatelessWidget {
  const _DraggableItem({
    required this.position,
    required this.item,
    required this.isBeingDragged,
    required this.isPlayingAudio,
    required this.isCurrentTarget,
    required this.totalItems,
  });

  final ItemPosition position;
  final Item item;
  final bool isBeingDragged;
  final bool isPlayingAudio;
  final bool isCurrentTarget;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DragToMatchBloc>();
    if (position.isMatched) {
      return const SizedBox.shrink();
    }

    return Draggable<String>(
      data: item.nameEn,
      onDragStarted: () {
        bloc.add(DragToMatchEvent.startDrag(itemId: item.nameEn));
      },
      feedback: Material(
        color: Colors.transparent,
        child: _ItemWidget(
          item: item,
          isPlayingAudio: false,
          isCurrentTarget: false,
          totalItems: totalItems,
        ),
      ),
      childWhenDragging: _ItemWidget(
        item: item,
        isPlayingAudio: false,
        isCurrentTarget: false,
        totalItems: totalItems,
      ),
      child: _ItemWidget(
        item: item,
        isPlayingAudio: isPlayingAudio,
        isCurrentTarget: isCurrentTarget,
        totalItems: totalItems,
        onSpeakerTap: () {
          bloc.add(DragToMatchEvent.playItemAudio(itemId: item.nameEn));
        },
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.item,
    required this.isPlayingAudio,
    required this.isCurrentTarget,
    required this.totalItems,
    this.onSpeakerTap,
  });

  final Item item;
  final bool isPlayingAudio;
  final bool isCurrentTarget;
  final VoidCallback? onSpeakerTap;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - size.width * 0.15) / totalItems;
    final height = (size.height - size.height * 0.4) / 2;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.kStoryColor.withAlpha(100),
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
  const _OutlineTarget({
    required this.position,
    required this.item,
    required this.isMatched,
    required this.totalItems,
  });

  final ItemPosition position;
  final Item item;
  final bool isMatched;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = (size.width - size.width * 0.15) / totalItems;
    final height = (size.height - size.height * 0.4) / 2;

    final bloc = context.read<DragToMatchBloc>();

    return DragTarget<String>(
      onWillAcceptWithDetails: (_) => !isMatched,
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
