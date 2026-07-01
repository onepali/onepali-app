import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  void _navigateAfterDelay() async {
    await context.read<SplashProvider>().waitAndNavigate(context);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: Stack(
        children: [
          // Background color extends to full screen
          Positioned.fill(child: Container(color: AppColors.kWhite)),
          // Video player covering full screen
          Positioned.fill(
            child: isMobilePortrait
                ? _buildMobilePortraitSplash()
                : _buildTabletSplash(),
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePortraitSplash() {
    return CustomVideoPlayer(
      videoPath: Assets.splashVideo,
      sourceType: VideoSourceType.asset,
      fit: BoxFit.cover,
      autoPlay: true,
      loop: false,
      enableCaching: false,
      showControls: false,
      onVideoEnd: () {},
    );
  }

  Widget _buildTabletSplash() {
    return CustomVideoPlayer(
      videoPath: Assets.splashVideo,
      sourceType: VideoSourceType.asset,
      fit: BoxFit.cover,
      autoPlay: true,
      loop: false,
      enableCaching: false,
      showControls: false,
      onVideoEnd: () {},
    );
  }
}
