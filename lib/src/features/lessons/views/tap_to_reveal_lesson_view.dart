import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/views/choose_correct_lesson_view.dart';

class TapToRevealLessonView extends StatelessWidget {
  const TapToRevealLessonView({super.key, required this.lessonBloc});
  final LessonBloc lessonBloc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider.value(
      value: lessonBloc,
      child: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state.currentContent is! TapToRevealLessonContent) {
            return const Placeholder();
          }
          final items =
              (state.currentContent as TapToRevealLessonContent).items;
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
                                return ItemCard(
                                  item: item,
                                  size: size,
                                  itemCount: items.length,
                                  index: index,
                                  isSelected:
                                      item ==
                                      context
                                          .watch<LessonBloc>()
                                          .state
                                          .userSelectedItem,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

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
