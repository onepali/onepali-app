import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class OnboardModel {
  final String title;
  final String icon;
  final Color? color;
  final double? mobileIconHeight;
  final double? tabletIconHeight;
  final double? mobileIconWidth;
  final double? tabletIconWidth;

  const OnboardModel({
    required this.title,
    required this.icon,
    this.color,
    this.mobileIconHeight,
    this.tabletIconHeight,
    this.mobileIconWidth,
    this.tabletIconWidth,
  });

  double iconHeight(bool isTabletPortrait) =>
      isTabletPortrait ? tabletIconHeight ?? 40.0 : mobileIconHeight ?? 30.0;

  double? iconWidth(bool isTabletPortrait) =>
      isTabletPortrait ? tabletIconWidth : mobileIconWidth;
}

List<OnboardModel> onboardList = [
  OnboardModel(
    title: 'Google Search',
    icon: Assets.google,
    mobileIconHeight: 40.0,
    tabletIconHeight: 52.0,
  ),
  OnboardModel(title: 'Facebook / Instagram', icon: Assets.meta),
  OnboardModel(
    title: 'Youtube',
    icon: Assets.youtube,
    mobileIconHeight: 24.0,
    tabletIconHeight: 32.0,
    mobileIconWidth: 106.0,
    tabletIconWidth: 141.0,
  ),
  OnboardModel(title: 'Family / Friends', icon: Assets.family),
  OnboardModel(title: 'News / Blogs', icon: Assets.blog),
  OnboardModel(title: 'Other', icon: Assets.other),
];
