import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedTabIndex = 0;
  bool isGuestLogged = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeGuestUser();
  }

  Future<void> _initializeGuestUser() async {
    setState(() {
      _isLoading = true;
    });
    await setGuestLogged(true);
    await getGuestLoggedStatus();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> setGuestLogged(bool isLogged) async {
    await GuestUtil.setGuestUser(isLogged);
    logger.i('👤 Guest logged ${isLogged ? 'in' : 'out'} successfully');
  }

  Future<bool> getGuestLoggedStatus() async {
    final isLogged = GuestUtil.isGuestUser();
    logger.i('👤 Guest logged ${isLogged ? 'in' : 'out'} status retrieved');
    if (mounted) {
      setState(() {
        isGuestLogged = isLogged;
      });
    }
    return isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, value) async {
        await setGuestLogged(false);
        Utility.navigate(context, AppRoutes.onboardingScreen);
      },
      child: Scaffold(
        backgroundColor: AppColors.kWhite,
        key: _scaffoldKey,
        appBar: UserAppBar(
          name: 'Guest',
          profileImage: '',
          totalStars: 0,
          menuColor: homeServices[_selectedTabIndex].color,
          onTabSelected: (tab) {
            final idx = homeServices.indexWhere((e) => e.name == tab);
            if (idx != -1) {
              setState(() {
                _selectedTabIndex = idx;
              });
              UserAppBar.setTabIndex(idx);
            }
          },
          childData: [],
          context: context,
          isGuest: true,
          playStarBlastAudio: false,
        ),
        body:
            _isLoading
                ? CustomLoader()
                : HomeScreen(selectedTabIndex: _selectedTabIndex),
      ),
    );
  }
}
