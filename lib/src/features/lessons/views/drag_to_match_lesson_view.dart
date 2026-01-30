import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/blocs/drag_to_match_bloc/drag_to_match_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

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
      body: SafeArea(
        child: BlocBuilder<DragToMatchBloc, DragToMatchState>(
          builder: (context, state) {
            return Stack(
              children: [
                // Game area
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Outline positions (drop targets)
                        ...state.outlinePositions.map((outlinePos) {
                          final item = items.firstWhere(
                            (i) => i.nameEn == outlinePos.itemId,
                          );

                          return _OutlineTarget(
                            position: outlinePos,
                            item: item,
                            containerWidth: constraints.maxWidth,
                            containerHeight: constraints.maxHeight,
                            isMatched: outlinePos.isMatched,
                          );
                        }),

                        // Draggable items
                        ...state.itemPositions.map((itemPos) {
                          if (itemPos.isMatched) {
                            return const SizedBox.shrink();
                          }

                          final item = items.firstWhere(
                            (i) => i.nameEn == itemPos.itemId,
                          );

                          return _DraggableItem(
                            position: itemPos,
                            item: item,
                            containerWidth: constraints.maxWidth,
                            containerHeight: constraints.maxHeight,
                            isBeingDragged:
                                state.draggedItemId == itemPos.itemId,
                            isPlayingAudio:
                                state.currentPlayingAudioId == itemPos.itemId,
                          );
                        }),

                        // Matched items (show label)
                        ...state.matchedItemIds.map((itemId) {
                          final item = items.firstWhere(
                            (i) => i.nameEn == itemId,
                          );
                          final outlinePos = state.outlinePositions.firstWhere(
                            (pos) => pos.itemId == itemId,
                          );

                          return Positioned(
                            left: outlinePos.x * constraints.maxWidth,
                            top: outlinePos.y * constraints.maxHeight,
                            child: _MatchedItemDisplay(item: item),
                          );
                        }),
                      ],
                    );
                  },
                ),

                // Reset button
                Positioned(
                  top: 16,
                  right: 16,
                  child: IconButton(
                    onPressed: () {
                      context.read<DragToMatchBloc>().add(
                        const DragToMatchEvent.resetGame(),
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    iconSize: 32,
                    color: Colors.blue,
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
  final ItemPosition position;
  final Item item;
  final double containerWidth;
  final double containerHeight;
  final bool isBeingDragged;
  final bool isPlayingAudio;

  const _DraggableItem({
    required this.position,
    required this.item,
    required this.containerWidth,
    required this.containerHeight,
    required this.isBeingDragged,
    required this.isPlayingAudio,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DragToMatchBloc>();

    return Positioned(
      left: position.x * containerWidth,
      top: position.y * containerHeight,
      child: Draggable<String>(
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
            onSpeakerTap: null,
          ),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _ItemWidget(
            item: item,
            isBeingDragged: false,
            isPlayingAudio: false,
            onSpeakerTap: null,
          ),
        ),
        child: _ItemWidget(
          item: item,
          isBeingDragged: isBeingDragged,
          isPlayingAudio: isPlayingAudio,
          onSpeakerTap: () {
            bloc.add(DragToMatchEvent.playItemAudio(itemId: item.nameEn));
          },
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final Item item;
  final bool isBeingDragged;
  final bool isPlayingAudio;
  final VoidCallback? onSpeakerTap;

  const _ItemWidget({
    required this.item,
    required this.isBeingDragged,
    required this.isPlayingAudio,
    this.onSpeakerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: isPlayingAudio
            ? Border.all(color: Colors.orange, width: 3)
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SvgHelper.fromSource(
                path: item.image,
                type: SvgSourceType.network,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (onSpeakerTap != null)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onSpeakerTap,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlayingAudio ? Icons.volume_up : Icons.volume_up_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OutlineTarget extends StatelessWidget {
  final ItemPosition position;
  final Item item;
  final double containerWidth;
  final double containerHeight;
  final bool isMatched;

  const _OutlineTarget({
    required this.position,
    required this.item,
    required this.containerWidth,
    required this.containerHeight,
    required this.isMatched,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DragToMatchBloc>();

    return Positioned(
      left: position.x * containerWidth,
      top: position.y * containerHeight,
      child: DragTarget<String>(
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
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: isMatched
                  ? Colors.green.withValues(alpha: 0.2)
                  : isHovering
                  ? Colors.blue.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isMatched
                    ? Colors.green
                    : isHovering
                    ? Colors.blue
                    : Colors.grey,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: item.imageOutline != null
                ? Center(
                    child: Opacity(
                      opacity: isMatched ? 0 : 0.5,
                      child: SvgHelper.fromSource(
                        path: item.imageOutline!,
                        type: SvgSourceType.network,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}

class _MatchedItemDisplay extends StatelessWidget {
  final Item item;

  const _MatchedItemDisplay({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green, width: 2),
            ),
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image, size: 60);
                      },
                    ),
                  ),
                ),
                const Positioned(
                  top: 4,
                  right: 4,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text(
              item.nameNp,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
