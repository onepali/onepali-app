import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/src.dart';

Future<bool?> showCreateChildProfileDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      final isMobile = PlatformUtility.isMobile(context);
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 48,
                vertical: isMobile ? 24 : 48,
              ),
              width: isMobile ? 400 : 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gaps.verticalGapOf(isMobile ? 20 : 40),
                  Text(
                    "Would you like to personalize your child's learning?",
                    textAlign: TextAlign.center,
                    style: isMobile
                        ? AppStyles.text18PxMedium
                        : AppStyles.text32PxMedium,
                  ),
                  Gaps.verticalGapOf(isMobile ? 20 : 40),
                  Expanded(
                    child: SvgHelper.fromSource(
                      path: Assets.rocket,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Gaps.verticalGapOf(isMobile ? 20 : 40),
                  CustomMaterialButton(
                    height: isMobile ? 40 : 60,
                    onTap: () {
                      Navigator.of(context).pop(true);
                    },
                    label: "Create child's Profile",
                    textStyle: isMobile
                        ? AppStyles.text16PxMedium
                        : AppStyles.text24PxMedium,
                  ),
                ],
              ),
            ),
            Positioned(
              top: isMobile ? 12 : 16,
              right: isMobile ? 12 : 16,
              child: CustomCloseButton(
                onTap: () {
                  Navigator.of(context).pop(false);
                },
                iconPath: Assets.closeGreyIcon,
              ),
            ),
          ],
        ),
      );
    },
  );
}
