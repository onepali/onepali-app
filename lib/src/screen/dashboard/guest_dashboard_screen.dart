import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class GuestDashboardScreen extends StatefulWidget {
  const GuestDashboardScreen({super.key});

  @override
  State<GuestDashboardScreen> createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UserAppBar(
        name: 'Guest',
        profileImage: '',
        totalStars: 0,
        onTabSelected: (tab) {},
        childData: [],
        context: context,
        isGuest: true,
      ),
      body: const Center(child: Text('GuestDashboardScreen')),
    );
  }
}
