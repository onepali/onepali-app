import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:onepali/src/src.dart';

class DrawerScreen extends StatefulWidget {
  final List<ChildUserModel> data;
  final int totalChildCount;
  final AuthProviderType? authProviderType;
  const DrawerScreen({
    super.key,
    required this.data,
    required this.totalChildCount,
    this.authProviderType,
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
              child: Column(children: [_buildChildProfilesGrid()]),
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
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                setState(() {
                  _selectedChildIndex = index;
                });

                await ChildLocalStorage.saveCurrentChildId(child.uid);
                await ChildLocalStorage.saveCurrentAvatarUrl(child.avatarUrl);
                if (!mounted) return;

                final authState = Provider.of<AuthState>(
                  context,
                  listen: false,
                );
                authState.setCurrentChildId(child.uid);

                // Navigator.of(context).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
                UserAppBar.setTabIndex(0);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => DashboardScreen()),
                );
              },
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        index == _selectedChildIndex
                            ? AppColors.kPrimaryColor
                            : AppColors.transparent,
                    width: 3,
                  ),
                ),
                child: CustomImage(child.avatarUrl, height: 55, width: 55),
              ),
            ),
            Gaps.horizontalGapOf(15),
            Text(
              child.fullName.split(' ')[0],
              style: AppStyles.text20PxMedium.copyWith(color: AppColors.kWhite),
            ),
            Gaps.horizontalGapOf(5),
            const Icon(Icons.local_police, size: 22, color: AppColors.kYellow),
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
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 50,
                width: 50,
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: items[index],
          );
        },
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
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.only(right: 4, top: 8),
                decoration: BoxDecoration(
                  color: AppColors.kButtonGrey,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close,
                  color: AppColors.kPitchBlack,
                  size: 24,
                ),
              ),
            ),
          ),
          for (int i = 0; i < drawerSettings.length; i++)
            ListTile(
              contentPadding: const EdgeInsets.only(bottom: 8.0),
              onTap: () {
                if (drawerSettings[i].route == AppRoutes.comingSoon) {
                  showCustomToaster('This feature is coming soon.');
                  return;
                }
                Utility.navigate(context, drawerSettings[i].route);
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
    );
  }
}
