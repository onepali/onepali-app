import 'package:onepali/src/src.dart';

class SettingModel {
  String name;
  String desciption;
  String icon;
  String route;
  Map<String, dynamic> args;
  bool isActive;

  SettingModel({
    required this.name,
    this.desciption = '',
    required this.icon,
    required this.route,
    this.isActive = true,
    this.args = const {},
  });
}

List<SettingModel> drawerSettings = [
  SettingModel(
    name: 'Parent Zone',
    desciption: 'Manage your child\'s profile and settings',
    icon: Assets.parentZone,
    route: AppRoutes.parentPinScreen,
    args: {'fromScreenTimeLimit': false},
  ),

  SettingModel(
    name: 'Printables',
    desciption: 'Access and manage printable resources',
    icon: Assets.download,
    route: AppRoutes.comingSoon,
  ),
];
