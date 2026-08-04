import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/bloc/tutorial_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/leopard_with_tea.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/dragged_item.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/huncha_button.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/widgets/ingredient.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({
    super.key,
    required this.content,
    required this.onNext,
    this.onLessonCompleted,
  });
  final TeaMakingLessonContent content;
  final VoidCallback onNext;
  final VoidCallback? onLessonCompleted;

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _taePotKey = GlobalKey();
  final GlobalKey _stoveKey = GlobalKey();

  Widget buildIndicator(Size size, String? dragIndicator) {
    final stackContext = _stackKey.currentContext;
    final taeContext = _taePotKey.currentContext;
    final stoveContext = _stoveKey.currentContext;
    if (stackContext == null ||
        taeContext == null ||
        stoveContext == null ||
        dragIndicator?.isNotEmpty != true) {
      return const SizedBox.shrink();
    }

    final stackBox = stackContext.findRenderObject() as RenderBox;
    final taeBox = taeContext.findRenderObject() as RenderBox;
    final stoveBox = stoveContext.findRenderObject() as RenderBox;

    final taeBottomRight = stackBox.globalToLocal(
      taeBox.localToGlobal(Offset(taeBox.size.width, taeBox.size.height)),
    );

    final stoveTopCenter = stackBox.globalToLocal(
      stoveBox.localToGlobal(Offset(stoveBox.size.width / 2, 0)),
    );

    final left = taeBottomRight.dx;
    final top = taeBottomRight.dy;

    final width = stoveTopCenter.dx - left;
    final height = stoveTopCenter.dy - top;
    if (width <= 0 || height <= 0) return const SizedBox.shrink();

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: height,
      child: IgnorePointer(
        child: SvgPicture.network(dragIndicator!, fit: BoxFit.fill),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    final topIngredientBarHeight = size.height * (isMobile ? 0.28 : 0.26);
    final stoveSectionHeight = size.height * 0.25;
    final ingredientSlotWidth = size.height * 0.30;
    final ingredientPadding = EdgeInsets.symmetric(
      horizontal: isMobile ? 10 : 12,
      vertical: isMobile ? 12 : 16,
    );
    return BlocProvider(
      create: (context) =>
          TutorialBloc()..add(TutorialEvent.started(widget.content)),
      child: BlocConsumer<TutorialBloc, TutorialState>(
        listenWhen: (previous, current) =>
            !previous.completionFeedbackReady &&
            current.completionFeedbackReady,
        listener: (context, state) {
          widget.onLessonCompleted?.call();
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.kBlue,
            body: state.showLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    key: _stackKey,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top ingredients
                          if (!state.teaReady)
                            Container(
                              height: topIngredientBarHeight,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: List.generate(
                                  state.ingredients.length,
                                  (index) => Flexible(
                                    child: SizedBox(
                                      width: ingredientSlotWidth,
                                      child: Stack(
                                        children: [
                                          Positioned.fill(
                                            child: Padding(
                                              padding: ingredientPadding,
                                              child: Draggable<Map<int, String>>(
                                                data: {
                                                  index:
                                                      state.ingredients[index],
                                                },
                                                feedback: SvgPicture.network(
                                                  state.ingredients[index],
                                                ),
                                                childWhenDragging:
                                                    SvgPicture.network(
                                                      state.ingredients[index],
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                            Colors.grey,
                                                            BlendMode.modulate,
                                                          ),
                                                    ),
                                                child: SizedBox(
                                                  child: Ingredient(
                                                    key: index == 0
                                                        ? _taePotKey
                                                        : null,
                                                    ingredient: state
                                                        .ingredients[index],
                                                    isSelected:
                                                        state.index == index,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          if (state.index > index &&
                                              state.checkIcon?.isNotEmpty ==
                                                  true)
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: SvgPicture.network(
                                                  state.checkIcon!,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Spacer(),
                          // Stove section
                          if (!state.showLeopardWithTea)
                            Center(
                              child: SizedBox(
                                height: stoveSectionHeight,
                                // decoration: BoxDecoration(color: Colors.orange),
                                child: SvgPicture.network(
                                  key: _stoveKey,
                                  state.stoveImage ?? '',
                                  height: stoveSectionHeight,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                        ],
                      ),

                      // Tea preparing section
                      if (!state.teaReady)
                        Positioned(
                          top: topIngredientBarHeight,
                          bottom: stoveSectionHeight,
                          left: 0,
                          right: 0,
                          child: DragTarget<Map<int, String>>(
                            onAcceptWithDetails: (dragTargetDetails) {
                              context.read<TutorialBloc>().add(
                                TutorialEvent.onDragAccept(
                                  dragTargetDetails.data.keys.first,
                                ),
                              );
                            },

                            builder: (context, candidateData, rejectedData) {
                              return SizedBox(
                                width: size.width * 0.3,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: state.draggedItemPath != null
                                      ? DraggedItem(
                                          index: state.index,
                                          draggedItem: state.draggedItemPath!,
                                        )
                                      : null,
                                ),
                              );
                            },
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
                      // Drag indicator
                      if (state.showDragIndicator)
                        buildIndicator(size, state.dragIndicator),
                      // Ingredient Text
                      if (state.droppedItem != null && !state.teaReady)
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: size.height * 0.09,
                          child: LabelDisplay.wordPopup(
                            nameNp: state.droppedItem!,
                            nameEn: '',
                          ),
                        ),
                      if (state.teaReady)
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: widget.onNext,
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                top: 100,
                                right: 100,
                                left: 100,
                              ),
                              child: CustomCachedImage(
                                imageUrl: isMobile
                                    ? state.leopardWithTeaMb ?? ''
                                    : state.leopardWithTeaTb ?? '',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
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
