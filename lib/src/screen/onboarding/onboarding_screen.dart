import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    // Responsive variables
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
    final topSpacing = isTabletPortrait ? 120.0 : 100.0;
    final logoContainerSize = isTabletPortrait ? 240.0 : 150.0;
    final logoSize = isTabletPortrait ? 200.0 : 100.0;
    final brandLogoWidth = isTabletPortrait ? 120.0 : 40.0;
    final brandLogoHeight = isTabletPortrait ? 70.0 : 35.0;
    final taglineGap = isTabletPortrait ? 12.0 : 8.0;
    final buttonGap = isTabletPortrait ? 16.0 : 10.0;
    final containerPadding = isTabletPortrait ? 32.0 : 20.0;
    final buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final buttonRadius = isTabletPortrait ? 12.0 : 8.0;
    final taglineStyle = isTabletPortrait
        ? AppStyles.text24PxMedium
        : AppStyles.text14PxMedium;
    final buttonTextStyle = isTabletPortrait
        ? AppStyles.text20PxMedium
        : AppStyles.text16PxMedium;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (index, value) {
        doubleTapTrigger();
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        body: Container(
          color: AppColors.kWhite,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(containerPadding),
              child: Column(
                children: [
                  Gaps.verticalGapOf(topSpacing),
                  Container(
                    height: logoContainerSize,
                    width: logoContainerSize,
                    padding: EdgeInsets.all(isTabletPortrait ? 40.0 : 30.0),
                    // decoration: BoxDecoration(
                    //   color: AppColors.kPrimaryColor.withValues(alpha: 0.1),
                    //   shape: BoxShape.circle,
                    // ),
                    child: SvgHelper.fromSource(
                      path: Assets.leoSvg,
                      width: logoSize,
                      height: logoSize,
                    ),
                  ),
                  SvgHelper.fromSource(
                    path: Assets.logoSvg,
                    width: brandLogoWidth,
                    height: brandLogoHeight,
                    color: AppColors.kBlack,
                  ),
                  Gaps.verticalGapOf(taglineGap),
                  Text(
                    context.tr('tagline'),
                    style: taglineStyle.copyWith(
                      color: AppColors.kPrimaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomMaterialButton(
                        label: context.tr('login'),
                        onTap: () async {
                          Utility.navigate(context, AppRoutes.loginScreen);
                        },
                        elevation: 0,
                        height: buttonHeight,
                        width: double.infinity,
                        textStyle: buttonTextStyle,
                        showBorder: false,
                        backgroundColor: AppColors.kButtonGreen,
                        radius: buttonRadius,
                      ),
                      Gaps.verticalGapOf(buttonGap),
                      CustomMaterialButton(
                        label: context.tr('create_account'),
                        onTap: () async {
                          Utility.navigate(context, AppRoutes.registerScreen);
                        },
                        elevation: 0,
                        height: buttonHeight,
                        width: double.infinity,
                        showBorder: false,
                        textStyle: buttonTextStyle,
                        backgroundColor: AppColors.kButtonGrey,
                        radius: buttonRadius,
                      ),
                      Gaps.verticalGapOf(buttonGap),

                      CustomMaterialButton(
                        label: context.tr('try_lesson_guest'),
                        onTap: () async {
                          UserAppBar.setTabIndex(0);
                          Utility.navigate(
                            context,
                            AppRoutes.guestDashboardScreen,
                          );
                        },
                        elevation: 0,
                        height: buttonHeight,
                        width: double.infinity,
                        textStyle: buttonTextStyle,
                        showBorder: false,
                        backgroundColor: AppColors.kButtonGrey,
                        radius: buttonRadius,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:onepali/src/src.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _floatController;
//   late AnimationController _scaleController;
//   late Animation<double> _floatAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     // Floating animation for logo
//     _floatController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     )..repeat(reverse: true);
//     _floatAnimation = Tween<double>(begin: -15, end: 15).animate(
//       CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
//     );

//     // Pulsing scale animation
//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 1500),
//       vsync: this,
//     )..repeat(reverse: true);
//     _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
//     );
//   }
//   final _player = AudioPlayer();

//   @override
//   void dispose() {
//     _floatController.dispose();
//     _scaleController.dispose();
//   _player.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Responsive variables
//     final isTabletPortrait = PlatformUtility.isTabletPortrait(context);
//     final topSpacing = isTabletPortrait ? 80.0 : 60.0;
//     final logoContainerSize = isTabletPortrait ? 280.0 : 200.0;
//     final logoSize = isTabletPortrait ? 220.0 : 140.0;
//     final brandLogoWidth = isTabletPortrait ? 140.0 : 100.0;
//     final brandLogoHeight = isTabletPortrait ? 80.0 : 50.0;
//     final taglineGap = isTabletPortrait ? 16.0 : 12.0;
//     final buttonGap = isTabletPortrait ? 14.0 : 12.0;
//     final containerPadding = isTabletPortrait ? 32.0 : 24.0;
//     final buttonHeight = isTabletPortrait ? 60.0 : 52.0;
//     final buttonRadius = isTabletPortrait ? 16.0 : 12.0;
//     final theme = Theme.of(context);
//     return PopScope(
//       canPop: false,
//       onPopInvokedWithResult: (index, value) {
//         doubleTapTrigger();
//       },
//       child: Scaffold(
//         body: SafeArea(
//           child: Stack(
//             children: [
//               _buildFloatingStars(),

//               Padding(
//                 padding: EdgeInsets.all(containerPadding),
//                 child: Column(
//                   children: [
//                     Gaps.verticalGapOf(topSpacing),
//                     AnimatedBuilder(
//                       animation: Listenable.merge([
//                         _floatAnimation,
//                         _scaleAnimation,
//                       ]),
//                       builder: (context, child) {
//                         return Transform.translate(
//                           offset: Offset(0, _floatAnimation.value),
//                           child: Transform.scale(
//                             scale: _scaleAnimation.value,
//                             child: Container(
//                               height: logoContainerSize,
//                               width: logoContainerSize,
//                               padding: EdgeInsets.all(
//                                 isTabletPortrait ? 40.0 : 30.0,
//                               ),
//                               child: SvgHelper.fromSource(
//                                 path: Assets.leoSvg,
//                                 width: logoSize,
//                                 height: logoSize,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),

//                     Gaps.verticalGapOf(24),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 12,
//                       ),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 15,
//                             offset: const Offset(0, 5),
//                           ),
//                         ],
//                       ),
//                       child: SvgHelper.fromSource(
//                         path: Assets.logoSvg,
//                         width: brandLogoWidth,
//                         height: brandLogoHeight,
//                         // color: const Color(0xFFFF6B6B),
//                       ),
//                     ),

//                     Gaps.verticalGapOf(taglineGap),

//                     // Fun tagline with emoji
//                     Text(
//                       '✨ ${context.tr('tagline')} ✨',
//                       style: TextStyle(
//                         fontSize: isTabletPortrait ? 24 : 20,
//                         fontWeight: FontWeight.w600,
//                         color: const Color(0xFFFF6B6B),
//                         fontFamily: AppConstants.kPoppinsFont,
//                         height: 1.4,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),

//                     const Spacer(),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         _buildFunButton(
//                           context: context,
//                           label: context.tr('login'),
//                           gradient:  LinearGradient(
//                             colors: [theme.colorScheme.secondary, theme.colorScheme.secondary],
//                           ),
//                           onTap: () {
//
//                             Utility.navigate(context, AppRoutes.loginScreen);
//                           },
//                           height: buttonHeight,
//                           radius: buttonRadius,
//                           isTabletPortrait: isTabletPortrait,
//                           shadowColor: const Color(0xFFFF6B6B),
//                         ),

//                         Gaps.verticalGapOf(buttonGap),

//                         _buildFunButton(
//                           context: context,
//                           label: '${context.tr('create_account')}',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
//                           ),
//                           onTap: () {
//                             Utility.navigate(context, AppRoutes.registerScreen);
//                           },
//                           height: buttonHeight,
//                           radius: buttonRadius,
//                           isTabletPortrait: isTabletPortrait,
//                           shadowColor: const Color(0xFF4ECDC4),
//                         ),

//                         Gaps.verticalGapOf(buttonGap),

//                         _buildFunButton(
//                           context: context,
//                           label: '👀 ${context.tr('try_lesson_guest')}',
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFFFFD93D), Color(0xFFFFA500)],
//                           ),
//                           onTap: () {
//                             UserAppBar.setTabIndex(0);
//                             Utility.navigate(
//                               context,
//                               AppRoutes.guestDashboardScreen,
//                             );
//                           },
//                           height: buttonHeight,
//                           radius: buttonRadius,
//                           isTabletPortrait: isTabletPortrait,
//                           shadowColor: const Color(0xFFFFD93D),
//                         ),
//                       ],
//                     ),

//                     Gaps.verticalGapOf(20),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildFloatingStars() {
//     return Stack(
//       children: [
//         Positioned(
//           top: 100,
//           left: 30,
//           child: _buildStar(20, const Color(0xFFFFD93D), 3000),
//         ),
//         Positioned(
//           top: 150,
//           right: 40,
//           child: _buildStar(16, const Color(0xFFFF6B6B), 4000),
//         ),
//         Positioned(
//           top: 300,
//           left: 50,
//           child: _buildStar(12, const Color(0xFF4ECDC4), 3500),
//         ),
//         Positioned(
//           bottom: 250,
//           right: 30,
//           child: _buildStar(18, const Color(0xFFFF8E53), 3200),
//         ),
//         Positioned(
//           bottom: 350,
//           left: 70,
//           child: _buildStar(14, const Color(0xFF44A08D), 4200),
//         ),
//       ],
//     );
//   }

//   Widget _buildStar(double size, Color color, int duration) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0, end: 1),
//       duration: Duration(milliseconds: duration),
//       curve: Curves.easeInOut,
//       builder: (context, value, child) {
//         return Transform.scale(
//           scale: 0.8 + (value * 0.4),
//           child: Opacity(
//             opacity: 0.3 + (value * 0.4),
//             child: Icon(Icons.star, size: size, color: color),
//           ),
//         );
//       },
//       onEnd: () {
//         setState(() {});
//       },
//     );
//   }

//   Widget _buildFunButton({
//     required BuildContext context,
//     required String label,
//     required Gradient gradient,
//     required VoidCallback onTap,
//     required double height,
//     required double radius,
//     required bool isTabletPortrait,
//     required Color shadowColor,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(radius),
//         boxShadow: [
//           BoxShadow(
//             color: shadowColor.withOpacity(0.4),
//             blurRadius: 20,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: Material(
//         color: Colors.transparent,
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(radius),
//           child: Ink(
//             decoration: BoxDecoration(
//               gradient: gradient,
//               borderRadius: BorderRadius.circular(radius),
//             ),
//             child: Container(
//               height: height,
//               alignment: Alignment.center,
//               child: Text(
//                 label,
//                 style: TextStyle(
//                   fontSize: isTabletPortrait ? 20 : 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   fontFamily: AppConstants.kPoppinsFont,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
