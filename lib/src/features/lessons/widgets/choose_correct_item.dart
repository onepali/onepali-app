import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/src.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.nameEn,
    required this.nameNp,
    this.image,
    this.bgImage,
    this.isImageSvg = false,
    required this.size,
    required this.itemCount,
    required this.index,
    this.isSelected = false,
    this.onTap,
    this.isCorrect = false,
    this.bgColor,
  });

  final String nameEn;
  final String nameNp;
  final String? image;
  final bool isImageSvg;
  final String? bgImage; // PNG
  final bool isCorrect;
  final Size size;
  final int itemCount;
  final int index;
  final bool isSelected;
  final String? bgColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final cardWidth = (size.width * 0.75) / itemCount;
    final maxCardWidth = size.width * 0.25;
    final finalCardWidth = cardWidth > maxCardWidth ? maxCardWidth : cardWidth;
    final cardHeight = isMobile ? size.height * 0.6 : size.height * 0.50;
    final labelSectionHeight = cardHeight * 0.18;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: finalCardWidth,
        height: cardHeight,
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.hardEdge,
        padding: bgImage == null
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
            : null,
        decoration: BoxDecoration(
          color: colorFromHex(bgColor) ?? Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.kButtonGreen, width: 4)
              : null,
        ),
        child: bgImage != null
            ? CustomCachedImage(
                imageUrl: bgImage!,
                width: finalCardWidth,
                height: cardHeight,
                fit: BoxFit.cover,
              )
            : Column(
                children: [
                  SizedBox(
                    height: labelSectionHeight,
                    child: Center(
                      child: Text(
                        nameNp,
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontFamily: AppConstants.kMuktaFont,
                              fontSize: isMobile ? null : 40,
                            ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Center(
                          child: _buildItemImage(constraints: constraints),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: labelSectionHeight,
                    child: Center(
                      child: Text(
                        nameEn,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontSize: isMobile ? 20 : null),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildItemImage({required BoxConstraints constraints}) {
    if (image == null) {
      return const SizedBox.shrink();
    }

    final maxWidth = constraints.maxWidth;
    final maxHeight = constraints.maxHeight;

    if (isImageSvg) {
      return SvgPicture.network(
        image!,
        width: maxWidth,
        height: maxHeight,
        fit: BoxFit.contain,
      );
    }

    return CustomCachedImage(
      imageUrl: image!,
      width: maxWidth,
      height: maxHeight,
      fit: BoxFit.contain,
    );
  }
}
