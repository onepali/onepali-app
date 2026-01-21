
import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/features/lessons/blocs/lession_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:provider/provider.dart';

class ChooseCorrectLessonView extends StatefulWidget {
  const ChooseCorrectLessonView({super.key, required this.lessonInformation});
  final ChooseCorrectLessonContent lessonInformation;

  @override
  State<ChooseCorrectLessonView> createState() =>
      _ChooseCorrectLessonViewState();
}

class _ChooseCorrectLessonViewState extends State<ChooseCorrectLessonView> {
  @override
  void initState() {
    super.initState();
    context.read<LessonBloc>().add(LessonEvent.playChooseCorrectItem());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCorrect =
        context.watch<LessonBloc>().state.userSelectedItem ==
            context.watch<LessonBloc>().state.itemQuestioned
        ? true
        : false;

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
                        itemCount: widget.lessonInformation.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.lessonInformation.items[index];
                          return ItemCard(
                            item: item,
                            size: size,
                            itemCount: widget.lessonInformation.items.length,
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
                    // Confirm button directly below the list
                    SizedBox(height: size.height * 0.04),
                    Visibility(
                      visible:
                          context.watch<LessonBloc>().state.userSelectedItem !=
                          null,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: SizedBox(
                        width: size.width * 0.2, // or any fixed width you want
                        child: ElevatedButton(
                          onPressed: () {
                            if(isCorrect){
                              context
                                  .read<LessonBloc>()
                                  .add(LessonEvent.nextContent());
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: isCorrect
                                ? AppColors.kButtonGreen
                                : AppColors.kButtonRed,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: !isCorrect
                              ? Text(
                                  "Try again",
                                  style: AppStyles.text20PxBold.copyWith(
                                    color: AppColors.kBlack,
                                  ),
                                )
                              : Icon(
                                  Icons.check,
                                  size: 32,
                                  color: AppColors.kBlack,
                                ),
                        ),
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
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SvgHelper.fromSource(path: Assets.wrong)),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.size,
    required this.itemCount,
    required this.index,
    this.isSelected = false,
  });

  final Item item;
  final Size size;
  final int itemCount;
  final int index;
  final bool isSelected;

  // Get color based on index
  Color _getCardColor() {
    final colors = [
      Colors.orange.shade300,
      Colors.green.shade700,
      Colors.blue.shade400,
      Colors.purple.shade400,
      Colors.red.shade400,
      Colors.teal.shade400,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = (size.width * 0.75) / itemCount;
    final maxCardWidth = size.width * 0.25;
    final finalCardWidth = cardWidth > maxCardWidth ? maxCardWidth : cardWidth;

    return Container(
      width: finalCardWidth,
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.015),
      child: GestureDetector(
        onTap: () {
          context.read<LessonBloc>().add(LessonEvent.chooseItem(item));
        },
        child: Container(
          decoration: BoxDecoration(
            color: _getCardColor(),
            borderRadius: BorderRadius.circular(20),
            border: isSelected
                ? Border.all(color: Colors.yellowAccent, width: 4)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Nepali name at top
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item.nameNp,
                  style: TextStyle(
                    fontSize: finalCardWidth * 0.12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Image in the middle
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomCachedImage(
                    imageUrl: item.image,
                    width: finalCardWidth * 0.7,
                  ),
                ),
              ),

              // English name at bottom
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  item.nameEn,
                  style: TextStyle(
                    fontSize: finalCardWidth * 0.1,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
