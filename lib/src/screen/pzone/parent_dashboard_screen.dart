import 'package:flutter/material.dart';
import 'package:onepali/src/core/model/pzone/pzone_model.dart';
import 'package:onepali/src/src.dart';

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
  }

  _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PZAppBarWidget(title: pzoneBottomModel[_currentIndex].label),
      body: _screen[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items:
            pzoneBottomModel
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: SvgHelper.fromSource(path: e.icon),
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
