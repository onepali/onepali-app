import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

/// A reusable custom range slider widget for selecting minutes.
///
/// Example usage:
/// ```dart
/// CustomRangeSlider(
///   min: 0,
///   max: 120,
///   value: 20,
///   onChanged: (val) {},
///   recommended: 20,
/// )
/// ```
class CustomRangeSlider extends StatelessWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double> onChanged;
  final double recommended;
  final String? label;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;

  const CustomRangeSlider({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.recommended = 20,
    this.label,
    this.activeColor = AppColors.kRed,
    this.inactiveColor = AppColors.kButtonGrey,
    this.thumbColor = AppColors.kRed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(min.toInt().toString(), style: AppStyles.text14PxRegular),
              Text(
                recommended.toInt().toString(),
                style: AppStyles.text14PxMedium.copyWith(
                  color: activeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(max.toInt().toString(), style: AppStyles.text14PxRegular),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: activeColor,
            inactiveTrackColor: inactiveColor,
            thumbColor: thumbColor,
            overlayColor: activeColor.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            min: min,
            max: max,
            value: value.clamp(min, max),
            onChanged: onChanged,
          ),
        ),
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              label!,
              style: AppStyles.text14PxMedium.copyWith(
                color: AppColors.kPitchBlack,
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              '${recommended.toInt()} minutes a day is recommended',
              style: AppStyles.text14PxMedium.copyWith(
                color: AppColors.kPitchBlack,
              ),
            ),
          ),
      ],
    );
  }
}
