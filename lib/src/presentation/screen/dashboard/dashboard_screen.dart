import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserProvider>().userProfile();
  }

  @override
  Widget build(BuildContext context) {
    var userData = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: UserAppBar(
        name: userData?.name ?? 'Guest',
        profileImage: userData?.profilePicture ?? Assets.userAvatar,
        progressLevel:
            userData?.progress.preSchool.numbers == "completed" ? 1 : 0,
        totalStars: userData?.rewards.stars ?? 0,
        onTabSelected: (route) {
          Navigator.pushNamed(context, route);
        },
      ),
      body: Column(children: [LessonScreen()]),
    );
  }
}
