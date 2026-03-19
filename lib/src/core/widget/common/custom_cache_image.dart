import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCachedImage extends StatelessWidget {
  final double? height;
  final double? width;
  final String imageUrl;
  final BoxFit? fit;
  final Alignment? alignment;
  final Widget? errorWidget;

  const CustomCachedImage({
    super.key,
    this.height,
    this.width,
    required this.imageUrl,
    this.fit,
    this.alignment,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit,
      imageUrl: imageUrl,
      alignment: alignment ?? Alignment.center,
      errorWidget: (context, url, error) {
        return errorWidget ??
            Icon(
              Icons.broken_image,
              color: Colors.grey,
              size: width != null && height != null
                  ? (width! < height! ? width! : height!) / 2
                  : 24,
            );
      },
      placeholder: (context, url) =>
          Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
