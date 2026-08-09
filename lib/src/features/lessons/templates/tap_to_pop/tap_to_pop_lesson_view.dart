import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return BlocBuilder<TapToPopBloc, TapToPopState>(
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
                  tween: Tween(begin: 0.8, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: _buildMedia(
                        content.successImage ?? correctItem.image,
                        height: size.height * 0.4,
                        width: size.height * 0.4,
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: SizedBox.square(
                  dimension: size.shortestSide * 0.65,
                  child: LottieBuilder.asset(
                    Assets.successLottie1,
                    repeat: false,
                  ),
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
            for (var index = 0; index < items.length; index++)
              if (!items[index].isCorrect ||
                  _containsIdenticalItem(state.correctItems!, items[index]))
                _buildPositionedItem(
                  context: context,
                  item: items[index],
                  itemKey: ValueKey('tap_to_pop_${content.id}_$index'),
                  size: size,
                  isMobile: isMobile,
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

  Widget _buildPositionedItem({
    required BuildContext context,
    required Item item,
    required Key itemKey,
    required Size size,
    required bool isMobile,
  }) {
    return Positioned(
      key: itemKey,
      top: (item.dyRatio ?? 0.5) * size.height,
      left: (item.dxRatio ?? 0.5) * size.width,
      child: item.isCorrect
          ? Transform.scale(
              scale: isMobile ? item.sizeMb.toDouble() : item.sizeTb.toDouble(),
              child: PopScaleOnTap(
                onTap: () {
                  MetricsTrackingHelper.trackAnswerAttempt(
                    context: context,
                    isCorrect: true,
                  );
                  context.read<TapToPopBloc>().add(TapToPopEvent.tapItem(item));
                },
                child: _buildItemImage(item),
              ),
            )
          : Transform.scale(
              scale: isMobile ? item.sizeMb.toDouble() : item.sizeTb.toDouble(),
              child: ShakeWidget(
                onTap: () {
                  MetricsTrackingHelper.trackAnswerAttempt(
                    context: context,
                    isCorrect: false,
                  );
                  context.read<TapToPopBloc>().add(TapToPopEvent.tapItem(item));
                },
                child: _buildItemImage(item),
              ),
            ),
    );
  }

  Widget _buildItemImage(Item item) =>
      _buildMedia(item.image, isSvg: item.isImageSvg);

  Widget _buildMedia(
    String imageUrl, {
    bool isSvg = false,
    double? height,
    double? width,
  }) {
    if (isSvg || _isSvgUrl(imageUrl)) {
      return SvgPicture.network(imageUrl, height: height, width: width);
    }

    return CustomCachedImage(imageUrl: imageUrl, height: height, width: width);
  }

  bool _isSvgUrl(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    return path.endsWith('.svg');
  }

  bool _containsIdenticalItem(List<Item> items, Item target) =>
      items.any((item) => identical(item, target));
}
