import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class HomeServiceModel {
  final String? name;
  final String? icon;
  final String? tooltip;
  final String route;
  final Color color;
  const HomeServiceModel({
    this.name,
    this.icon,
    this.tooltip,
    this.route = '',
    this.color = AppColors.kLessonColor,
  });
}

// Games // Stories // Songs & Rhymes // Lessons
List<HomeServiceModel> homeServices = [
  HomeServiceModel(
    name: 'Lessons',
    icon: Assets.lessons,
    tooltip: 'Lessons',
    color: AppColors.kLessonColor,
    route: '',
  ),
  // HomeServiceModel(
  //   name: 'Games',
  //   icon: Assets.games,
  //   tooltip: 'Games',
  //   route: AppRoutes.comingSoon,
  // ),
  HomeServiceModel(
    name: 'Videos',
    icon: Assets.video,
    tooltip: 'Videos',
    color: AppColors.kPurple,
    route: AppRoutes.comingSoon,
  ),
  HomeServiceModel(
    name: 'Stories',
    icon: Assets.stories,
    tooltip: 'Stories',
    color: AppColors.kStoryColor,
    route: AppRoutes.comingSoon,
  ),
];
