import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
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
    final isMobile = PlatformUtility.isMobile(context);
    return BlocConsumer<TapToPopBloc, TapToPopState>(
      listener: (context, state) async {},
      builder: (context, state) {
        if (state.content == null) {
          return const Center(child: Text('No content found'));
        }
        if (state.completed) {
          final correctItem = state.content!.items.firstWhere(
            (item) => item.isCorrect,
            orElse: () => state.content!.items.first,
          );

          return Stack(
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
                    return CustomCachedImage(
                      imageUrl: content.successImage ?? correctItem.image,
                      height: size.height * 0.4,
                      width: size.height * 0.4,
                    );
                  },
                ),
              ),
              Center(
                child: LottieBuilder.asset(
                  Assets.starWinnerLottie,
                  repeat: true,
                ),
              ),
              TopRightPositionedCloseButton(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              CenterRightAlignedForwardButton(
                onTap: () async {
                  context.read<LessonBloc>().add(LessonEvent.nextContent());
                },
              ),
            ],
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
                top: (item.dyRatio ?? 0.5) * size.height,
                left: (item.dxRatio ?? 0.5) * size.width,
                child: item.isCorrect
                    ? Transform.scale(
                        scale: isMobile
                            ? item.sizeMb.toDouble()
                            : item.sizeTb.toDouble(),
                        child: PopScaleOnTap(
                          key: ValueKey(item.order.toString()),
                          onTap: state.instructionAudioPlayed
                              ? () {
                                  context.read<TapToPopBloc>().add(
                                    TapToPopEvent.tapItem(item),
                                  );
                                }
                              : null,
                          child: SvgPicture.network(item.image),
                        ),
                      )
                    : Transform.scale(
                        scale: isMobile
                            ? item.sizeMb.toDouble()
                            : item.sizeTb.toDouble(),
                        child: ShakeWidget(
                          key: ValueKey(item.order.toString()),
                          onTap: state.instructionAudioPlayed
                              ? () {
                                  context.read<TapToPopBloc>().add(
                                    TapToPopEvent.tapItem(item),
                                  );
                                }
                              : null,
                          child: SvgPicture.network(item.image),
                        ),
                      ),
              ),

            TopRightPositionedCloseButton(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
