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

  @override
  void initState() {
    super.initState();
    setGuestLogged(true);
    getGuestLoggedStatus();
  }

  setGuestLogged(bool isLogged) async {
    await ChildLocalStorage.setGuestLogged(isLogged);
    logger.i('👤 Guest logged ${isLogged ? 'in' : 'out'} successfully');
  }

  getGuestLoggedStatus() async {
    final isLogged = await ChildLocalStorage.getGuestLogged();
    logger.i('👤 Guest logged ${isLogged ? 'in' : 'out'} status retrieved');
    setState(() {
      isGuestLogged = isLogged;
    });
    return isLogged;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (result, value) {
        setGuestLogged(false);
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: UserAppBar(
          name: 'Guest',
          profileImage: '',
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
          childData: [],
          context: context,
          isGuest: true,
        ),
        body: const Center(child: Text('GuestDashboardScreen')),
      ),
    );
  }
}
