import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:onepali/src/core/model/system/setting_model.dart';

class DrawerScreen extends StatefulWidget {
  final List<ChildUserModel> data;
  const DrawerScreen({super.key, required this.data});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  int _selectedChildIndex = -1;

  @override
  void initState() {
    super.initState();
    if (widget.data.isNotEmpty) {
      _selectedChildIndex = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: AppColors.kDrawerBgColor),
            child: Column(
              children: [
                Gaps.verticalGapOf(10),
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
                        size: 20,
                      ),
                    ),
                  ),
                ),
                _buildChildProfilesGrid(),
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
                setState(() {
                  _selectedChildIndex = index;
                });
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        index == _selectedChildIndex
                            ? AppColors.kButtonGreen
                            : AppColors.transparent,
                    width: 2,
                  ),
                ),
                child: CustomImage(child.avatarUrl, height: 60, width: 60),
              ),
            ),
            Gaps.verticalGapOf(8),
            Text(
              child.fullName.split(' ')[0],
              style: AppStyles.text14PxMedium.copyWith(color: AppColors.kWhite),
            ),
            Gaps.verticalGapOf(5),
            const Icon(Icons.local_police, size: 22, color: AppColors.kYellow),
          ],
        );
      } else {
        return GestureDetector(
          onTap: () {},
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
        crossAxisCount: 4,
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
