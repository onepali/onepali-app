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

  @override
  void initState() {
    super.initState();
    _updateReward();
    _initializeAudio();
  }

  void _initializeAudio() {
    if (widget.data.sAudio.isNotEmpty) {
      logger.i('🎵 Reward audio path: ${widget.data.sAudio}');
    }
  }

  Future<void> _updateReward() async {
    final provider = context.read<RewardProvider>();
    await provider.saveRewardForChild(widget.data);
  }

  Future<void> _playAudio() async {
    try {
      if (widget.data.sAudio.isNotEmpty) {
        setState(() {
          _isPlayingAudio = true;
        });

        final audioWidget = CustomAudioWidget(
          audioPath: widget.data.sAudio,
          audioSourceType: AudioSourceType.network,
        );

        await audioWidget.play();
        await audioWidget.audioPlayer.onPlayerComplete.first;
        await audioWidget.dispose();

        setState(() {
          _isPlayingAudio = false;
        });
      }
    } catch (e) {
      logger.e('Error playing reward audio: $e');
      setState(() {
        _isPlayingAudio = false;
      });
    }
  }

  @override
  void dispose() {
    // No need to dispose _audioWidget since we create it on-demand
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double titleFontSize = isMobileLandscape ? 28 : 35;
    final double descriptionFontSize = isMobileLandscape ? 16 : 22;
    final double paddingH = isMobileLandscape ? 16 : 32;
    final double paddingV = isMobileLandscape ? 10 : 18;
    final double imageSize = isMobileLandscape ? 230 : 270;
    final double audioButtonSize = isMobileLandscape ? 28 : 48;
    final double descriptionSizeBoxHeight =
        isMobileLandscape
            ? MediaQuery.of(context).size.height * 0.8
            : MediaQuery.of(context).size.height * 0.5;

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.rewardPreviewBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: SvgHelper.fromSource(
                    path: Assets.wrong,
                    height: AppConstants.kIconSize,
                    width: AppConstants.kIconSize,
                    color: AppColors.kWhite,
                  ),
                  onPressed:
                      () => Utility.navigate(
                        context,
                        AppRoutes.rewardCollectionScreen,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
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
                      Gaps.verticalGapOf(paddingV),
                      Text(
                        widget.data.titleEn,
                        style: AppStyles.text30PxSemiBold.copyWith(
                          fontSize: titleFontSize,
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
                  SizedBox(
                    width: imageSize,
                    height: imageSize,
                    child: SvgHelper.fromSource(
                      path: widget.data.image,
                      fit: BoxFit.contain,
                      type: SvgSourceType.network,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
