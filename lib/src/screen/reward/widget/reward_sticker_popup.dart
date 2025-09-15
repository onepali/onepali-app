import 'package:flutter/material.dart';

import '../../../src.dart';

class RewardStickerPopup extends StatelessWidget {
  final RewardModel reward;

  const RewardStickerPopup({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isTabletLandscape = isTablet && PlatformUtility.isLandscape(context);

    // Responsive values
    final double dialogWidth = _getDialogWidth(
      isMobileLandscape,
      isTabletLandscape,
    );
    final double dialogHeight = _getDialogHeight(
      isMobileLandscape,
      isTabletLandscape,
    );
    final double titleFontSize = _getTitleFontSize(
      isMobileLandscape,
      isTabletLandscape,
    );
    final double subtitleFontSize = _getSubtitleFontSize(
      isMobileLandscape,
      isTabletLandscape,
    );
    final double descriptionFontSize = _getDescriptionFontSize(
      isMobileLandscape,
      isTabletLandscape,
    );
    final double imageSize = _getImageSize(
      isMobileLandscape,
      isTabletLandscape,
    );

    final double padding = _getPadding(isMobileLandscape, isTabletLandscape);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: dialogWidth,
        height: dialogHeight,
        decoration: BoxDecoration(
          color: AppColors.kWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Close button
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width:
                      isMobileLandscape
                          ? AppConstants.kIconSize
                          : AppConstants.kIconSize + AppConstants.kIconSize,
                  height:
                      isMobileLandscape
                          ? AppConstants.kIconSize
                          : AppConstants.kIconSize + AppConstants.kIconSize,
                  decoration: BoxDecoration(
                    color: AppColors.kLightGrey.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: SvgHelper.fromSource(
                    path: Assets.wrong,
                    height:
                        isMobileLandscape
                            ? AppConstants.kIconSize
                            : AppConstants.kIconSize + AppConstants.kIconSize,
                    width:
                        isMobileLandscape
                            ? AppConstants.kIconSize
                            : AppConstants.kIconSize + AppConstants.kIconSize,
                  ),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(padding),
              child: _buildLandscapeContent(
                titleFontSize,
                subtitleFontSize,
                descriptionFontSize,
                imageSize,
                padding,
                isMobileLandscape,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeContent(
    double titleFontSize,
    double subtitleFontSize,
    double descriptionFontSize,
    double imageSize,
    double padding,
    bool isMobileLandscape,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left side - Text content
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with audio button
              Row(
                children: [
                  Text(
                    reward.titleNp,
                    style: AppStyles.text35PxBold.copyWith(
                      fontSize: titleFontSize,
                      fontFamily: AppConstants.kMuktaFont,
                    ),
                  ),
                  Gaps.horizontalGapOf(8),
                  if (reward.sAudio.isNotEmpty)
                    IconButton(
                      onPressed: () => _playAudio(),
                      icon: SvgHelper.fromSource(
                        path: Assets.sound,
                        height:
                            isMobileLandscape
                                ? AppConstants.kIconSize - 10
                                : AppConstants.kIconSize +
                                    AppConstants.kIconSize,
                        width:
                            isMobileLandscape
                                ? AppConstants.kIconSize - 10
                                : AppConstants.kIconSize +
                                    AppConstants.kIconSize,
                      ),
                    ),
                ],
              ),
              Gaps.verticalGapOf(isMobileLandscape ? 30 : 50),
              // English subtitle
              Text(
                reward.titleEn,
                style: AppStyles.text30PxSemiBold.copyWith(
                  fontSize: subtitleFontSize,
                ),
              ),
              Gaps.verticalGapOf(12),
              // Description
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Text(
                  reward.descriptionEn,
                  style: AppStyles.text22PxRegular.copyWith(
                    fontSize: descriptionFontSize,
                    color: AppColors.kDarkGrey,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
        Gaps.horizontalGapOf(padding),
        // Right side - Image
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: SvgHelper.fromSource(
                path: reward.image,
                fit: BoxFit.contain,
                type: SvgSourceType.network,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _playAudio() async {
    try {
      if (reward.sAudio.isNotEmpty) {
        final audioWidget = CustomAudioWidget(
          audioPath: reward.sAudio,
          audioSourceType: AudioSourceType.network,
        );

        await audioWidget.play();
        await audioWidget.audioPlayer.onPlayerComplete.first;
        await audioWidget.dispose();
      }
    } catch (e) {
      logger.e('Error playing reward audio: $e');
    }
  }

  // Responsive sizing methods
  double _getDialogWidth(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 500;
    if (isTabletLandscape) return 600;
    return 350; // Portrait
  }

  double _getDialogHeight(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 300;
    if (isTabletLandscape) return 400;
    return 450; // Portrait
  }

  double _getTitleFontSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 40;
    if (isTabletLandscape) return 64;
    return 35; // Portrait
  }

  double _getSubtitleFontSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 20;
    if (isTabletLandscape) return 24;
    return 26; // Portrait
  }

  double _getDescriptionFontSize(
    bool isMobileLandscape,
    bool isTabletLandscape,
  ) {
    if (isMobileLandscape) return 14;
    if (isTabletLandscape) return 16;
    return 18; // Portrait
  }

  double _getImageSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 220;
    if (isTabletLandscape) return 300;
    return 180; // Portrait
  }

  double _getPadding(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 16;
    if (isTabletLandscape) return 20;
    return 24; // Portrait
  }
}
