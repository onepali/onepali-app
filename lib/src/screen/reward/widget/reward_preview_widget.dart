import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../src.dart';

class RewardPreviewWidget extends StatefulWidget {
  final RewardModel data;
  const RewardPreviewWidget({super.key, required this.data});

  @override
  State<RewardPreviewWidget> createState() => _RewardPreviewWidgetState();
}

class _RewardPreviewWidgetState extends State<RewardPreviewWidget> {
  bool _isPlayingAudio = false;
  CustomAudioWidget? _audioWidget;

  @override
  void initState() {
    super.initState();
    _updateReward();
    _initializeAudio();
  }

  void _initializeAudio() async {
    if (widget.data.sAudio.isNotEmpty) {
      logger.i('🎵 Reward audio path: ${widget.data.sAudio}');

      _audioWidget = CustomAudioWidget(
        audioPath: widget.data.sAudio,
        audioSourceType: AudioSourceType.network,
      );

      _audioWidget!
          .preload()
          .then((_) {
            logger.i('✅ Reward audio preloaded successfully');
          })
          .catchError((e) {
            logger.w('⚠️ Failed to preload reward audio: $e');
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

  Future<void> _updateReward() async {
    final provider = context.read<RewardProvider>();
    await provider.saveRewardForChild(widget.data);
  }

  Future<void> _playAudio() async {
    if (_audioWidget == null || widget.data.sAudio.isEmpty) return;

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

    // Responsive values
    final double titleFontSize = isMobileLandscape ? 40 : 64;
    final double descriptionFontSize = isMobileLandscape ? 16 : 28;
    final double paddingH = isMobileLandscape ? 16 : 32;
    final double paddingV = isMobileLandscape ? 10 : 18;
    final double imageSize = isMobileLandscape ? 230 : 500;
    final double audioButtonSize = Dimensions.kIconSize(context);
    final double descriptionSizeBoxHeight = isMobileLandscape
        ? MediaQuery.of(context).size.height * 0.8
        : MediaQuery.of(context).size.height * 0.5;

    return Scaffold(
      body: Stack(
        children: [
          // Background image covering full screen
          Positioned.fill(
            child: Image.asset(
              Assets.rewardPreviewBackground,
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: Dimensions.kIconMargin(context),
                    top: isMobile ? 16 : 24,
                  ),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircularButtonWidget(
                      type: CircularButtonType.closeGrey,
                      onPressed: () => Utility.navigate(
                        context,
                        AppRoutes.rewardCollectionScreen,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: isMobileLandscape ? 80 : 120,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                widget.data.titleNp,
                                style: AppStyles.text35PxBold.copyWith(
                                  fontSize: titleFontSize,
                                  color: AppColors.kWhite,
                                  fontFamily: AppConstants.kMuktaFont,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Gaps.horizontalGapOf(paddingH),
                              CustomAvatarGlow(
                                glowColor: AppColors.kSecondaryColor,
                                glowShape: BoxShape.circle,
                                visible: _isPlayingAudio,
                                glowRadiusFactor: 0.2,
                                child: IconButton(
                                  icon: SvgHelper.fromSource(
                                    path: Assets.sound,
                                    height: audioButtonSize,
                                    width: audioButtonSize,
                                  ),
                                  onPressed: _playAudio,
                                ),
                              ),
                            ],
                          ),
                          Gaps.verticalGapOf(
                            paddingV + (isMobileLandscape ? 20 : 30),
                          ),
                          Text(
                            widget.data.titleEn,
                            style: AppStyles.text30PxSemiBold.copyWith(
                              fontSize: isMobileLandscape ? 24 : 40,
                              color: AppColors.kWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.verticalGapOf(paddingV),
                          SizedBox(
                            width: descriptionSizeBoxHeight,
                            child: Text(
                              widget.data.descriptionEn,
                              style: AppStyles.text22PxRegular.copyWith(
                                fontSize: descriptionFontSize,
                                color: AppColors.kWhite,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        right: isMobileLandscape ? 60 : 80,
                      ),
                      child: SizedBox(
                        width: imageSize,
                        height: imageSize,
                        child: SvgHelper.fromSource(
                          path: widget.data.image,
                          fit: BoxFit.contain,
                          type: SvgSourceType.network,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
