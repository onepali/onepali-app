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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMobile ? size.height * 0.6 : size.height * 0.50,
        margin: const EdgeInsets.all(8.0),
        clipBehavior: Clip.hardEdge,
        padding: bgImage == null
            ? const EdgeInsets.only(bottom: 8, top: 8)
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
                height: isMobile ? size.height * 0.6 : size.height * 0.50,
                fit: BoxFit.cover,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Nepali name at top
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      nameNp,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Image in the middle
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isImageSvg && image != null
                          ? SvgPicture.network(
                              image!,
                              width: finalCardWidth * 0.7,
                              fit: BoxFit.contain,
                            )
                          : image != null
                          ? CustomCachedImage(
                              imageUrl: image!,
                              width: finalCardWidth * 0.7,
                              fit: BoxFit.contain,
                            )
                          : SizedBox(width: finalCardWidth * 0.65),
                    ),
                  ),

                  // English name at bottom
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      nameEn,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
