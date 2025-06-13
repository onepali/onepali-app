import 'package:flutter/material.dart';
import 'package:onepali/navigator_key.dart';
import 'package:onepali/src/src.dart';

class BottomSheetManager {
  static Future bottomModelSheet({
    String title = '',
    String subTitle = '',
    String? image,
    Widget? action,
  }) {
    BuildContext context = navigatorKey.currentContext!;
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      context: context,
      clipBehavior: Clip.antiAlias,
      builder:
          (context) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                start: 20,
                end: 20,
                bottom: 8,
                top: 8,
              ),
              child: Column(
                children: [
                  Container(
                    height: 5.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: AppColors.kPitchBlack.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2.5),
                      ),
                    ),
                  ),
                  Gaps.verticalGapOf(10),
                  Text(title, style: AppStyles.text16PxSemiBold),
                  Gaps.verticalGapOf(5),
                  Divider(color: AppColors.kPitchBlack.withValues(alpha: 0.07)),
                  LottieHelper.fromSource(
                    path: image ?? Assets.logoutLottie,

                    height: 120,
                    width: 120,
                  ),
                  Gaps.verticalGapOf(10),
                  if (subTitle.isNotEmpty)
                    Text(
                      subTitle,
                      style: AppStyles.text12PxMedium,
                      textAlign: TextAlign.center,
                    ),
                  if (subTitle.isNotEmpty) Gaps.verticalGapOf(10),
                  action ?? SizedBox.shrink(),
                  Gaps.verticalGapOf(10),
                ],
              ),
            ),
          ),
    );
  }

  static Future customBottomSheet(context, {String? title, Widget? child}) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      context: context,
      clipBehavior: Clip.antiAlias,
      builder:
          (context) => Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.kWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                start: 20,
                end: 20,
                bottom: 8,
                top: 8,
              ),
              child: Column(
                children: [
                  Container(
                    height: 5.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: AppColors.kPitchBlack.withValues(alpha: 0.3),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2.5),
                      ),
                    ),
                  ),
                  Gaps.verticalGapOf(10),
                  Text(title ?? '', style: AppStyles.text16PxSemiBold),
                  Gaps.verticalGapOf(5),
                  Divider(color: AppColors.kPitchBlack.withValues(alpha: 0.07)),
                  Gaps.verticalGapOf(10),
                  child ?? SizedBox.shrink(),
                ],
              ),
            ),
          ),
    );
  }
}
