import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../src.dart';

class LottieHelper {
  static Widget fromSource({
    required String path,
    LottieSourceType type = LottieSourceType.asset,
    double height = 100,
    double width = 100,
    bool repeat = true,
    bool reverse = false,
    bool animate = true,
    BoxFit fit = BoxFit.contain,
  }) {
    switch (type) {
      case LottieSourceType.asset:
        return _buildAssetLottie(
          path,
          height,
          width,
          repeat,
          reverse,
          animate,
          fit,
        );
      case LottieSourceType.network:
        return _buildNetworkLottie(
          path,
          height,
          width,
          repeat,
          reverse,
          animate,
          fit,
        );
    }
  }

  static Widget _buildAssetLottie(
    String assetName,
    double height,
    double width,
    bool repeat,
    bool reverse,
    bool animate,
    BoxFit fit,
  ) {
    return Lottie.asset(
      assetName,
      height: height,
      width: width,
      repeat: repeat,
      fit: fit,
      reverse: reverse,
      errorBuilder:
          (context, error, stackTrace) => Container(color: AppColors.kWhite),
      animate: animate,
      alignment: Alignment.center,
    );
  }

  static Widget _buildNetworkLottie(
    String url,
    double height,
    double width,
    bool repeat,
    bool reverse,
    bool animate,
    BoxFit fit,
  ) {
    return Lottie.network(
      url,
      height: height,
      width: width,
      repeat: repeat,
      reverse: reverse,
      animate: animate,
      fit: fit,
      errorBuilder:
          (context, error, stackTrace) => Container(color: AppColors.kWhite),
    );
  }
}
