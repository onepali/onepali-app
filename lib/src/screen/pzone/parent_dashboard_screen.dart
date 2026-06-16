import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ParentDashboardScreen extends StatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screen = [
    PHomeScreen(),
    ParentBlogScreen(),
    ParentSettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Note: Orientation is handled by OrientationRouteObserver
    // We don't set orientation here to avoid conflicts when navigating away
    Misc.onLayoutRendered(() async {
      final userProvider = context.read<UserProvider>();
      final childProvider = context.read<ChildUserProvider>();

      await userProvider.fetchOwnProfile();
      await childProvider.fetchChildUser();

      if (context.mounted) {
        ParentProfileUtil.checkAndShowProfileCompletion(context,);
      }
    });
  }

  _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // bool isMobile = PlatformUtility.isMobile(context);
    // bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    final userProvider = context.watch<UserProvider>();
    final UserModel? userInfo = userProvider.user;
    final childProvider = context.read<ChildUserProvider>();
    final childData = childProvider.childUser;
    final int childCount = childProvider.totalChildren;

    return Scaffold(
      appBar: PZAppBarWidget(
        title: pzoneBottomModel[_currentIndex].label,
        authProviderType: Utility.getAuthTypeFromUserInfo(
          userInfo?.authProvider ?? AuthProviderType.email.name,
        ),
        childData: childData,
        totalChildCount: childCount > 0 ? childCount : 0,
      ),
      body: _screen[_currentIndex],

      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          items: pzoneBottomModel
              .map(
                (e) => BottomNavigationBarItem(
                  icon: SvgHelper.fromSource(
                    path: e.icon,
                    height: Dimensions.kBottomNavIconSize(context),
                    width: Dimensions.kBottomNavIconSize(context),
                    color: AppColors.kLightGrey,
                  ),
                  activeIcon: SvgHelper.fromSource(
                    path: e.icon,
                    height: Dimensions.kBottomNavIconSize(context),
                    width: Dimensions.kBottomNavIconSize(context),
                    color: AppColors.kSecondaryColor,
                  ),
                  label: e.label,
                ),
              )
              .toList(),
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.kWhite,
          selectedItemColor: AppColors.kSecondaryColor,
          showSelectedLabels: false,
          // selectedFontSize: 0,
          // unselectedFontSize: 0,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          enableFeedback: false,
        ),
      ),
    );
  }
}
