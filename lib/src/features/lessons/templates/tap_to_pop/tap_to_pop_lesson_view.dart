import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/pop_scale_widget.dart';
import 'package:onepali/src/core/widget/shake_widget.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_pop/tap_to_pop_bloc/tap_to_pop_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/src.dart';

class TapToPopLessonView extends StatelessWidget {
  const TapToPopLessonView({super.key, required this.content});
  final TapToPopLessonContent content;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<TapToPopBloc, TapToPopState>(
      listener: (context, state) async {
        if (state.completed) {
          // show snackbar
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Completed')));
        }
      },
      builder: (context, state) {
        if (state.content == null) {
          return const Center(child: Text('No content found'));
        }
        if (state.completed) {
          final correctItem = state.content!.items.firstWhere(
            (item) => item.isCorrect,
            orElse: () => state.content!.items.first,
          );

          return GestureDetector(
            onTap: () async {
              context.read<LessonBloc>().add(LessonEvent.nextContent());
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: colorFromHex(content.bgColor) ?? Colors.green,
                  ),
                ),
                Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 2),
                    curve: Curves.elasticOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale * 4,
                        child: CustomCachedImage(imageUrl: correctItem.image),
                      );
                    },
                  ),
                ),
                Center(
                  child: LottieBuilder.asset(
                    Assets.successLottie1,
                    repeat: false,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SvgHelper.fromSource(path: Assets.wrong),
                  ),
                ),
              ],
            ),
          );
        }
        final items = state.content!.items;
        return Stack(
          children: [
            if (content.bgImage != null)
              Positioned.fill(
                child: CustomCachedImage(
                  imageUrl: content.bgImage!,
                  fit: BoxFit.cover,
                ),
              ),
            for (final item in items)
              Positioned(
                top: (item.dxRatio ?? 0.5) * size.height,
                left: (item.dyRatio ?? 0.5) * size.width,
                child: state.correctItems!.contains(item)
                    ? Transform.scale(
                        scale: 1.1,
                        child: PopScaleOnTap(
                          onTap: () {
                            context.read<TapToPopBloc>().add(
                              TapToPopEvent.tapItem(item),
                            );
                          },
                          child: CustomCachedImage(imageUrl: item.image),
                        ),
                      )
                    : ShakeWidget(
                        onTap: () {
                          context.read<TapToPopBloc>().add(
                            TapToPopEvent.tapItem(item),
                          );
                        },
                        child: CustomCachedImage(imageUrl: item.image),
                      ),
              ),

            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgHelper.fromSource(path: Assets.wrong),
              ),
            ),
          ],
        );
      },
    );
  }
}
