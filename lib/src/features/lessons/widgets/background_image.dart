import 'package:flutter/widgets.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key, this.bgImageMb, this.bgImageTb});
  final String? bgImageMb;
  final String? bgImageTb;

  Widget _buildBackground(bool isMobile) {
    if (bgImageMb != null && isMobile) {
      return CustomCachedImage(imageUrl: bgImageMb!, fit: BoxFit.cover);
    }
    if (bgImageTb != null && !isMobile) {
      return CustomCachedImage(imageUrl: bgImageTb!, fit: BoxFit.cover);
    }
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return _buildBackground(isMobile);
  }
}
