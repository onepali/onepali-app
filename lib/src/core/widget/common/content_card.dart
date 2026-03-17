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
  //PNG or JPG
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
        padding: const EdgeInsets.all(16),
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          image: bgImage != null
              ? DecorationImage(
                  image: NetworkImage(bgImage!),
                  fit: BoxFit.cover,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
          color: bgColor != null ? colorFromHex(bgColor!) : Colors.green,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            if (image != null)
              Expanded(
                child: isImageSvg
                    ? SvgPicture.network(
                        image!,
                        fit: BoxFit.contain,
                        placeholderBuilder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      )
                    : CustomCachedImage(imageUrl: image!, fit: BoxFit.contain),
              )
            else
              Expanded(child: SizedBox()),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.kBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                nameEn,
                style: AppStyles.text16PxMedium.copyWith(
                  fontSize: isTabletLandscape ? 24 : 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
