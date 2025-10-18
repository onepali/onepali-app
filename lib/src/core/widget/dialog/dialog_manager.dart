import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class DialogManager {
  static showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    String image = '',
    bool isSvg = false,
    required VoidCallback onConfirm,
    String confirmButtonText = 'Confirm',
    bool barrierDismissible = true,
    bool hasSingleButton = false,
    Function? onCancel,
    bool isCross = false,
  }) {
    var isMobileLandScape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    var isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    // Set your desired max width here
    double dialogMaxWidth = isMobileLandScape
        ? MediaQuery.of(context).size.width * 0.7
        : isMobilePortrait
        ? MediaQuery.of(context).size.width * 1.2
        : MediaQuery.of(context).size.width * 1.5;

    return showDialog(
      context: context,
      routeSettings: const RouteSettings(name: AppConstants.customDialogModal),
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogMaxWidth),
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: isCross
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: isMobileLandScape
                          ? AppStyles.text16PxSemiBold
                          : isMobilePortrait
                          ? AppStyles.text18PxSemiBold
                          : AppStyles.text20PxSemiBold,
                      textAlign: isCross ? TextAlign.start : TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  if (isCross)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppColors.kPitchBlack,
                      ),

                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                ],
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobileLandScape
                    ? 24
                    : isMobilePortrait
                    ? 16
                    : 32,
                vertical: isMobileLandScape
                    ? 10
                    : isMobilePortrait
                    ? 14
                    : 20,
              ),
              actionsAlignment: MainAxisAlignment.center,

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image.isNotEmpty && !isSvg)
                    Image.asset(
                      image,
                      height: isMobileLandScape
                          ? 100
                          : isMobilePortrait
                          ? 120
                          : 150,
                      width: isMobileLandScape
                          ? 100
                          : isMobilePortrait
                          ? 120
                          : 150,
                    ),
                  if (image.isNotEmpty && isSvg)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isCross ? 0.0 : 16.0,
                        vertical: isCross ? 0.0 : 16.0,
                      ),
                      child: SvgHelper.fromSource(
                        path: image,
                        height: isMobileLandScape
                            ? 100
                            : isMobilePortrait
                            ? 120
                            : 150,
                        width: isMobileLandScape
                            ? 100
                            : isMobilePortrait
                            ? 120
                            : 150,
                      ),
                    ),
                  if (content.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        content,
                        style: isMobileLandScape
                            ? AppStyles.text14PxRegular
                            : isMobilePortrait
                            ? AppStyles.text14PxRegular
                            : AppStyles.text16PxRegular,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (image.isEmpty)
                    Gaps.verticalGapOf(
                      isMobileLandScape
                          ? 30
                          : isMobilePortrait
                          ? 14
                          : 20,
                    ),
                ],
              ),
              actions: [
                !isMobilePortrait
                    ? Row(
                        children: [
                          if (!hasSingleButton)
                            Expanded(
                              child: CustomMaterialButton(
                                onTap: () {
                                  onCancel?.call();
                                  Navigator.of(context).pop();
                                },
                                textStyle: AppStyles.text14PxMedium,
                                label: 'Cancel',
                                backgroundColor: AppColors.kButtonGrey,
                                elevation: 0,
                                height: 35,
                              ),
                            ),
                          if (!hasSingleButton) Gaps.horizontalGapOf(15),
                          Expanded(
                            child: CustomMaterialButton(
                              onTap: () {
                                onConfirm();
                                // Navigator.of(context).pop();
                              },
                              textStyle: AppStyles.text14PxMedium,
                              label: confirmButtonText,
                              height: 35,
                              width: double.infinity,
                              elevation: 0,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomMaterialButton(
                            onTap: () {
                              onConfirm();
                              Navigator.of(context).pop();
                            },
                            textStyle: AppStyles.text14PxMedium,
                            label: confirmButtonText,
                            height: 40,
                            width: double.infinity,
                            elevation: 0,
                          ),
                          if (!hasSingleButton) Gaps.verticalGapOf(10),
                          if (!hasSingleButton)
                            CustomMaterialButton(
                              onTap: () {
                                onCancel?.call();
                                Navigator.of(context).pop();
                              },
                              textStyle: AppStyles.text14PxMedium,
                              label: 'Cancel',
                              backgroundColor: AppColors.kButtonGrey,
                              elevation: 0,
                              height: 40,
                            ),
                        ],
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
