import 'package:flutter/material.dart';
import 'package:onepali/navigator_key.dart';
import 'package:onepali/src/core/widget/url_launcher.dart';
import 'package:onepali/src/src.dart';
import 'package:share_plus/share_plus.dart';

class BannerModel {
  String title;
  String description;
  IconData icon;
  Color color;
  void Function()? onTap;

  BannerModel({
    required this.title,
    this.description = "",
    required this.icon,
    this.color = AppColors.kRed,
    this.onTap,
  });
}

List<BannerModel> spreadBannerList = [
  BannerModel(
    title: 'Spread the word! Invite a friend.',
    icon: Icons.volunteer_activism_rounded,
    color: AppColors.kPrimaryColor,
    onTap: () {
      SharePlus.instance.share(
        ShareParams(
          text:
              'Check out O Nepali, the app that makes learning Nepali fun for kids! Download it now: ${AppConstants.kAppLink}',
          title: 'O Nepali - Fun Nepali Learning App',
        ),
      );
    },
  ),
  BannerModel(
    title: 'Enjoying O Nepali with your little one? We\'d love your review!',
    icon: Icons.thumb_up_rounded,
    color: AppColors.thumbColor,
    onTap: () {
      Utility.navigate(
        navigatorKey.currentContext ?? navigatorKey.currentState!.context,
        AppRoutes.parentReviewScreen,
      );
    },
  ),
  BannerModel(
    title: 'Share your O Nepali experience with us!',
    icon: Icons.textsms_rounded,
    color: AppColors.kPurple,
    onTap: () {
      launchInBrowser(
        'mailto:${AppConstants.supportMail}?subject=O Nepali Feedback',
      );
    },
  ),
];
