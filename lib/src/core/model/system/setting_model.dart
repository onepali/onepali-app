import 'package:onepali/src/src.dart';

class SettingModel {
  String name;
  String desciption;
  String icon;
  String route;
  bool isActive;

  SettingModel({
    required this.name,
    this.desciption = '',
    required this.icon,
    required this.route,
    this.isActive = true,
  });
}

List<SettingModel> drawerSettings = [
  SettingModel(
    name: 'Parent Zone',
    desciption: 'Manage your child\'s profile and settings',
    icon: Assets.parentZone,
    route: AppRoutes.comingSoon,
  ),

  SettingModel(
    name: 'Printables',
    desciption: 'Access and manage printable resources',
    icon: Assets.download,
    route: AppRoutes.comingSoon,
  ),

  SettingModel(
    name: 'Logout',
    desciption: 'Log out of your account',
    icon: Assets.logout,
    route: AppRoutes.logout,
  ),
];
