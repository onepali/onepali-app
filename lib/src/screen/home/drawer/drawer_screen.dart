import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class DrawerScreen extends StatefulWidget {
  final List<ChildUserModel> data;
  final int totalChildCount;
  final AuthProviderType? authProviderType;
  final bool isParent;
  const DrawerScreen({
    super.key,
    required this.data,
    required this.totalChildCount,
    this.authProviderType,
    this.isParent = false,
  });

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int _selectedChildIndex = -1;

  Future<void> _initChildSelection() async {
    if (widget.data.isNotEmpty) {
      final savedId = await ChildLocalStorage.getCurrentChildId();
      int idx = 0;
      if (savedId != null && savedId.isNotEmpty) {
        idx = widget.data.indexWhere((c) => c.uid == savedId);
        if (idx == -1) idx = 0;
      }
      setState(() {
        _selectedChildIndex = idx;
      });
      if (!mounted) return;
      final authState = Provider.of<AuthState>(context, listen: false);
      authState.setCurrentChildId(widget.data[idx].uid);
    }
  }

  @override
  void initState() {
    super.initState();
    _initChildSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.kPurple, // Scaffold background matches right side
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side - children profiles with black background (exactly half)
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.kDrawerBgColor, // Black only on left side
                  child: SizedBox.expand(
                    child: SafeArea(
                      left: true,
                      top: true,
                      right: false,
                      bottom: true,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [_buildChildProfilesGrid()],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Right side - settings with purple background (exactly half)
              Expanded(
                flex: 1,
                child: Container(
                  color: AppColors.kPurple,
                  child: SafeArea(
                    left: false,
                    top: true,
                    right: true,
                    bottom: true,
                    child: _buildSettingsSection(),
                  ),
                ),
              ),
            ],
          ),
          TopRightPositionedCloseButton(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChildProfilesGrid() {
    // Show "Add Child" only when accessed from Family menu AND passcode is verified (isParent = true)
    // When accessed from Dashboard, isParent will be false, so "Add Child" won't show
    final shouldShowAddChild = widget.isParent;
    final items = List<Widget>.generate(widget.data.length + (shouldShowAddChild ? 1 : 0), (
      index,
    ) {
      if (index < widget.data.length) {
        final child = widget.data[index];
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                logger.i(
                  '👆 DrawerScreen: Child selected - ${child.fullName} (${child.uid})',
                );
                setState(() {
                  _selectedChildIndex = index;
                });
                logger.i('🛑 Stopping tracking for previous child');
                await ScreenTimeService.instance.stopTracking();
                logger.d('💾 Saving child data to local storage');
                await ChildLocalStorage.saveCurrentChildId(child.uid);
                await ChildLocalStorage.saveCurrentAvatarUrl(child.avatarUrl);
                if (!mounted) return;
                final authState = Provider.of<AuthState>(
                  context,
                  listen: false,
                );
                authState.setCurrentChildId(child.uid);
                if (!mounted) return;
                final childProvider = Provider.of<ChildUserProvider>(
                  context,
                  listen: false,
                );
                await childProvider.updateScreenTimeEnabledStatusByChildId(
                  child.uid,
                );
                if (child.hasScreenTime &&
                    (child.screenTimeTracking?.totalAllowed ?? 0) > 0) {
                  logger.i(
                    '🔍 Checking screen time limit for child ${child.uid} before navigation',
                  );
                  final isLimitExceeded = await ScreenTimeService.instance
                      .checkScreenTimeLimitExceeded(child.uid);
                  if (isLimitExceeded) {
                    logger.w(
                      '⚠️ Screen time limit already exceeded for child ${child.uid}',
                    );
                    return;
                  }
                } else {
                  logger.i(
                    '🚫 Screen time disabled for child ${child.fullName}, skipping limit check',
                  );
                }
                logger.i('🔄 Navigating to dashboard with new child');
                // Clear parent logged status when going back to dashboard
                await ParentLocalStorage.setParentLogged(false);
                UserAppBar.setTabIndex(0);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.dashboardScreen,
                  (route) => false,
                );
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: index == _selectedChildIndex
                        ? AppColors.kPrimaryColor
                        : AppColors.kTransparentColor,
                    width: 3,
                  ),
                ),
                child: CustomImage(
                  child.avatarUrl,
                  height: 60,
                  width: 60,
                  isProfileImage: true,
                ),
              ),
            ),
            Gaps.horizontalGapOf(15),
            SizedBox(
              width: 150,
              child: Text(
                child.fullName.split(' ')[0],
                style: AppStyles.text20PxMedium.copyWith(
                  color: AppColors.kWhite,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            customInkwell(
              onTap: () {
                final targetChild = widget.data[index];
                Utility.navigateMaterialRoute(
                  context,
                  AchievementScreen(
                    name: targetChild.fullName,
                    profileImage: targetChild.avatarUrl,
                    childId: targetChild.uid,
                  ),
                );
              },
              child: const Icon(
                Icons.local_police,
                size: 32,
                color: AppColors.kYellow,
              ),
            ),
          ],
        );
      } else {
        // Show 'Add Child' button when accessed from Family menu with verified passcode
        return GestureDetector(
          onTap: () {
            if (widget.data.length >= 3 && !GlobalConfig.isUserTesting) {
              DialogManager.showCustomDialog(
                context: context,
                title: 'You\'ve added 3 kids!',
                content:
                    'Want to add another to keep learning personalized? It\'s just \$5 per extra child.',
                confirmButtonText: 'Add for \$5',
                onConfirm: () {},
              );
              return;
            } else {
              // User has verified passcode (isParent = true), so navigate directly to child registration
              Utility.navigate(context, AppRoutes.childRegisterScreen);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 55,
                width: 55,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.kWhite, size: 36),
              ),
              Gaps.horizontalGapOf(15),
              Text(
                'Add child',
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppStyles.text20PxMedium.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
            ],
          ),
        );
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items
            .map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: item,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 60),
            for (int i = 0; i < drawerSettings.length; i++)
              ListTile(
                contentPadding: const EdgeInsets.only(bottom: 8.0),
                onTap: () {
                  if (drawerSettings[i].route == AppRoutes.comingSoon) {
                    showCustomToaster('This feature is coming soon.');
                    return;
                  }
                  Utility.navigate(
                    context,
                    drawerSettings[i].route,
                    arguments: drawerSettings[i].args,
                  );
                },

                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgHelper.fromSource(
                    path: drawerSettings[i].name == 'Parent Zone'
                        ? Assets.parentZoneIcon(context)
                        : drawerSettings[i].name == 'Printables'
                        ? Assets.downloadIcon(context)
                        : drawerSettings[i].icon,
                    height: 40,
                    width: 40,
                    // Parent and Download icons have their own colors (white bg + purple icon)
                    // Home, Family, Logout use currentColor and need white color
                    color:
                        (drawerSettings[i].name == 'Parent Zone' ||
                            drawerSettings[i].name == 'Printables')
                        ? null // No color override for icons with their own colors
                        : AppColors
                              .kWhite, // White for icons using currentColor
                  ),
                ),
                dense: true,
                title: Text(
                  drawerSettings[i].name,
                  style: AppStyles.text18PxMedium.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
