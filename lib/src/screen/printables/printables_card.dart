import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PrintablesCard extends StatelessWidget {
  final PrintableModel printable;
  final VoidCallback onTap;

  const PrintablesCard({
    super.key,
    required this.printable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = PlatformUtility.isMobile(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double cardPadding = isMobile ? 16.0 : 20.0;
    final double cardBorderRadius = isMobile ? 12.0 : 16.0;
    final double imageSize = isMobile ? 60.0 : 120.0;
    final double horizontalGap = isMobile ? 12.0 : 16.0;
    final double verticalGap = isMobile ? 0.0 : 12.0;

    final TextStyle titleStyle = isMobile
        ? AppStyles.text16PxRegular.copyWith()
        : AppStyles.text20PxMedium;

    return customInkwell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(cardBorderRadius),
          border: Border.all(color: AppColors.kLightGrey, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            isMobile
                ? _buildMobileLayout(
                    cardPadding,
                    imageSize,
                    horizontalGap,
                    titleStyle,
                  )
                : _buildTabletLayout(
                    cardPadding,
                    imageSize,
                    verticalGap,
                    titleStyle,
                  ),
          ],
        ),
      ),
    );
  }

  // Mobile layout: Horizontal (image on right, text on left) - unchanged
  Widget _buildMobileLayout(
    double cardPadding,
    double imageSize,
    double horizontalGap,
    TextStyle titleStyle,
  ) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    printable.title,
                    style: titleStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.horizontalGapOf(horizontalGap),
                CustomImage(
                  printable.thumbnail,
                  height: imageSize,
                  width: imageSize,
                  cover: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tablet layout: Vertical (image on top, text below)
  Widget _buildTabletLayout(
    double cardPadding,
    double imageSize,
    double verticalGap,
    TextStyle titleStyle,
  ) {
    return Container(
      padding: EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image on top
          Center(
            child: CustomImage(
              printable.thumbnail,
              height: 150,
              width: double.infinity,
              cover: true,
            ),
          ),
          Gaps.verticalGapOf(verticalGap),
          // Title below
          Text(
            printable.title,
            style: titleStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
