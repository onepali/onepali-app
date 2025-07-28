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
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: AppColors.kWhite),
          alignment: Alignment.center,
          child:
              isMobilePortrait
                  ? _buildMobilePortraitSplash()
                  : _buildTabletSplash(),
        ),
      ),
    );
  }

  Widget _buildMobilePortraitSplash() {
    return VideoPlayerHelper.forSplash(
      videoPath: Assets.mbSplashImage,
      sourceType: VideoSourceType.asset,
      fit: BoxFit.cover,
    );
  }

  Widget _buildTabletSplash() {
    return VideoPlayerHelper.forSplash(
      videoPath: Assets.tbSplashImage,
      sourceType: VideoSourceType.asset,
      fit: BoxFit.cover,
    );
  }
}
