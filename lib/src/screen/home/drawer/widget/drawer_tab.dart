import 'package:flutter/material.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class TabDrawerScreen extends StatefulWidget {
  final List<ChildUserModel> data;
  final int totalChildCount;
  final bool isParent;

  const TabDrawerScreen({
    super.key,
    required this.data,
    required this.totalChildCount,
    this.isParent = false,
  });

  @override
  State<TabDrawerScreen> createState() => _TabDrawerScreenState();
}

class _TabDrawerScreenState extends State<TabDrawerScreen> {
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

  void _onChildSelected(int index) async {
    setState(() {
      _selectedChildIndex = index;
    });
    // Show syncing overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomLoader(),
    );
    final child = widget.data[index];
    final recommendedStoryProvider = Provider.of<RecommendedStoryProvider>(
      context,
      listen: false,
    );
    await recommendedStoryProvider.fetchRecommendedStories();
    await ChildLocalStorage.saveCurrentChildId(child.uid);
    await ChildLocalStorage.saveCurrentAvatarUrl(child.avatarUrl);
    if (!mounted) return;
    Navigator.of(context).pop(); // Remove overlay
    final authState = Provider.of<AuthState>(context, listen: false);
    authState.setCurrentChildId(child.uid);

    final childProvider = Provider.of<ChildUserProvider>(
      context,
      listen: false,
    );
    await childProvider.updateScreenTimeEnabledStatusByChildId(child.uid);

    // Navigator.of(context).pop(); // Close the drawer
    // Clear parent logged status when going back to dashboard
    await ParentLocalStorage.setParentLogged(false);
    UserAppBar.setTabIndex(0);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.dashboardScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('total child count: ${widget.totalChildCount}');
    return SizedBox.expand(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: _buildChildProfilesGrid()),
                        Gaps.horizontalGapOf(10),
                      ],
                    ),
                  ),
                ),
              ),
              // Settings section
              Expanded(flex: 1, child: _buildSettingsSection()),
            ],
          ),
          // Close button positioned consistently
          TopRightPositionedCloseButton(
            onTap: () async {
              final isParentLogged = await ParentLocalStorage.isParentLogged();
              logger.d('isParentLogged: $isParentLogged');
              if (isParentLogged) {
                UserAppBar.setTabIndex(0);
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.parentDashboardScreen,
                  (route) => false,
                );
              } else {
                Navigator.pop(context);
              }
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
    final items = List<Widget>.generate(
      widget.data.length + (shouldShowAddChild ? 1 : 0),
      (index) {
        if (index < widget.data.length) {
          final child = widget.data[index];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () {
                  _onChildSelected(index);
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: index == _selectedChildIndex
                          ? AppColors.kPrimaryColor
                          : AppColors.kTransparentColor,
                      width: 2,
                    ),
                  ),
                  child: CustomImage(child.avatarUrl, height: 160, width: 160),
                ),
              ),
              Gaps.verticalGapOf(16),
              GestureDetector(
                onTap: () {
                  _onChildSelected(index);
                },
                child: Text(
                  child.fullName.split(' ')[0],
                  style: AppStyles.text24PxMedium.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ),
              Gaps.verticalGapOf(16),
              Flexible(
                child: customInkwell(
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
                    size: 64,
                    color: AppColors.kYellow,
                  ),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.kWhite,
                    size: 80,
                  ),
                ),
                Gaps.verticalGapOf(8),
                Text(
                  'Add child',
                  style: AppStyles.text18PxMedium.copyWith(
                    color: AppColors.kWhite,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
      child: GridView.count(
        crossAxisCount: 5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.6,
        children: items,
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(color: AppColors.kPurple),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.verticalGapOf(40),

              for (int i = 0; i < drawerSettings.length; i++)
                ListTile(
                  contentPadding: EdgeInsets.only(
                    bottom:
                        MediaQuery.of(context).size.height *
                        0.04, // 4% of screen height
                    left:
                        MediaQuery.of(context).size.width *
                        0.12, // 12% of screen width
                  ),
                  onTap: () {
                    Utility.navigate(context, drawerSettings[i].route);
                  },

                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgHelper.fromSource(
                      path: drawerSettings[i].name == 'Parent Zone'
                          ? Assets.parentZoneIcon(context)
                          : drawerSettings[i].name == 'Printables'
                          ? Assets.downloadIcon(context)
                          : drawerSettings[i].icon,
                      height: 45,
                      width: 45,
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
                    style: AppStyles.text26PxMedium.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
              // Text(
              //   "${GlobalConfig.appVersion} • All rights reserved.",
              //   style: AppStyles.text12PxRegular.copyWith(color: AppColors.kWhite),
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
