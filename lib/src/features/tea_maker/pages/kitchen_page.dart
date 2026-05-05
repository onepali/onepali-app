import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/widgets/label_display.dart';
import 'package:onepali/src/features/tea_maker/bloc/tutorial_bloc.dart';
import 'package:onepali/src/features/tea_maker/widgets/bear_with_tea.dart';
import 'package:onepali/src/features/tea_maker/widgets/dragged_item.dart';
import 'package:onepali/src/features/tea_maker/widgets/huncha_button.dart';
import 'package:onepali/src/features/tea_maker/widgets/ingridient.dart';

class KitchenPage extends StatefulWidget {
  const KitchenPage({super.key});

  @override
  State<KitchenPage> createState() => _KitchenPageState();
}

class _KitchenPageState extends State<KitchenPage> {
  final GlobalKey _taePotKey = GlobalKey();
  final GlobalKey _stoveKey = GlobalKey();

  Widget buildIndicator(Size size) {
    final taeBox = _taePotKey.currentContext!.findRenderObject() as RenderBox;
    final stoveBox = _stoveKey.currentContext!.findRenderObject() as RenderBox;

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
    _taePotKey.currentState?.dispose();
    _stoveKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = PlatformUtility.isMobile(context);
    return BlocProvider(
      create: (context) => TutorialBloc()..add(TutorialEvent.started()),
      child: BlocBuilder<TutorialBloc, TutorialState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Stack(
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
                          color: Color(0xFF007D28),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        horizontal: 24,
                                        vertical: 24,
                                      ),
                                      child: Draggable<Map<int, String>>(
                                        data: {index: state.ingredients[index]},
                                        feedback: SvgPicture.asset(
                                          state.ingredients[index],
                                        ),
                                        onDragStarted: () {
                                          // On drag start
                                        },
                                        onDragEnd: (details) {
                                          // On drag end
                                        },
                                        childWhenDragging: SvgPicture.asset(
                                          state.ingredients[index],
                                          colorFilter: ColorFilter.mode(
                                            Colors.grey,
                                            BlendMode.modulate,
                                          ),
                                        ),
                                        child: SizedBox(
                                          child: Ingridient(
                                            ingridient:
                                                state.ingredients[index],
                                            isSelected: state.index == index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  if (state.index > index)
                                    Positioned.fill(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
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
                        child: SvgPicture.asset(
                          key: _stoveKey,
                          'assets/tea_maker/svg/stove.svg',
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
                Align(alignment: Alignment.bottomCenter, child: BearWithTea()),

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
                  // Positioned(
                  //   right: 0,
                  //   left: 0,
                  //   bottom: size.height * 0.09,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         padding: const EdgeInsets.symmetric(
                  //           horizontal: 20,
                  //           vertical: 8,
                  //         ),
                  //         decoration: BoxDecoration(
                  //           color: Color(0xFF003893),
                  //           borderRadius: BorderRadius.circular(50),
                  //         ),
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           state.droppedItem!,
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 40,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Positioned(
                    right: 0,
                    left: 0,
                    bottom: size.height * 0.09,
                    child: LabelDisplay(nameNp: state.droppedItem!, nameEn: ''),
                  ),
                if (state.teaReady)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: SvgPicture.asset(
                        'assets/tea_maker/svg/bear_taking_tea.svg',
                      ),
                    ),
                  ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgHelper.fromSource(
                      path: Assets.wrong,
                      type: SvgSourceType.asset,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
