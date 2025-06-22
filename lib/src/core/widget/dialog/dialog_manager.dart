import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class DialogManager {
  static showCustomDialog({
    required BuildContext context,
    required String title,
    required String content,
    String image = '',
    required Function onConfirm,
    String confirmButtonText = 'Confirm',
    Function? onCancel,
  }) {
    var isMobileLandScape =
        PlatformUtility.isMobile(context) &&
        PlatformUtility.isLandscape(context);

    // Set your desired max width here
    double dialogMaxWidth =
        isMobileLandScape
            ? MediaQuery.of(context).size.width * 0.7
            : MediaQuery.of(context).size.width * 0.6;

    return showDialog(
      context: context,
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
                        : AppStyles.text20PxSemiBold,
                textAlign: TextAlign.center,
              ),
              alignment: Alignment.center,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobileLandScape ? 24 : 32, // Only left & right
                vertical: isMobileLandScape ? 10 : 20,
              ),
              actionsAlignment: MainAxisAlignment.center,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (image.isNotEmpty)
                    Image.asset(
                      image,
                      height: isMobileLandScape ? 100 : 150,
                      width: isMobileLandScape ? 100 : 150,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      content,
                      style:
                          isMobileLandScape
                              ? AppStyles.text16PxRegular
                              : AppStyles.text18PxRegular,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (image.isEmpty)
                    Gaps.verticalGapOf(isMobileLandScape ? 10 : 20),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomTextButton(
                        onPressed: () {
                          onCancel?.call();
                          Navigator.of(context).pop();
                        },
                        text: 'Cancel',
                      ),
                    ),
                    Gaps.horizontalGapOf(15),
                    Expanded(
                      child: CustomMaterialButton(
                        onTap: () {
                          onConfirm();
                          Navigator.of(context).pop();
                        },
                        elevation: 0,
                        label: confirmButtonText,
                      ),
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
