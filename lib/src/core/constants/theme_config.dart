import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class ThemeConfig {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.kPrimaryColor,
    scaffoldBackgroundColor: AppColors.kBackgroundColor,
    fontFamily: AppConstants.defaultFontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.kWhite,
      foregroundColor: AppColors.kPitchBlack,
      elevation: 0,
      titleTextStyle: AppStyles.text18PxBold.copyWith(
        color: AppColors.kPitchBlack,
        fontFamily: 'Mukta',
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.kPitchBlack,
      ),
      // bodyLarge: TextStyle(
      //   fontSize: 16,
      //   fontWeight: FontWeight.normal,
      //   color: AppColors.kDarkGrey,
      // ),
      // bodyMedium: TextStyle(
      //   fontSize: 14,
      //   fontWeight: FontWeight.normal,
      //   color: AppColors.kGrey,
      // ),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.kPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.kPrimaryColor,
      secondary: AppColors.kSecondaryColor,
      surface: AppColors.kBackgroundColor,
      error: AppColors.errorColor,
    ),
  );
}
