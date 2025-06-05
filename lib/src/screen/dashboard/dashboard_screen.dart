import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;

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
    final childProvider = context.read<ChildUserProvider>();
    final userProvider = context.watch<UserProvider>();
    final UserModel? userInfo = userProvider.user;
    final bool isLoading = userProvider.status == DataFetchStatus.loading;
    final bool hasData = userInfo != null;
    logger.d('DashboardScreen: hasData: $hasData, isLoading: $isLoading');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (index, value) {
        doubleTapTrigger();
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: UserAppBar(
            name: userInfo?.fullName ?? 'User',
            profileImage: Assets.avatar1,
            progressLevel: 0,
            totalStars: 0,
            onTabSelected: (tab) {
              final idx = homeServices.indexWhere((e) => e.name == tab);
              if (idx != -1) {
                setState(() {
                  _selectedTabIndex = idx;
                });
                UserAppBar.setTabIndex(idx);
              }
            },
            childData: childProvider.childUser,
            authType: Utility.getAuthTypeFromUserInfo(
              userInfo?.authProvider ?? AuthProviderType.email.name,
            ),
          ),
          body: HomeScreen(selectedTabIndex: _selectedTabIndex),
        ),
      ),
    );
  }
}
