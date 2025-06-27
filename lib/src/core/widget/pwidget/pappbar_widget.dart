import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PZAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final AuthProviderType? authProviderType;

  const PZAppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.authProviderType,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required IconData icon,
    required String text,
    required bool isMobilePortrait,
    required Function()? onTap,
  }) {
    return PopupMenuItem<String>(
      value: value,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: isMobilePortrait ? 20 : 24),
          Gaps.horizontalGapOf(isMobilePortrait ? 8 : 12),
          Text(
            text,
            style:
                isMobilePortrait
                    ? AppStyles.text18PxMedium
                    : AppStyles.text18PxMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = PlatformUtility.isMobile(context);
    bool isMobilePortrait = isMobile && PlatformUtility.isPortrait(context);
    return AppBar(
      title: Text(
        title,
        style:
            isMobilePortrait
                ? AppStyles.text18PxSemiBold
                : AppStyles.text26PxSemiBold,
      ),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actionsPadding: EdgeInsets.only(right: isMobilePortrait ? 8 : 16),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            size: isMobilePortrait ? 40 : 48,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobilePortrait ? 12 : 16),
          ),
          onSelected: (String value) {
            // Handle menu item selection
            switch (value) {
              case 'family_dashboard':
                // Add navigation to family dashboard
                break;
              case 'logout':
                // Add logout functionality
                break;
            }
          },
          itemBuilder:
              (BuildContext context) => [
                _buildMenuItem(
                  value: 'family_dashboard',
                  icon: Icons.diversity_3,
                  text: 'Family Dashboard',
                  isMobilePortrait: isMobilePortrait,
                  onTap: () {
                    Utility.navigate(context, AppRoutes.dashboardScreen);
                    ParentLocalStorage.setParentLogged(false);
                  },
                ),
                _buildMenuItem(
                  value: 'logout',
                  icon: Icons.logout_outlined,
                  text: 'Logout',
                  isMobilePortrait: isMobilePortrait,
                  onTap: () {
                    logoutBottomSheet(context);
                  },
                ),
              ],
        ),
      ],
    );
  }

  Future logoutBottomSheet(context) {
    return BottomSheetManager.bottomModelSheet(
      title: 'Are you sure? Logout',
      action: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CustomMaterialButton(
              label: 'Cancel',
              elevation: 0,
              height: 40,
              fillButton: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Gaps.horizontalGapOf(20),
          Expanded(
            child: CustomMaterialButton(
              label: 'Yes, Logout',
              height: 40,
              elevation: 0,
              onTap: () {
                Utility.authWiseLogout(
                  context,
                  authProviderType ?? AuthProviderType.email,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
