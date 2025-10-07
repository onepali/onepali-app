import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class PBlogCard extends StatelessWidget {
  final PzBlogModel blog;
  final VoidCallback? onTap;
  const PBlogCard({super.key, required this.blog, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double imageHeight = isMobile ? (isMobilePortrait ? 200 : 350) : 550;
    final double horizontalPadding = isMobile ? 18.0 : 60.0;
    final double verticalGap1 = isMobile ? 10 : 16;
    final double verticalGap2 = isMobile ? 5 : 8;

    final TextStyle titleStyle = isMobile
        ? (isMobilePortrait
              ? AppStyles.text16PxSemiBold
              : AppStyles.text20PxSemiBold)
        : AppStyles.text24PxBold;

    final TextStyle contentStyle = isMobile
        ? AppStyles.text16PxRegular.copyWith(
            height: 1.5,
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text18PxRegular.copyWith(
            height: 1.6,
            fontFamily: AppConstants.kDMSansFont,
          );

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            blog.coverImage,
            width: double.infinity,
            height: imageHeight,
            imageType: CustomImageType.network,
          ),
          Gaps.verticalGapOf(verticalGap1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              blog.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          ),
          Gaps.verticalGapOf(verticalGap2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Text(
              blog.content,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: contentStyle,
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
