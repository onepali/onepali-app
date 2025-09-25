import 'package:flutter/material.dart';
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
    UserAppBar.setTabIndex(0);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.dashboardScreen, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('total child count: ${widget.totalChildCount}');
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildChildProfilesGrid()),

                Gaps.horizontalGapOf(10),
                Align(
                  alignment: Alignment.topRight,
                  child: CircularButtonWidget(
                    type: CircularButtonType.closeGrey,
                    onPressed: () async {
                      final isParentLogged =
                          await ParentLocalStorage.isParentLogged();
                      logger.d('isParentLogged: $isParentLogged');
                      if (isParentLogged) {
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
          // Settings section
          Expanded(child: _buildSettingsSection()),
        ],
      ),
    );
  }

  Widget _buildChildProfilesGrid() {
    // Show 'Add Child' if in parent zone OR if no children exist in child dashboard
    final shouldShowAddChild =
        widget.isParent || (widget.data.isEmpty && !widget.isParent);
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
              Text(
                child.fullName.split(' ')[0],
                style: AppStyles.text24PxMedium.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
              Gaps.verticalGapOf(16),
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
                  size: 64,
                  color: AppColors.kYellow,
                ),
              ),
            ],
          );
        } else {
          // Show 'Add Child' if in parent zone OR if no children exist in child dashboard
          return GestureDetector(
            onTap: () {
              if (widget.totalChildCount >= 3 && !GlobalConfig.isUserTesting) {
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
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      decoration: BoxDecoration(color: AppColors.kPurple),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gaps.verticalGapOf(40),

          for (int i = 0; i < drawerSettings.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.only(bottom: 30.0, left: 45.0),
              onTap: () {
                Utility.navigate(context, drawerSettings[i].route);
              },

              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgHelper.fromSource(
                  path: drawerSettings[i].icon,
                  height: 45,
                  width: 45,
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
          const Spacer(),
          // Text(
          //   "${GlobalConfig.appVersion} • All rights reserved.",
          //   style: AppStyles.text12PxRegular.copyWith(color: AppColors.kWhite),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
