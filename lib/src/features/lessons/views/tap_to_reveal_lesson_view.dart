import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';

class TapToRevealLessonView extends StatefulWidget {
  const TapToRevealLessonView({super.key, required this.lessonBloc});
  final LessonBloc lessonBloc;

  @override
  State<TapToRevealLessonView> createState() => _TapToRevealLessonViewState();
}

class _TapToRevealLessonViewState extends State<TapToRevealLessonView> {
  @override
  void initState() {
    super.initState();
    context.read<LessonBloc>().add(LessonEvent.playTapToReveal());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: widget.lessonBloc,
      child: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state.currentContent is! TapToRevealLessonContent) {
            return const SizedBox.shrink();
          }
          final items =
              (state.currentContent as TapToRevealLessonContent).items;
          if(state.completedTapToRevealItems.length == 2){
            log('Completed');
          }
          return Center(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Horizontal ListView for cards
                          SizedBox(
                            height: size.height * 0.5,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                final item = items[index];

                                return Badge.count(
                                  count:state.completedTapToRevealItems.contains(item) ? 1 : 0,
                                  
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          state.completedTapToRevealItems
                                              .contains(item)
                                          ? Colors.green
                                          : null,
                                      border:
                                          item == state.selectedTapToRevealItem
                                          ? Border.all(
                                              color: Colors.yellowAccent,
                                              width: 4,
                                            )
                                          : null,
                                    ),
                                    height: size.height * 0.1,
                                    width: size.width * 0.1,
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<LessonBloc>()
                                            .add(LessonEvent.tapToRevealItem(item));
                                      },
                                      child: CustomCachedImage(
                                        imageUrl: item.image,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ...items.map((item) {
                //   print("Size = ${size.width}, ${size.height}");
                //   return Positioned(
                //     top: item.dyRatio! * size.height,
                //     left: item.dxRatio! * size.width,
                //     child: ColoredBox(
                //       color: Colors.blueGrey,
                //       child: CustomCachedImage(
                //         imageUrl: item.image,
                //         height: 50,
                //         width: 50,
                //       ),
                //     ),
                //   );
                // }),
                Positioned(
                  top: size.height * 0.05,
                  right: size.width * 0.05,
                  child: SvgHelper.fromSource(path: Assets.wrong),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
