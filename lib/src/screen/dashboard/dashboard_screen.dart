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
    // Watch the UserProvider to get updates
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
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                if (_selectedTabIndex == 0)
                  buildLessons()
                else if (_selectedTabIndex == 1)
                  buildSongCard()
                else if (_selectedTabIndex == 2)
                  buildStories(),
                CustomMaterialButton(
                  label: 'Logout',
                  onTap: () {
                    AuthProviderType type = AuthProviderType.email;
                    final loginType = userInfo?.authProvider;
                    if (loginType == AuthProviderType.google.name) {
                      type = AuthProviderType.google;
                    } else if (loginType == AuthProviderType.facebook.name) {
                      type = AuthProviderType.facebook;
                    }
                    Utility.authWiseLogout(context, type);
                    Utility.navigate(context, AppRoutes.loginScreen);
                  },
                  width: 100,
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  buildLessons() {
    return TitleActionChild(
      title: 'Lessons',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Center(child: Text('Lessons Content Here')),
      ),
    );
  }

  buildSongCard() {
    return TitleActionChild(
      title: 'Songs',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: SongScreen(),
      ),
    );
  }

  buildStories() {
    return TitleActionChild(
      title: 'Stories',
      titlePadding: const EdgeInsets.only(bottom: 8, left: 16),
      titleStyle: AppStyles.text20PxSemiBold.copyWith(color: AppColors.kBlack),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.45,
        child: Center(child: Text('Stories Content Here')),
      ),
    );
  }
}
