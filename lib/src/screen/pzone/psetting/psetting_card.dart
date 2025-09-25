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
        child: ListTile(
          leading: isAdd
              ? Container(
                  width: Dimensions.kSettingAvatarSize(context),
                  height: Dimensions.kSettingAvatarSize(context),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
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
          title: Text(title, style: textStyle),
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          trailing: !isAdd
              ? IconButton(
                  iconSize: Dimensions.kSettingAvatarSize(context),

                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.kLightGrey.withValues(
                      alpha: 0.3,
                    ),
                    shape: const CircleBorder(),
                  ),
                  icon: Icon(
                    Icons.edit,
                    size: Dimensions.kSettingAvatarSize(context) - 26,
                  ),
                  onPressed: onEdit,
                )
              : null,
        ),
      ),
    );
  }
}
