import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class OnboardModel {
  final String title;
  final String icon;
  final Color? color;

  const OnboardModel({required this.title, required this.icon, this.color});
}

List<OnboardModel> onboardList = [
  OnboardModel(title: 'Google Search', icon: Assets.google),
  OnboardModel(title: 'Facebook / Instagram', icon: Assets.meta),
  OnboardModel(title: 'Youtube', icon: Assets.youtube),
  OnboardModel(
    title: 'Family / Friends',
    icon: Assets.family,
    color: AppColors.kAccentColor,
  ),
  OnboardModel(title: 'News / Blogs', icon: Assets.blog),
  OnboardModel(title: 'Other', icon: Assets.other),
];
