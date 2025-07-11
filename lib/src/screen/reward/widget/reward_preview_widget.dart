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
  @override
  void initState() {
    super.initState();
    _updateReward();
  }

  Future<void> _updateReward() async {
    final provider = context.read<RewardProvider>();
    await provider.saveRewardForChild(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobileLandscape = isMobile && PlatformUtility.isLandscape(context);

    // Responsive values
    final double titleFontSize = isMobileLandscape ? 20 : 28;
    final double descriptionFontSize = isMobileLandscape ? 16 : 22;
    final double paddingH = isMobileLandscape ? 16 : 32;
    final double paddingV = isMobileLandscape ? 10 : 18;
    final double imageSize = isMobileLandscape ? 150 : 200;
    final double audioButtonSize = isMobileLandscape ? 40 : 60;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.rewardPreviewBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: paddingH,
                    vertical: paddingV,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.data.titleNp,
                            style: AppStyles.text28PxRegular.copyWith(
                              fontSize: titleFontSize,
                              color: AppColors.kWhite,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.horizontalGapOf(paddingH),
                          CustomAvatarGlow(
                            glowColor: AppColors.kSecondaryColor,
                            glowShape: BoxShape.circle,
                            visible: true,
                            glowRadiusFactor: 0.2,
                            child: IconButton(
                              icon: SvgHelper.fromSource(
                                path: Assets.sound,
                                height: audioButtonSize,
                                width: audioButtonSize,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: paddingV),
                      Text(
                        widget.data.descriptionNp,
                        style: AppStyles.text22PxRegular.copyWith(
                          fontSize: descriptionFontSize,
                          color: AppColors.kWhite,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: imageSize,
                  height: imageSize,
                  child: CustomImage(widget.data.image, cover: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
