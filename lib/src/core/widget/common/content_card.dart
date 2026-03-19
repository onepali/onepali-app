import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/utils/color_from_hex.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';


class ContentCard extends StatelessWidget {
  final String nameEn;
  final String nameNp;
  final VoidCallback onTap;
  final String? image;
  final bool isImageSvg;
  final String? bgColor;
  final String? bgImage;

  const ContentCard({
    super.key,
    required this.nameEn,
    required this.nameNp,
    required this.onTap,
    this.image,
    this.isImageSvg = false,
    this.bgColor,
    this.bgImage,
  });

  @override
  Widget build(BuildContext context) {
    bool isTabletLandscape =
        PlatformUtility.isTablet(context) &&
        PlatformUtility.isLandscape(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor != null
              ? colorFromHex(bgColor!)
              : AppColors.kButtonGreen,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              if (bgImage != null)
                Positioned.fill(
                  child: CustomCachedImage(
                    imageUrl: bgImage!,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset(
                      Assets.placeholder,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    if (image != null)
                      Expanded(
                        child: isImageSvg
                            ? SvgPicture.network(
                                image!,
                                fit: BoxFit.contain,
                                placeholderBuilder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : CustomCachedImage(
                                imageUrl: image!,
                                fit: BoxFit.contain,
                              ),
                      )
                    else
                      const Expanded(child: SizedBox()),
                    const SizedBox(height: 32),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kWhite,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          nameEn,
                          maxLines: 1,
                          style: AppStyles.text16PxMedium.copyWith(
                            fontSize: isTabletLandscape ? 24 : 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
