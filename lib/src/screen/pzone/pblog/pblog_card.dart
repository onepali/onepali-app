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

    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            blog.coverImage,
            width: double.infinity,
            height: isMobilePortrait ? 200 : 350,
            imageType: CustomImageType.network,
          ),
          Gaps.verticalGapOf(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              blog.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style:
                  isMobilePortrait
                      ? AppStyles.text16PxSemiBold
                      : AppStyles.text20PxSemiBold,
            ),
          ),
          Gaps.verticalGapOf(5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              blog.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style:
                  isMobilePortrait
                      ? AppStyles.text14PxRegular.copyWith(
                        fontFamily: AppConstants.kDMSansFont,
                      )
                      : AppStyles.text16PxRegular.copyWith(
                        fontFamily: AppConstants.kDMSansFont,
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
