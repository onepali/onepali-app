import 'package:flutter/material.dart';
import '../../src.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.kPrimaryColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: AppColors.kWhite, size: 20),
          const SizedBox(width: 8),
          Text(
            "You're offline. please check your connection to get back online.",
            style: AppStyles.text14PxMedium.copyWith(color: AppColors.kWhite),
          ),
        ],
      ),
    );
  }
}
