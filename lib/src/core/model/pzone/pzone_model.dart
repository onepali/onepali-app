import 'package:onepali/src/src.dart';

class PZServiceModel {
  String label;
  String icon;
  String route;

  PZServiceModel({required this.label, required this.icon, required this.route})
    : assert(label.isNotEmpty, 'Label cannot be empty') {
    assert(icon.isNotEmpty, 'Icon cannot be empty');
    assert(route.isNotEmpty, 'Route cannot be empty');
  }
}

List<PZServiceModel> pzoneBottomModel = [
  PZServiceModel(
    label: 'Progress report',
    icon: Assets.parentHome,
    route: AppRoutes.parentDashboardScreen,
  ),
  PZServiceModel(
    label: 'Community',
    icon: Assets.parentBlog,
    route: AppRoutes.parentBlogScreen,
  ),

  PZServiceModel(
    label: 'Settings',
    icon: Assets.parentSetting,
    route: AppRoutes.parentProfileScreen,
  ),
];
