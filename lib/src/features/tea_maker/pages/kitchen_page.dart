import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';
import 'package:onepali/src/features/tea_maker/bloc/tutorial_bloc.dart';
import 'package:onepali/src/features/tea_maker/widgets/bear_with_tea.dart';
import 'package:onepali/src/features/tea_maker/widgets/dragged_item.dart';
import 'package:onepali/src/features/tea_maker/widgets/huncha_button.dart';
import 'package:onepali/src/features/tea_maker/widgets/ingridient.dart';

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
            body: state.showLoading
                ? Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Top ingredients
                          if (!state.teaReady)
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
                                children: List.generate(
                                  state.ingredients.length,
                                  (index) => SizedBox(
                                    key: index == 0 ? _taePotKey : null,

                                    width: isMobile
                                        ? size.height * 0.3
                                        : size.height * 0.2,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 24,
                                            ),
                                            child: Draggable<Map<int, String>>(
                                              data: {
                                                index: state.ingredients[index],
                                              },
                                              feedback: SvgPicture.network(
                                                state.ingredients[index],
                                              ),
                                              onDragStarted: () {
                                                // On drag start
                                              },
                                              onDragEnd: (details) {
                                                // On drag end
                                              },
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
                                                child: Ingridient(
                                                  ingridient:
                                                      state.ingredients[index],
                                                  isSelected:
                                                      state.index == index,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        if (state.index > index)
                                          Positioned.fill(
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/tea_maker/svg/check.svg',
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
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
                                state.stoveImage ?? '',
                                height: size.height * 0.25,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Tea preparing section
                      if (!state.teaReady)
                        Positioned(
                          bottom: size.height * 0.25,
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
                                height: size.height * 0.50,
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
                      // Bear making announcement
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: BearWithTea(),
                      ),

                      // Huncha button in middle
                      Positioned(
                        bottom: size.height * 0.17,
                        right: 0,
                        left: 0,
                        child: HunchaButton(),
                      ),
                      // Drag indicator
                      if (state.showDragIndicator) buildIndicator(size),
                      // Ingredient Text
                      if (state.droppedItem != null && !state.teaReady)
                        Positioned(
                          right: 0,
                          left: 0,
                          bottom: size.height * 0.09,
                          child: LabelDisplay(
                            nameNp: state.droppedItem!,
                            nameEn: '',
                          ),
                        ),
                      if (state.teaReady)
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
                                    ? state.bearTakingTeaMb ?? ''
                                    : state.bearTakingTeaTb ?? '',
                              ),
                            ),
                          ),
                        ),
                      if (state.teaReady)
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
