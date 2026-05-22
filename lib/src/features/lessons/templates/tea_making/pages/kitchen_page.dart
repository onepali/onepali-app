import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/dragged_item.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/huncha_button.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/ingredient.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/leopard_with_tea.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key, required this.content});
  final TeaMakingLessonContent content;

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final GlobalKey _taePotKey = GlobalKey();
  final GlobalKey _stoveKey = GlobalKey();

  Widget buildIndicator(Size size) {
    final taeContext = _taePotKey.currentContext;
    final stoveContext = _stoveKey.currentContext;
    if (taeContext == null || stoveContext == null) {
      return const SizedBox.shrink();
    }

    final taeBox = taeContext.findRenderObject() as RenderBox;
    final stoveBox = stoveContext.findRenderObject() as RenderBox;

    // Global positions
    final taeOffset = taeBox.localToGlobal(Offset.zero);
    final stoveOffset = stoveBox.localToGlobal(Offset.zero);

    // Stove top-center
    final stoveTopCenter = Offset(
      stoveOffset.dx + stoveBox.size.width / 2,
      stoveOffset.dy,
    );

    // Calculate container dimensions
    final left = taeOffset.dx + size.height * 0.1;
    final top = taeOffset.dy + size.height * 0.1;

    final width = stoveTopCenter.dx - left;
    final height = stoveTopCenter.dy - top;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: IgnorePointer(
        child: SvgPicture.asset(
          'assets/tea_maker/svg/drag_indicator.svg',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    _precacheCompletionImages();
  }

  void _precacheCompletionImages() {
    for (final url in [
      widget.content.leopardTakingTeaMb,
      widget.content.leopardTakingTeaTb,
    ]) {
      final trimmed = url.trim();
      if (trimmed.isNotEmpty) {
        unawaited(MediaCacheManager.instance.getSingleFile(trimmed));
      }
    }
  }

  bool _showDroppedItem(TutorialState state) {
    return state.lastDroppedItem != null &&
        state.status != TutorialStatus.completed &&
        _droppedItemImage(state).isNotEmpty;
  }

  /// nameNp after drop until the next ingredient question starts.
  bool _showIngredientLabel(TutorialState state) {
    if (state.lastDroppedItem == null) return false;
    if (state.status == TutorialStatus.completed) return false;
    if (state.status == TutorialStatus.guidePlaying) return false;

    return state.status == TutorialStatus.itemDropped ||
        state.status == TutorialStatus.itemAudioPlaying ||
        state.status == TutorialStatus.itemAudioCompleted;
  }

  String _droppedItemImage(TutorialState state) {
    final item = state.lastDroppedItem!;
    if (item.imageOutline?.isNotEmpty == true) {
      return item.imageOutline!;
    }
    if (item.image.isNotEmpty) {
      return item.image;
    }
    return state.content?.teapotVapour ?? '';
  }

  int? _firstVisibleIngredientIndex(TutorialState state) {
    final ingredients = state.content?.ingredients;
    if (ingredients == null) return null;
    for (var i = 0; i < ingredients.length; i++) {
      if (ingredientHasImage(ingredients[i])) return i;
    }
    return null;
  }

  Widget _buildIngredientDraggable({
    required TutorialState state,
    required int index,
  }) {
    final ingredient = state.content!.ingredients[index];
    if (!ingredientHasImage(ingredient)) {
      return const SizedBox.shrink();
    }

    final canDrag =
        state.status == TutorialStatus.ideal && state.currentIndex == index;

    final child = Ingredient(
      ingredient: ingredient.image,
      isSelected: state.currentIndex == index,
    );

    if (!canDrag) {
      return SizedBox(child: child);
    }

    return Draggable<Item>(
      data: ingredient,
      feedback: SvgPicture.network(ingredient.image),
      childWhenDragging: SvgPicture.network(
        ingredient.image,
        colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.modulate),
      ),
      child: SizedBox(child: child),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return BlocProvider(
      create: (context) =>
          TutorialBloc()..add(TutorialEvent.started(widget.content)),
      child: BlocBuilder<TutorialBloc, TutorialState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.kBlue,
            body: state.content == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top ingredients
                          if (state.status != TutorialStatus.completed)
                            Container(
                              height: size.height * 0.25,
                              padding: EdgeInsets.only(
                                left: size.width * 0.05,
                                right: size.width * 0.1,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kGreen,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(50),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(50),
                                    spreadRadius: 4,
                                    blurRadius: 12,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  for (
                                    var index = 0;
                                    index < state.content!.ingredients.length;
                                    index++
                                  )
                                    if (ingredientHasImage(
                                      state.content!.ingredients[index],
                                    ))
                                      SizedBox(
                                        key:
                                            index ==
                                                _firstVisibleIngredientIndex(
                                                  state,
                                                )
                                            ? _taePotKey
                                            : null,
                                        width: isMobile
                                            ? size.height * 0.3
                                            : size.height * 0.2,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 24,
                                                    ),
                                                child:
                                                    _buildIngredientDraggable(
                                                      state: state,
                                                      index: index,
                                                    ),
                                              ),
                                            ),
                                            if (state.completedIngredientIndices
                                                .contains(index))
                                              Positioned.fill(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Transform.scale(
                                                    scale: isMobile ? 0.7 : 1,
                                                    child: SvgPicture.asset(
                                                      'assets/tea_maker/svg/check.svg',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                ],
                              ),
                            ),
                          Spacer(),
                          // Stove section
                          Center(
                            child: SizedBox(
                              height: size.height * 0.25,
                              // decoration: BoxDecoration(color: Colors.orange),
                              child: SvgPicture.network(
                                key: _stoveKey,
                                state.content!.stoveImage,
                                height: size.height * 0.25,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Kitchen section: outline below, drop target on top when ideal
                      if (_showDroppedItem(state) ||
                          (state.status == TutorialStatus.ideal &&
                              state.currentItem != null &&
                              ingredientHasImage(state.currentItem!)))
                        Positioned(
                          bottom: size.height * 0.25,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: size.height * 0.50,
                            width: size.width,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                if (_showDroppedItem(state))
                                  IgnorePointer(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: DraggedItem(
                                        index: state.currentIndex,
                                        draggedItem: _droppedItemImage(state),
                                      ),
                                    ),
                                  ),
                                if (state.status == TutorialStatus.ideal &&
                                    state.currentItem != null &&
                                    ingredientHasImage(state.currentItem!))
                                  DragTarget<Item>(
                                    onWillAcceptWithDetails: (details) {
                                      if (state.status !=
                                          TutorialStatus.ideal) {
                                        return false;
                                      }
                                      final item = details.data;
                                      if (!ingredientHasImage(item)) {
                                        return false;
                                      }
                                      final current = state
                                          .content!
                                          .ingredients[state.currentIndex];
                                      return item.nameEn == current.nameEn &&
                                          item.nameNp == current.nameNp;
                                    },
                                    onAcceptWithDetails: (details) {
                                      context.read<TutorialBloc>().add(
                                        TutorialEvent.itemDropped(details.data),
                                      );
                                    },
                                    builder:
                                        (context, candidateData, rejectedData) {
                                          return SizedBox(
                                            height: size.height * 0.50,
                                            width: size.width,
                                          );
                                        },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      // Leopard making announcement
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: LeopardWithTea(),
                      ),

                      // Huncha button in middle
                      Positioned(
                        bottom: size.height * 0.17,
                        right: 0,
                        left: 0,
                        child: HunchaButton(),
                      ),
                      // Drag indicator — first draggable ingredient only
                      if (state.currentIndex ==
                              _firstVisibleIngredientIndex(state) &&
                          state.currentItem != null &&
                          ingredientHasImage(state.currentItem!) &&
                          state.status == TutorialStatus.ideal)
                        buildIndicator(size),
                      // nameNp with pronunciation; hidden during next instruction
                      if (_showIngredientLabel(state))
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: size.height * 0.09,
                          child: LabelDisplay(
                            nameNp: state.lastDroppedItem!.nameNp,
                            nameEn: '',
                          ),
                        ),
                      if (state.status == TutorialStatus.completed)
                        Positioned.fill(
                          // alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 100,
                                right: 100,
                                left: 100,
                              ),
                              child: SvgPicture.network(
                                isMobile
                                    ? state.content!.leopardTakingTeaMb
                                    : state.content!.leopardTakingTeaTb,
                              ),
                            ),
                          ),
                        ),
                      if (state.status == TutorialStatus.completed)
                        LottieHelper.fromSource(
                          path: 'assets/lottie/confetti_1.json',
                          fit: BoxFit.cover,
                          repeat: true,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          type: LottieSourceType.asset,
                        ),

                      TopRightPositionedCloseButton(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
