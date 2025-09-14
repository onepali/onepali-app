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
    return InkWell(
      onTap: isAdd ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: AppColors.kLightGrey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: ListTile(
          leading:
              isAdd
                  ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 28),
                  )
                  : CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        avatarUrl != null && avatarUrl!.isNotEmpty
                            ? NetworkImage(avatarUrl!)
                            : AssetImage(Assets.parentAvatar) as ImageProvider,
                  ),
          title: Text(
            title,
            style: AppStyles.text16PxMedium.copyWith(
              fontFamily: AppConstants.kDMSansFont,
            ),
          ),
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 0,
          trailing:
              !isAdd
                  ? IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.kLightGrey.withValues(
                        alpha: 0.3,
                      ),
                      shape: const CircleBorder(),
                    ),
                    icon: const Icon(Icons.edit, size: 22),
                    onPressed: onEdit,
                  )
                  : null,
        ),
      ),
    );
  }
}
