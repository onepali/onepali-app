import 'package:flutter/material.dart';
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
    Misc.onLayoutRendered(() {
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
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: ListView(
        children: [
          // Parent card
          if (parent != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PSettingCard(
                title: parent.fullName,
                avatarUrl: null,
                onEdit: () {
                  Utility.navigateMaterialRoute(
                    context,
                    UserScreen(),
                    routeName: AppRoutes.parentProfileScreen,
                  );
                },
              ),
            ),
          Gaps.verticalGapOf(18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const Text(
              'Your Children',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Gaps.verticalGapOf(8),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PSettingCard(
              title: 'Add child',
              isAdd: true,
              onTap: () {
                if (children.length >= 3) {
                  DialogManager.showCustomDialog(
                    context: context,
                    title: 'You\'ve added 3 kids!',
                    content:
                        'Want to add another to keep learning personalized? It\'s just \$5 per extra child.',
                    confirmButtonText: 'Add for \$5',
                    onConfirm: () {},
                  );
                } else {
                  Utility.navigateMaterialRoute(context, ChildRegisterScreen());
                }
              },
            ),
          ),
          Gaps.verticalGapOf(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 100,
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
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: banner.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              banner.title,
                              style:
                                  isMobilePortrait
                                      ? AppStyles.text14PxRegular
                                      : AppStyles.text16PxRegular,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Gaps.horizontalGapOf(8),
                          Icon(
                            banner.icon,
                            color: banner.color.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Gaps.verticalGapOf(10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: Container(
                height: isMobilePortrait ? 40 : 48,
                width: isMobilePortrait ? 40 : 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                ),
                child: const Icon(Icons.notifications),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: const Text('Notifications'),
              onTap: () {
                Utility.navigate(context, AppRoutes.parentNotificationScreen);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: Container(
                height: isMobilePortrait ? 40 : 48,
                width: isMobilePortrait ? 40 : 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                ),
                child: const Icon(Icons.assignment),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: const Text('My plan'),
              onTap: () {
                Utility.navigate(context, AppRoutes.parentPlansScreen);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: Container(
                height: isMobilePortrait ? 40 : 48,
                width: isMobilePortrait ? 40 : 48,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kLightGrey.withValues(alpha: 0.3),
                ),
                child: SvgHelper.fromSource(path: Assets.unsubscribe),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
              title: const Text('Cancel Subscription'),
              onTap: () {},
            ),
          ),
          Gaps.verticalGapOf(24),

          Container(
            color: Colors.blue[50],
            height: isMobilePortrait ? 130 : 80,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child:
                isMobilePortrait
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Utility.navigateMaterialRoute(
                                  context,
                                  SystemScreen(initialIndex: 0),
                                  routeName: AppRoutes.aboutUsScreen,
                                );
                              },
                              child: Text(
                                'About us',
                                style:
                                    isMobilePortrait
                                        ? AppStyles.text16PxMedium
                                        : AppStyles.text20PxMedium,
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                Utility.navigateMaterialRoute(
                                  context,
                                  SystemScreen(initialIndex: 1),
                                  routeName: AppRoutes.contactScreen,
                                );
                              },
                              child: Text(
                                'Contact us',
                                style:
                                    isMobilePortrait
                                        ? AppStyles.text16PxMedium
                                        : AppStyles.text20PxMedium,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Utility.navigateMaterialRoute(
                                  context,
                                  SystemScreen(initialIndex: 2),
                                  routeName: AppRoutes.faqsScreen,
                                );
                              },
                              child: Text(
                                'FAQ',
                                style:
                                    isMobilePortrait
                                        ? AppStyles.text16PxMedium
                                        : AppStyles.text20PxMedium,
                              ),
                            ),
                          ],
                        ),
                        CustomImage(
                          Assets.kidSafeSeal,
                          height: 40,
                          width: 110,
                          imageType: CustomImageType.local,
                          cover: false,
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Utility.navigateMaterialRoute(
                              context,
                              SystemScreen(initialIndex: 0),
                              routeName: AppRoutes.aboutUsScreen,
                            );
                          },
                          child: Text(
                            'About us',
                            style:
                                isMobilePortrait
                                    ? AppStyles.text16PxMedium
                                    : AppStyles.text20PxMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Utility.navigateMaterialRoute(
                              context,
                              SystemScreen(initialIndex: 1),
                              routeName: AppRoutes.contactScreen,
                            );
                          },
                          child: Text(
                            'Contact us',
                            style:
                                isMobilePortrait
                                    ? AppStyles.text16PxMedium
                                    : AppStyles.text20PxMedium,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Utility.navigateMaterialRoute(
                              context,
                              SystemScreen(initialIndex: 2),
                              routeName: AppRoutes.faqsScreen,
                            );
                          },
                          child: Text(
                            'FAQ',
                            style:
                                isMobilePortrait
                                    ? AppStyles.text16PxMedium
                                    : AppStyles.text20PxMedium,
                          ),
                        ),
                        CustomImage(
                          Assets.kidSafeSeal,
                          height: 60,
                          width: 100,
                          imageType: CustomImageType.local,
                          cover: false,
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}
