import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/blocs/put_in_bag_bloc/put_in_bag_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';

class PutInBagView extends StatefulWidget {
  const PutInBagView({super.key, required this.content, required this.onNext});

  final PutInBagLessonContent content;
  final VoidCallback onNext;

  @override
  State<PutInBagView> createState() => _PutInBagViewState();
}

class _PutInBagViewState extends State<PutInBagView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return BlocProvider(
      create: (context) =>
          PutInBagBloc()..add(PutInBagEvent.started(widget.content)),
      child: BlocBuilder<PutInBagBloc, PutInBagState>(
        builder: (context, state) {
          if (state.content == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final currentPlayingItem = state.currentPlayingItemIndex == null
              ? null
              : state.content!.items[state.currentPlayingItemIndex!];
          return Stack(
            children: [
              if (widget.content.bgColor != null)
                Positioned.fill(
                  child: ColoredBox(
                    color:
                        colorFromHex(widget.content.bgColor) ??
                        AppColors.kBackgroundColor,
                  ),
                ),
              BackgroundImage(
                bgImageMb: widget.content.bgImage,
                bgImageTb: widget.content.bgImageTb,
              ),
              Column(
                children: [
                  Container(
                    height: size.height * 0.25,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: state.content!.items
                            .asMap()
                            .entries
                            .map(
                              (entry) =>
                                  state.droppedItemIndexes.contains(entry.key)
                                  ? const SizedBox.shrink()
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: state.isAudioPlaying
                                          ? CustomCachedImage(
                                              imageUrl: entry.value.image,
                                            )
                                          : Draggable<int>(
                                              data: entry.key,
                                              feedback: Material(
                                                color: Colors.transparent,
                                                child: CustomCachedImage(
                                                  imageUrl: entry.value.image,
                                                  height: size.height * 0.3,
                                                  width: size.width * 0.3,
                                                ),
                                              ),
                                              childWhenDragging: Opacity(
                                                opacity: 0.3,
                                                child: CustomCachedImage(
                                                  imageUrl: entry.value.image,
                                                ),
                                              ),
                                              child: CustomCachedImage(
                                                imageUrl: entry.value.image,
                                              ),
                                            ),
                                    ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * widget.content.topBagPaddingRatio,
                  ),
                  if (widget.content.bagImage != null)
                    Expanded(
                      child: DragTarget<int>(
                        onWillAcceptWithDetails: (details) =>
                            !state.isAudioPlaying &&
                            !state.droppedItemIndexes.contains(details.data),
                        onAcceptWithDetails: (details) {
                          context.read<PutInBagBloc>().add(
                            PutInBagEvent.itemDropped(details.data),
                          );
                        },
                        builder: (context, _, _) => CustomCachedImage(
                          imageUrl:
                              state.currentBagItemImage ??
                              widget.content.bagImage!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  SizedBox(height: isMobile ? 24 : 48),
                ],
              ),

              if (state.isAudioPlaying && currentPlayingItem != null)
                Positioned(
                  bottom: size.height * 0.05,
                  left: 0,
                  right: 0,
                  child: LabelDisplay(
                    nameNp: currentPlayingItem.nameNp,
                    nameEn: currentPlayingItem.nameEn,
                  ),
                ),

              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
              if (state.isCompleted)
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    LessonEvent.previousContent(),
                  ),
                ),
              if (state.isCompleted)
                CenterRightAlignedForwardButton(onTap: widget.onNext),
            ],
          );
        },
      ),
    );
  }
}
