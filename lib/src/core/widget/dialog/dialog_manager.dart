import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class DialogManager {
  static showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    String image = '',
    bool isSvg = false,
    required Function onConfirm,
    String confirmButtonText = 'Confirm',
    bool barrierDismissible = true,
    bool hasSingleButton = false,
    Function? onCancel,
  }) {
    var isMobileLandScape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);
    var isMobilePortrait =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isPortrait(context);

    // Set your desired max width here
    double dialogMaxWidth =
        isMobileLandScape
            ? MediaQuery.of(context).size.width * 0.7
            : isMobilePortrait
            ? MediaQuery.of(context).size.width * 1.2
            : MediaQuery.of(context).size.width * 0.6;

    return showDialog(
      context: context,
      routeSettings: const RouteSettings(name: AppConstants.customDialogModal),
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: dialogMaxWidth),
            child: AlertDialog(
              title: Text(
                title,
                style:
                    isMobileLandScape
                        ? AppStyles.text16PxSemiBold
                        : isMobilePortrait
                        ? AppStyles.text18PxSemiBold
                        : AppStyles.text20PxSemiBold,
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.symmetric(
                horizontal:
                    isMobileLandScape
                        ? 24
                        : isMobilePortrait
                        ? 16
                        : 32,
                vertical:
                    isMobileLandScape
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
                      height:
                          isMobileLandScape
                              ? 100
                              : isMobilePortrait
                              ? 120
                              : 150,
                      width:
                          isMobileLandScape
                              ? 100
                              : isMobilePortrait
                              ? 120
                              : 150,
                    ),
                  if (image.isNotEmpty && isSvg)
                    SvgHelper.fromSource(
                      path: image,
                      height: isMobilePortrait ? 120 : 150,
                      width: isMobilePortrait ? 120 : 150,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      content,
                      style:
                          isMobileLandScape
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
                              Navigator.of(context).pop();
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

  timesUpDialog(BuildContext context) {
    return showCustomDialog(
      context: context,
      title: 'Time\'s Up',
      content: 'Comeback Tomorrow to continue your learning journey!',
      image: Assets.timeUpSvg,
      isSvg: true,
      onConfirm: () {
        Navigator.of(context).pop();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.parentPinScreen,
          (route) => false,
        );
      },
      confirmButtonText: 'Ok',
      barrierDismissible: false,
      hasSingleButton: true,
    );
  }
}
