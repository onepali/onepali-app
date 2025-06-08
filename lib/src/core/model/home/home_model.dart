import 'package:onepali/src/src.dart';

class HomeServiceModel {
  final String? name;
  final String? icon;
  final String? tooltip;
  final String route;
  const HomeServiceModel({this.name, this.icon, this.tooltip, this.route = ''});
}

// Games // Stories // Songs & Rhymes // Lessons
List<HomeServiceModel> homeServices = [
  HomeServiceModel(
    name: 'Lessons',
    icon: Assets.lessons,
    tooltip: 'Lessons',
    route: '',
  ),
  // HomeServiceModel(
  //   name: 'Games',
  //   icon: Assets.games,
  //   tooltip: 'Games',
  //   route: AppRoutes.comingSoon,
  // ),
  HomeServiceModel(
    name: 'Songs & Rhymes',
    icon: Assets.songsRhymes,
    tooltip: 'Songs & Rhymes',
    route: AppRoutes.comingSoon,
  ),
  HomeServiceModel(
    name: 'Stories',
    icon: Assets.stories,
    tooltip: 'Stories',
    route: AppRoutes.comingSoon,
  ),
];
