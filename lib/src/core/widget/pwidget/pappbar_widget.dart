import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PZAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final bool automaticallyImplyLeading;

  const PZAppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.automaticallyImplyLeading = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    return AppBar(
      title: Text(
        title,
        style:
            isMobilePortrait
                ? AppStyles.text18PxMedium
                : AppStyles.text26PxMedium,
      ),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actionsPadding: EdgeInsets.only(right: isMobilePortrait ? 8 : 16),
      actions: [
        Icon(Icons.arrow_drop_down_outlined, size: isMobilePortrait ? 30 : 40),
      ],
    );
  }
}
