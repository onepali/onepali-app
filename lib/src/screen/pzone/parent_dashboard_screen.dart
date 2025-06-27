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
    context.read<UserProvider>().fetchOwnProfile();
  }

  _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    final userProvider = context.watch<UserProvider>();
    final UserModel? userInfo = userProvider.user;

    return Scaffold(
      appBar: PZAppBarWidget(
        title: pzoneBottomModel[_currentIndex].label,
        authProviderType: Utility.getAuthTypeFromUserInfo(
          userInfo?.authProvider ?? AuthProviderType.email.name,
        ),
      ),
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:
            pzoneBottomModel
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: SvgHelper.fromSource(
                      path: e.icon,
                      height: isMobilePortrait ? 30 : 36,
                      color: AppColors.kLightGrey,
                    ),
                    activeIcon: SvgHelper.fromSource(
                      path: e.icon,
                      height: isMobilePortrait ? 30 : 36,
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
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
