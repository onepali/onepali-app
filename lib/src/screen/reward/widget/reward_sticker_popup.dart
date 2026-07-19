import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';

import '../../../src.dart';

class RewardStickerPopup extends StatefulWidget {
  final RewardModel reward;

  const RewardStickerPopup({super.key, required this.reward});

  @override
  State<RewardStickerPopup> createState() => _RewardStickerPopupState();
}

class _RewardStickerPopupState extends State<RewardStickerPopup> {
  CustomAudioWidget? _audioWidget;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  void _initializeAudio() async {
    if (widget.reward.sAudio.isNotEmpty) {
      _audioWidget = CustomAudioWidget(
        audioPath: widget.reward.sAudio,
        audioSourceType: AudioSourceType.network,
      );

      _audioWidget!
          .preload()
          .then((_) {
            logger.i('✅ Reward popup audio preloaded successfully');
          })
          .catchError((e) {
            logger.w('⚠️ Failed to preload reward popup audio: $e');
          });

      _audioWidget!.audioPlayer.onPlayerComplete.listen((_) {
        if (mounted) {
          setState(() {
            _isPlayingAudio = false;
          });
        }
      });
    }
  }

  Future<void> _playAudio() async {
    if (_audioWidget == null || widget.reward.sAudio.isEmpty) return;

    try {
      if (_isPlayingAudio) {
        await _audioWidget!.audioPlayer.stop();
      }

      setState(() {
        _isPlayingAudio = true;
      });

      await _audioWidget!.play();
    } catch (e) {
      logger.e('Error playing reward audio: $e');
      if (mounted) {
        setState(() {
          _isPlayingAudio = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _audioWidget?.dispose();
    super.dispose();
  }

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
        padding: EdgeInsets.all(padding),
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
            Align(
              alignment: Alignment.topRight,
              child: CustomCloseButton(
                onTap: () => Navigator.of(context).pop(),
                iconPath: Assets.closeGreyIcon,
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
                context,
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
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.reward.titleNp,
                    style: AppStyles.text35PxBold.copyWith(
                      fontSize: titleFontSize,
                      fontFamily: AppConstants.kMuktaFont,
                    ),
                  ),
                  Gaps.horizontalGapOf(isMobileLandscape ? 8 : 12),
                  if (widget.reward.sAudio.isNotEmpty)
                    IconButton(
                      onPressed: () => _playAudio(),
                      icon: SvgHelper.fromSource(
                        path: Assets.sound,
                        height: Dimensions.kIconSize(context),
                        width: Dimensions.kIconSize(context),
                      ),
                    ),
                ],
              ),
              Gaps.verticalGapOf(isMobileLandscape ? 30 : 50),
              Text(
                widget.reward.titleEn,
                style: AppStyles.text30PxSemiBold.copyWith(
                  fontSize: subtitleFontSize,
                ),
              ),
              Gaps.verticalGapOf(12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0, bottom: 16.0),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        widget.reward.descriptionEn,
                        style: AppStyles.text22PxRegular.copyWith(
                          fontSize: descriptionFontSize,
                          color: AppColors.kDarkGrey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Gaps.horizontalGapOf(padding),
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: imageSize,
              height: imageSize,
              child: SvgHelper.fromSource(
                path: widget.reward.image,
                fit: BoxFit.contain,
                type: SvgSourceType.network,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _getDialogWidth(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 500;
    if (isTabletLandscape) return 800;
    return 350; // Portrait
  }

  double _getDialogHeight(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 300;
    if (isTabletLandscape) return 500;
    return 450; // Portrait
  }

  double _getTitleFontSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 40;
    if (isTabletLandscape) return 64;
    return 35; // Portrait
  }

  double _getSubtitleFontSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 20;
    if (isTabletLandscape) return 32;
    return 26; // Portrait
  }

  double _getDescriptionFontSize(
    bool isMobileLandscape,
    bool isTabletLandscape,
  ) {
    if (isMobileLandscape) return 14;
    if (isTabletLandscape) return 24;
    return 18; // Portrait
  }

  double _getImageSize(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 220;
    if (isTabletLandscape) return 300;
    return 180; // Portrait
  }

  double _getPadding(bool isMobileLandscape, bool isTabletLandscape) {
    if (isMobileLandscape) return 16;
    if (isTabletLandscape) return 32;
    return 24; // Portrait
  }
}
