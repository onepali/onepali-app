import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class TabDrawerScreen extends StatefulWidget {
  final List<ChildUserModel> data;
  final int totalChildCount;

  const TabDrawerScreen({
    super.key,
    required this.data,
    required this.totalChildCount,
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
    // Navigator.of(context).pop(); // Close the drawer
    Navigator.of(context).popUntil((route) => route.isFirst);
    UserAppBar.setTabIndex(0);
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    logger.d('total child count: ${widget.totalChildCount}');
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _buildChildProfilesGrid()),

                Gaps.horizontalGapOf(10),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.kButtonGrey,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.kPitchBlack,
                        size: 32,
                      ),
                    ),
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
    final items = List<Widget>.generate(widget.data.length + 1, (index) {
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
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        index == _selectedChildIndex
                            ? AppColors.kPrimaryColor
                            : AppColors.transparent,
                    width: 2,
                  ),
                ),
                child: CustomImage(child.avatarUrl, height: 80, width: 80),
              ),
            ),
            Gaps.verticalGapOf(8),
            Text(
              child.fullName.split(' ')[0],
              style: AppStyles.text14PxMedium.copyWith(color: AppColors.kWhite),
            ),
            Gaps.verticalGapOf(5),
            customInkwell(
              onTap: () {
                Utility.navigateMaterialRoute(
                  context,
                  RewardCollectionWidget(),
                );
              },
              child: const Icon(
                Icons.local_police,
                size: 30,
                color: AppColors.kYellow,
              ),
            ),
          ],
        );
      } else {
        return GestureDetector(
          onTap: () {
            if (widget.totalChildCount >= 3) {
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
              Utility.navigateMaterialRoute(context, ChildRegisterScreen());
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: AppColors.kWhite, size: 36),
              ),
              Gaps.verticalGapOf(8),
              Text(
                'Add child',
                style: AppStyles.text14PxMedium.copyWith(
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: AppColors.kPurple),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int i = 0; i < drawerSettings.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.only(bottom: 8.0),
              onTap: () {
                Utility.navigate(context, drawerSettings[i].route);
              },

              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgHelper.fromSource(
                  path: drawerSettings[i].icon,
                  height: 28,
                  width: 28,
                ),
              ),
              dense: true,
              title: Text(
                drawerSettings[i].name,
                style: AppStyles.text16PxMedium.copyWith(
                  color: AppColors.kWhite,
                ),
              ),
            ),
          const Spacer(),
          Text(
            "${GlobalConfig.appVersion} • All rights reserved.",
            style: AppStyles.text12PxRegular.copyWith(color: AppColors.kWhite),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
