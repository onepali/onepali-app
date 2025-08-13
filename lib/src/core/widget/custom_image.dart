import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../src.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;
  final bool cover;
  final double? width;
  final bool circular;
  final double? height;
  final CustomImageType imageType;
  final Widget placeholder;
  final double borderRadius;
  final Color? borderColor;
  final BoxFit? boxFit;
  final bool border;
  final Color? color;
  final bool isProfileImage;
  final bool repeatGif;
  final Widget Function(BuildContext, String, dynamic)? errorBuilder;

  const CustomImage(
    this.imagePath, {
    super.key,
    this.cover = true,
    this.width,
    this.height,
    this.circular = false,
    this.imageType = CustomImageType.network,
    this.border = false,
    this.borderColor,
    this.boxFit,
    this.color,
    this.isProfileImage = false,
    this.repeatGif = false,
    this.placeholder = const Center(child: CircularProgressIndicator()),
    this.borderRadius = 0.0,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    switch (imageType) {
      case CustomImageType.local:
        return _buildLocalImage(context, imagePath);
      case CustomImageType.network:
        return _buildNetworkImage(imagePath);
    }
  }

  Widget _buildLocalImage(BuildContext context, String path) {
    final isGif = path.toLowerCase().endsWith('.gif');
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border:
            border
                ? Border.all(
                  width: 2,
                  color: borderColor ?? AppColors.kPrimaryColor,
                )
                : null,
        color: color,
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
      ),
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius:
            circular
                ? BorderRadius.circular(width! / 2)
                : BorderRadius.circular(borderRadius),
        child:
            isGif
                ? Image.asset(
                  path,
                  fit: boxFit ?? (cover ? BoxFit.cover : BoxFit.contain),
                  width: width,
                  height: height,
                  repeat: repeatGif ? ImageRepeat.repeat : ImageRepeat.noRepeat,
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        Assets.placeholder,
                        height: height,
                        width: width,
                        fit: cover ? BoxFit.cover : BoxFit.contain,
                      ),
                )
                : Image.asset(
                  path,
                  fit: boxFit ?? (cover ? BoxFit.cover : BoxFit.contain),
                  width: width,
                  height: height,
                  errorBuilder:
                      (context, error, stackTrace) => Image.asset(
                        Assets.placeholder,
                        height: height,
                        width: width,
                        fit: cover ? BoxFit.cover : BoxFit.contain,
                      ),
                ),
      ),
    );
  }

  Widget _buildNetworkImage(String path) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: cover ? BoxFit.cover : BoxFit.contain,
      width: width,
      height: height,
      imageBuilder:
          (context, imageProvider) => Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius:
                  borderRadius != 0.0
                      ? BorderRadius.circular(borderRadius)
                      : null,
              border:
                  border
                      ? Border.all(
                        width: 2,
                        color: borderColor ?? Theme.of(context).primaryColor,
                      )
                      : null,
              shape: circular ? BoxShape.circle : BoxShape.rectangle,
              image: DecorationImage(
                image: imageProvider,
                fit: cover ? BoxFit.cover : BoxFit.contain,
              ),
            ),
          ),
      placeholder: (context, url) => placeholder,
      errorWidget:
          errorBuilder ??
          (context, url, error) => ClipRRect(
            borderRadius:
                circular
                    ? BorderRadius.circular(width ?? 0 / 2)
                    : BorderRadius.circular(borderRadius),
            child: Image.asset(
              isProfileImage ? Assets.blueUserAvatar : Assets.placeholder,
              height: height,
              width: width,
              fit: cover ? BoxFit.cover : BoxFit.contain,
            ),
          ),
    );
  }
}
