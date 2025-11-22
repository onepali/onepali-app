import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:onepali/src/src.dart';

class ParentSettingScreen extends StatefulWidget {
  const ParentSettingScreen({super.key});

  @override
  State<ParentSettingScreen> createState() => _ParentSettingScreenState();
}

class _ParentSettingScreenState extends State<ParentSettingScreen> {
  int _currentBannerIndex = 0;
  late final PageController _bannerPageController;
  late final List<BannerModel> _banners;
  @override
  void initState() {
    super.initState();
    _bannerPageController = PageController();
    _banners = spreadBannerList;
    Misc.onLayoutRendered(() async {
      // Note: Orientation is handled by OrientationRouteObserver
      // We don't set orientation here to avoid conflicts
      context.read<UserProvider>().fetchOwnProfile();
      context.read<ChildUserProvider>().fetchChildUser();
      _startBannerRotation();
    });
  }

  void _startBannerRotation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 10));
      if (!mounted) return false;
      setState(() {
        _currentBannerIndex = (_currentBannerIndex + 1) % _banners.length;
      });
      _bannerPageController.animateToPage(
        _currentBannerIndex,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      return mounted;
    });
  }

  @override
  void dispose() {
    _bannerPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final childProvider = context.watch<ChildUserProvider>();
    final parent = userProvider.user;
    final children = childProvider.childUser;
    logger.d('ParentSettingScreen: Children count = ${children.length}');
    for (var i = 0; i < children.length; i++) {
      logger.d('Child $i: ${children[i].fullName} (${children[i].uid})');
    }
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    // Responsive sizing - mobile stays same, tablet gets enhanced
    final double horizontalPadding = isMobile ? 16.0 : 24.0;
    final double verticalGap1 = isMobile ? 18.0 : 24.0;
    final double verticalGap2 = isMobile ? 8.0 : 12.0;
    final double verticalGap3 = isMobile ? 10.0 : 16.0;
    final double bannerHeight = isMobile ? 100.0 : 130.0;
    final double bannerMarginVertical = isMobile ? 12.0 : 16.0;
    final double bannerPadding = isMobile ? 12.0 : 16.0;
    final double bannerBorderRadius = isMobile ? 8.0 : 12.0;
    // final double iconSize = isMobile ? (isMobilePortrait ? 40.0 : 48.0) : 56.0;
    final double bottomNavHeight = isMobile ? 60.0 : 100.0;
    final double bottomNavPadding = isMobile ? 12.0 : 16.0;

    final TextStyle childrenHeaderStyle = isMobile
        ? AppStyles.text16PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text24PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          );

    final TextStyle bannerTextStyle = isMobile
        ? AppStyles.text14PxRegular.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text24PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          );

    final TextStyle notificationTitleStyle = isMobile
        ? AppStyles.text16PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          )
        : AppStyles.text24PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          );

    final TextStyle bottomNavTextStyle = isMobile
        ? (isMobilePortrait
              ? AppStyles.text16PxMedium.copyWith(
                  fontFamily: AppConstants.kDMSansFont,
                )
              : AppStyles.text20PxMedium.copyWith(
                  fontFamily: AppConstants.kDMSansFont,
                ))
        : AppStyles.text24PxMedium.copyWith(
            fontFamily: AppConstants.kDMSansFont,
          );

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: ListView(
        children: [
          Gaps.verticalGapOf(isMobilePortrait ? 16.0 : 24.0),
          // Parent card
          if (parent != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: PSettingCard(
                title: parent.fullName,
                avatarUrl: null,
                onEdit: () {
                  Utility.navigateMaterialRoute(
                    context,
                    UserScreen(isFromParentZone: true),
                    routeName: AppRoutes.parentProfileScreen,
                  );
                },
              ),
            ),
          Gaps.verticalGapOf(verticalGap1),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalGap2,
            ),
            child: Text('Your children', style: childrenHeaderStyle),
          ),
          Gaps.verticalGapOf(verticalGap2),
          ...children
              .where(
                (child) => child.fullName.isNotEmpty && child.uid.isNotEmpty,
              )
              .map(
                (child) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: PSettingCard(
                    title: child.fullName,
                    avatarUrl: child.avatarUrl,
                    onEdit: () {
                      Utility.navigateMaterialRoute(
                        context,
                        CUserScreen(child: child),
                        routeName: AppRoutes.childProfileScreen,
                      );
                    },
                  ),
                ),
              ),
          // Add child button with restrictions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: PSettingCard(
              title: 'Add child',
              isAdd: true,
              onTap: () async {
                // Check if parent has verified passcode
                final isParentLogged = await ParentLocalStorage.isParentLogged();
                
                if (!isParentLogged) {
                  // Navigate to parent PIN screen for passcode verification
                  Utility.navigate(
                    context,
                    AppRoutes.parentPinScreen,
                    arguments: {'fromAddChild': true},
                  );
                  return;
                }
                
                final validChildrenCount = children
                    .where(
                      (child) =>
                          child.fullName.isNotEmpty && child.uid.isNotEmpty,
                    )
                    .length;
                if (validChildrenCount >= 3 && !GlobalConfig.isUserTesting) {
                  DialogManager.showCustomDialog(
                    context: context,
                    title: 'You\'ve added 3 kids!',
                    content:
                        'Want to add another to keep learning personalized? It\'s just \$5 per extra child.',
                    confirmButtonText: 'Add for \$5',
                    onConfirm: () {},
                  );
                } else {
                  Utility.navigate(context, AppRoutes.childRegisterScreen);
                }
              },
            ),
          ),
          Gaps.verticalGapOf(verticalGap3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: SizedBox(
              height: bannerHeight,
              child: PageView.builder(
                controller: _bannerPageController,
                itemCount: _banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentBannerIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return GestureDetector(
                    onTap: banner.onTap,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: bannerMarginVertical,
                      ),
                      padding: EdgeInsets.all(bannerPadding),
                      decoration: BoxDecoration(
                        color: banner.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(bannerBorderRadius),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              banner.title,
                              style: bannerTextStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Gaps.horizontalGapOf(8),
                          Icon(
                            banner.icon,
                            color: banner.color,
                            size: isMobilePortrait ? 32 : 40,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Gaps.verticalGapOf(verticalGap3),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: ListTile(
              leading: Container(
                height: Dimensions.kSettingAvatarSize(context),
                width: Dimensions.kSettingAvatarSize(context),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                ),
                child: Icon(
                  Icons.notifications,
                  size: Dimensions.kSettingAvatarSize(context) - 26,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: Text('Notifications', style: notificationTitleStyle),
              onTap: () {
                Utility.navigate(context, AppRoutes.parentNotificationScreen);
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ListTile(
          //     leading: Container(
          //       height: isMobilePortrait ? 40 : 48,
          //       width: isMobilePortrait ? 40 : 48,
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppColors.kLightGrey.withValues(alpha: 0.3),
          //       ),
          //       child: const Icon(Icons.assignment),
          //     ),
          //     contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          //     title: const Text('My plan'),
          //     onTap: () {
          //       Utility.navigate(context, AppRoutes.parentPlansScreen);
          //     },
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: ListTile(
          //     leading: Container(
          //       height: isMobilePortrait ? 40 : 48,
          //       width: isMobilePortrait ? 40 : 48,
          //       padding: const EdgeInsets.all(8),
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         color: AppColors.kLightGrey.withValues(alpha: 0.3),
          //       ),
          //       child: SvgHelper.fromSource(path: Assets.unsubscribe),
          //     ),
          //     contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
          //     title: const Text('Cancel Subscription'),
          //     onTap: () {},
          //   ),
          // ),
          Gaps.verticalGapOf(24),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.blue[50],
        height: bottomNavHeight,
        padding: EdgeInsets.symmetric(
          horizontal: bottomNavPadding,
          vertical: bottomNavPadding,
        ),
        child:
            // isMobilePortrait
            //     ? Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           spacing: 10,
            //           children: [
            //             GestureDetector(
            //               onTap: () {
            //                 Utility.navigateMaterialRoute(
            //                   context,
            //                   SystemScreen(initialIndex: 0),
            //                   routeName: AppRoutes.aboutUsScreen,
            //                 );
            //               },
            //               child: Text(
            //                 'About us',
            //                 style:
            //                     isMobilePortrait
            //                         ? AppStyles.text16PxMedium
            //                         : AppStyles.text20PxMedium,
            //               ),
            //             ),
            //             GestureDetector(
            //               onTap: () {
            //                 Utility.navigateMaterialRoute(
            //                   context,
            //                   SystemScreen(initialIndex: 1),
            //                   routeName: AppRoutes.contactScreen,
            //                 );
            //               },
            //               child: Text(
            //                 'Contact us',
            //                 style:
            //                     isMobilePortrait
            //                         ? AppStyles.text16PxMedium
            //                         : AppStyles.text20PxMedium,
            //               ),
            //             ),
            //             GestureDetector(
            //               onTap: () {
            //                 Utility.navigateMaterialRoute(
            //                   context,
            //                   SystemScreen(initialIndex: 2),
            //                   routeName: AppRoutes.faqsScreen,
            //                 );
            //               },
            //               child: Text(
            //                 'FAQ',
            //                 style:
            //                     isMobilePortrait
            //                         ? AppStyles.text16PxMedium
            //                         : AppStyles.text20PxMedium,
            //               ),
            //             ),
            //           ],
            //         ),
            //         // CustomImage(
            //         //   Assets.kidSafeSeal,
            //         //   height: 40,
            //         //   width: 110,
            //         //   imageType: CustomImageType.local,
            //         //   cover: false,
            //         // ),
            //       ],
            //     )
            //     :
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Utility.navigateMaterialRoute(
                      context,
                      SystemScreen(initialIndex: 0),
                      routeName: AppRoutes.aboutUsScreen,
                    );
                  },
                  child: Text('About us', style: bottomNavTextStyle),
                ),
                GestureDetector(
                  onTap: () {
                    Utility.navigateMaterialRoute(
                      context,
                      SystemScreen(initialIndex: 1),
                      routeName: AppRoutes.contactScreen,
                    );
                  },
                  child: Text('Contact us', style: bottomNavTextStyle),
                ),
                GestureDetector(
                  onTap: () {
                    Utility.navigateMaterialRoute(
                      context,
                      SystemScreen(initialIndex: 2),
                      routeName: AppRoutes.faqsScreen,
                    );
                  },
                  child: Text('FAQ', style: bottomNavTextStyle),
                ),
                // CustomImage(
                //   Assets.kidSafeSeal,
                //   height: 60,
                //   width: 100,
                //   imageType: CustomImageType.local,
                //   cover: false,
                // ),
              ],
            ),
      ),
    );
  }
}
