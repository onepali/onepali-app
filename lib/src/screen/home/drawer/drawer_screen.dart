import 'package:flutter/material.dart';
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
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildChildProfilesGrid()],
                ),
              ),
            ),
          ),

          // Settings section
          Expanded(
            child: Stack(
              children: [
                _buildSettingsSection(),
                Positioned(
                  top: 8,
                  right: Dimensions.kIconMargin(context),
                  child: CircularButtonWidget(
                    type: CircularButtonType.closeGrey,
                    onPressed: () async {
                      final isParentLogged =
                          await ParentLocalStorage.isParentLogged();
                      logger.d('isParentLogged: $isParentLogged');

                      if (isParentLogged) {
                        ParentLocalStorage.setParentLogged(false);
                        UserAppBar.setTabIndex(0);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.dashboardScreen,
                          (route) => false,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildProfilesGrid() {
    // Show 'Add Child' if in parent zone OR if no children exist in child dashboard
    final shouldShowAddChild =
        widget.isParent || (widget.data.isEmpty && !widget.isParent);
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
                if (child.hasScreenTime && child.screenTime > 0) {
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
        // Show 'Add Child' if in parent zone OR if no children exist in child dashboard
        return GestureDetector(
          onTap: () {
            if (widget.data.length >= 3 && !GlobalConfig.isUserTesting) {
              DialogManager.showCustomDialog(
                context: context,
                title: 'You\'ve added 3 kids!',
                content:
                    'Want to add another to keep learning personalized? It’s just \$5 per extra child.',
                confirmButtonText: 'Add for \$5',
                onConfirm: () {},
              );
              return;
            } else {
              // If from child dashboard with no children, navigate to parent PIN screen
              if (!widget.isParent && widget.data.isEmpty) {
                Utility.navigate(
                  context,
                  AppRoutes.parentPinScreen,
                  arguments: {'fromAddChild': true},
                );
              } else {
                // Normal flow for parent zone
                Utility.navigate(context, AppRoutes.childRegisterScreen);
              }
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
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(color: AppColors.kPurple),
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
                    path: drawerSettings[i].icon,
                    height: 40,
                    width: 40,
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
