import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class PZAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final AuthProviderType? authProviderType;
  final List<ChildUserModel> childData;
  final int totalChildCount;

  const PZAppBarWidget({
    super.key,
    required this.title,
    this.leading,
    this.automaticallyImplyLeading = false,
    this.authProviderType,
    required this.childData,
    this.totalChildCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String icon,
    required String text,
    required bool isMobilePortrait,
    required Function()? onTap,
  }) {
    return PopupMenuItem<String>(
      value: value,
      onTap: onTap,
      child: Row(
        children: [
          SvgHelper.fromSource(
            path: icon,
            color: AppColors.kBlack,
            height: isMobilePortrait ? 20 : 24,
            width: isMobilePortrait ? 20 : 24,
          ),
          Gaps.horizontalGapOf(isMobilePortrait ? 10 : 14),
          Text(
            text,
            style: isMobilePortrait
                ? AppStyles.text16PxMedium
                : AppStyles.text24PxMedium,
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
        style: isMobilePortrait
            ? AppStyles.text18PxSemiBold.copyWith(
                fontFamily: AppConstants.kPoppinsFont,
              )
            : AppStyles.text22PxSemiBold.copyWith(
                fontFamily: AppConstants.kPoppinsFont,
              ),
      ),
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      actionsPadding: EdgeInsets.only(right: isMobilePortrait ? 8 : 16),
      actions: [
        PopupMenuButton<String>(
          routeSettings: const RouteSettings(name: AppConstants.popupMenuModal),
          icon: Icon(
            Icons.arrow_drop_down_outlined,
            size: isMobilePortrait ? 40 : 48,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobilePortrait ? 12 : 16),
          ),
          onSelected: (String value) {
            switch (value) {
              case 'home':
                break;
              case 'family':
                break;
              case 'logout':
                break;
            }
          },
          itemBuilder: (BuildContext context) => [
            _buildMenuItem(
              value: 'home',
              icon: Assets.homeIcon(context),
              text: 'Home',
              isMobilePortrait: isMobilePortrait,
              onTap: () {
                Utility.navigate(context, AppRoutes.dashboardScreen);
                ParentLocalStorage.setParentLogged(false);
                ChildLocalStorage.clear();
                UserAppBar.setTabIndex(0);
              },
            ),
            _buildMenuItem(
              value: 'family',
              icon: Assets.familyIcon(context),
              text: 'Family',
              isMobilePortrait: isMobilePortrait,
              onTap: () {
                // ParentLocalStorage.setParentLogged(false);
                ChildLocalStorage.clear();
                Future.delayed(const Duration(milliseconds: 150), () {
                  if (isMobile) {
                    Utility.navigateMaterialRoute(
                      context,
                      DrawerScreen(
                        data: childData,
                        totalChildCount: totalChildCount,
                        isParent: true,
                      ),
                      routeName: AppRoutes.drawerRoutes,
                    );
                  } else {
                    Utility.navigateMaterialRoute(
                      context,
                      TabDrawerScreen(
                        data: childData,
                        totalChildCount: totalChildCount,
                        isParent: true,
                      ),
                      routeName: AppRoutes.tabDrawerRoutes,
                    );
                  }
                });
              },
            ),
            _buildMenuItem(
              value: 'logout',
              icon: Assets.logoutIcon(context),
              text: 'Log out',
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
    final isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    return BottomSheetManager.bottomModelSheet(
      title: 'Do you want to log out?',
      action: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: CustomMaterialButton(
              label: 'Cancel',
              elevation: 0,
              height: isTabletPortrait ? 50 : 40,
              fillButton: false,
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Gaps.horizontalGapOf(isTabletPortrait ? 24 : 20),
          Expanded(
            child: CustomMaterialButton(
              label: 'Log out',
              height: isTabletPortrait ? 50 : 40,
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
