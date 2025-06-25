import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:onepali/src/src.dart';

class ParentSettingScreen extends StatefulWidget {
  const ParentSettingScreen({super.key});

  @override
  State<ParentSettingScreen> createState() => _ParentSettingScreenState();
}

class _ParentSettingScreenState extends State<ParentSettingScreen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() {
      context.read<UserProvider>().fetchOwnProfile();
      context.read<ChildUserProvider>().fetchChildUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final childProvider = context.watch<ChildUserProvider>();
    final parent = userProvider.user;
    final children = childProvider.childUser;
    final canAddChild = children.length < 3;
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // Parent card
          if (parent != null)
            PSettingCard(
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
          Gaps.verticalGapOf(18),
          const Text(
            'Your Children',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Gaps.verticalGapOf(8),
          ...children.map(
            (child) => PSettingCard(
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
          if (canAddChild)
            PSettingCard(title: 'Add child', isAdd: true, onTap: () {}),
          Gaps.verticalGapOf(18),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Spread the word! Invite a friend.',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                Gaps.horizontalGapOf(8),
                Icon(Icons.volunteer_activism, color: Colors.orange[300]),
              ],
            ),
          ),
          ListTile(
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
            title: const Text('Notifications'),
            onTap: () {
              Utility.navigate(context, AppRoutes.parentNotificationScreen);
            },
          ),
          ListTile(
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
            title: const Text('My plan'),
            onTap: () {},
          ),
          ListTile(
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
            title: const Text('Cancel Subscription'),
            onTap: () {},
          ),
          Gaps.verticalGapOf(24),
          // Footer
          Container(
            color: Colors.blue[50],
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('About us'),
                const Text('Contact us'),
                const Text('FAQ'),
                // Image.asset('assets/images/kidsafe.png', height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
