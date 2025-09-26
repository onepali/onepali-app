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
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isTabletPortrait ? 500 : 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          // margin: EdgeInsets.symmetric(
          //   horizontal: isTabletPortrait ? 24 : 16,
          //   vertical: isTabletPortrait ? 24 : 16,
          // ),
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            borderRadius: BorderRadius.circular(isTabletPortrait ? 24 : 20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: EdgeInsets.only(top: isTabletPortrait ? 12 : 8),
                  height: isTabletPortrait ? 6.0 : 5.0,
                  width: isTabletPortrait ? 50.0 : 40.0,
                  decoration: BoxDecoration(
                    color: AppColors.kPitchBlack.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(isTabletPortrait ? 3.0 : 2.5),
                    ),
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTabletPortrait ? 28 : 20,
                      vertical: isTabletPortrait ? 16 : 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Gaps.verticalGapOf(isTabletPortrait ? 12 : 10),
                        Text(
                          title,
                          style: isTabletPortrait
                              ? AppStyles.text20PxSemiBold
                              : AppStyles.text16PxSemiBold,
                          textAlign: TextAlign.center,
                        ),
                        Gaps.verticalGapOf(isTabletPortrait ? 8 : 5),
                        Divider(
                          color: AppColors.kPitchBlack.withValues(alpha: 0.07),
                        ),
                        LottieHelper.fromSource(
                          path: image ?? Assets.logoutLottie,
                          height: isTabletPortrait ? 150 : 120,
                          width: isTabletPortrait ? 150 : 120,
                        ),
                        Gaps.verticalGapOf(isTabletPortrait ? 16 : 10),
                        if (subTitle.isNotEmpty)
                          Text(
                            subTitle,
                            style: isTabletPortrait
                                ? AppStyles.text16PxMedium
                                : AppStyles.text12PxMedium,
                            textAlign: TextAlign.center,
                          ),
                        if (subTitle.isNotEmpty)
                          Gaps.verticalGapOf(isTabletPortrait ? 16 : 10),

                        // Action buttons with proper spacing
                        if (action != null)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: isTabletPortrait ? 20 : 10,
                            ),
                            child: action,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Future customBottomSheet(context, {String? title, Widget? child}) {
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: AppColors.kTransparentColor,
      context: context,
      clipBehavior: Clip.antiAlias,
      builder: (context) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: isTabletPortrait ? 24 : 16,
          vertical: isTabletPortrait ? 24 : 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(isTabletPortrait ? 24 : 20),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: isTabletPortrait ? 12 : 8),
                height: isTabletPortrait ? 6.0 : 5.0,
                width: isTabletPortrait ? 50.0 : 40.0,
                decoration: BoxDecoration(
                  color: AppColors.kPitchBlack.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.all(
                    Radius.circular(isTabletPortrait ? 3.0 : 2.5),
                  ),
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTabletPortrait ? 28 : 20,
                    vertical: isTabletPortrait ? 16 : 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null && title.isNotEmpty) ...[
                        Gaps.verticalGapOf(isTabletPortrait ? 12 : 10),
                        Text(
                          title,
                          style: isTabletPortrait
                              ? AppStyles.text20PxSemiBold
                              : AppStyles.text16PxSemiBold,
                          textAlign: TextAlign.center,
                        ),
                        Gaps.verticalGapOf(isTabletPortrait ? 8 : 5),
                        Divider(
                          color: AppColors.kPitchBlack.withValues(alpha: 0.07),
                        ),
                      ],
                      Gaps.verticalGapOf(isTabletPortrait ? 16 : 10),
                      if (child != null)
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: isTabletPortrait ? 20 : 10,
                          ),
                          child: child,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
