import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PSettingCard extends StatelessWidget {
  final String title;
  final String? avatarUrl;
  final bool isAdd;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  const PSettingCard({
    super.key,
    required this.title,
    this.avatarUrl,
    this.isAdd = false,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    TextStyle textStyle = isMobilePortrait
        ? AppStyles.text16PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text24PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          );
    logger.d('PSettingCard build--> ${Dimensions.kSettingAvatarSize(context)}');
    return InkWell(
      onTap: isAdd ? onTap : null,
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isAdd ? null : AppColors.kLightGrey.withValues(alpha: 0.2),
          borderRadius: isAdd ? null : BorderRadius.circular(30.0),
        ),
        height: Dimensions.kSettingAvatarSize(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading (icon or image)
            isAdd
                ? Container(
                    width: Dimensions.kSettingAvatarSize(context),
                    height: Dimensions.kSettingAvatarSize(context),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      size: Dimensions.kSettingAvatarSize(context) - 26,
                    ),
                  )
                : CustomImage(
                    avatarUrl != null && avatarUrl!.isNotEmpty
                        ? avatarUrl!
                        : Assets.parentAvatar,
                    height: Dimensions.kSettingAvatarSize(context),
                    width: Dimensions.kSettingAvatarSize(context),
                    circular: true,
                    imageType: avatarUrl != null && avatarUrl!.isNotEmpty
                        ? CustomImageType.network
                        : CustomImageType.local,
                  ),
            const SizedBox(width: 16),
            // Title
            Flexible(
              fit: FlexFit.tight,
              child: Text(
                title,
                style: textStyle,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 16),
            // Trailing (edit icon)
            if (!isAdd)
              IconButton(
                iconSize: Dimensions.kSettingAvatarSize(context),
                alignment: Alignment.center,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.kLightGrey.withValues(alpha: 0.3),
                  shape: const CircleBorder(),
                ),
                icon: Icon(
                  Icons.edit,
                  size: Dimensions.kSettingAvatarSize(context) - 26,
                ),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
