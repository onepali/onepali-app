import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRS3Screen extends StatefulWidget {
  const ChildRS3Screen({super.key});

  @override
  State<ChildRS3Screen> createState() => _ChildRS3ScreenState();
}

class _ChildRS3ScreenState extends State<ChildRS3Screen> {
  @override
  void initState() {
    super.initState();
    Misc.onLayoutRendered(() async {
      final childProvider = context.read<ChildUserProvider>();
      await childProvider.fetchChildUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final childProvider = context.watch<ChildUserProvider>();
    final int childCount = childProvider.totalChildren;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 4,
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Profile created!', style: AppStyles.text20PxSemiBold),
              Gaps.verticalGapOf(10),
              Text(
                'Would you like to create another child\'s profile?',
                style: AppStyles.text14PxRegular,
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(50),
              SvgHelper.fromSource(
                path: Assets.childSuccessSvg,
                height: 180,
                width: 180,
              ),
              Gaps.verticalGapOf(30),
              Text(
                'You can always add it later in the settings',
                style: AppStyles.text14PxRegular,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Gaps.verticalGapOf(30),
            _buildNextButton(context, childCount),
            Gaps.verticalGapOf(30),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, int childCount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomMaterialButton(
          label: 'Create',
          onTap: () {
            if (childCount >= 3) {
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
              Utility.navigate(context, AppRoutes.childRegisterScreen);
            }
          },
          backgroundColor: AppColors.kButtonGreen,
          width: double.infinity,
          elevation: 0,
        ),
        Gaps.verticalGapOf(15),
        CustomMaterialButton(
          label: 'Not Now',
          onTap: () {
            Utility.navigateMaterialRoute(
              context,
              ChildRS4Screen(),
              routeName: AppRoutes.childRS4Screen,
            );
          },
          backgroundColor: AppColors.kButtonGrey,
          textStyle: AppStyles.text16PxMedium.copyWith(color: AppColors.kBlack),
          width: double.infinity,
          elevation: 0,
        ),
      ],
    );
  }
}
