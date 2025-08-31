import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onepali/src/src.dart';

class ErrorScreen extends StatefulWidget {
  final bool isInternetError;
  final bool isDataError;
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final bool isShowButton;
  const ErrorScreen({
    super.key,
    this.isInternetError = false,
    this.isDataError = true,
    this.title,
    this.message, 
    this.onRetry,
    this.isShowButton = true,
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    final isLandscape = PlatformUtility.isLandscape(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isMobile = PlatformUtility.isMobile(context);

    // Use isInternetError to control the error type
    final bool isInternetError = widget.isInternetError;
    // final bool isDataError = widget.isDataError && !isInternetError;
    Widget imageWidget;
    if (isInternetError) {
      imageWidget = LottieHelper.fromSource(
        path: Assets.noInternetLottie,
        type: LottieSourceType.asset,
        height: isTablet || isMobile ? 250 : 180,
        width: isTablet || isMobile ? 250 : 180,
        repeat: true,
        animate: true,
        fit: BoxFit.contain,
      );
    } else {
      imageWidget = SvgPicture.asset(
        Assets.dataSvg,
        height: isTablet || isMobile ? 250 : 180,
        width: isTablet || isMobile ? 250 : 180,
      );
    }

    Widget textContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            widget.title ??
                (isInternetError ? "You're offline" : 'No Data Available'),
            style: AppStyles.text22PxSemiBold.copyWith(color: AppColors.kBlack),
            textAlign: TextAlign.center,
          ),
        ),
        Gaps.verticalGapOf(10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            widget.message ??
                (isInternetError
                    ? 'Oops, please check your connection to get back online.'
                    : 'Please try again later.'),
            style: AppStyles.text14PxRegular.copyWith(color: AppColors.kGrey),
            textAlign: TextAlign.center,
          ),
        ),
        if (widget.isShowButton && !isLandscape) Gaps.verticalGapOf(20),
        if (widget.isShowButton && !isLandscape)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: CustomMaterialButton(
              label: 'Retry',
              elevation: 0,
              onTap: () {
                if (widget.onRetry != null) {
                  widget.onRetry!();
                }
              },
            ),
          ),
      ],
    );

    Widget errorContent;
    if (isLandscape && (isTablet || isMobile)) {
      errorContent = Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            imageWidget,
            Gaps.horizontalGapOf(40),
            Flexible(child: textContent),
          ],
        ),
      );
    } else {
      errorContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [imageWidget, Gaps.verticalGapOf(20), textContent],
        ),
      );
    }

    return Scaffold(backgroundColor: AppColors.kWhite, body: errorContent);
  }
}
