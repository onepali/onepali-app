import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class RS3Screen extends StatefulWidget {
  const RS3Screen({super.key});

  @override
  State<RS3Screen> createState() => _RS3ScreenState();
}

class _RS3ScreenState extends State<RS3Screen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController yobController = TextEditingController();
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '', showStepper: true, currentStep: 3),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Create your Account', style: AppStyles.text20PxSemiBold),
            SizedBox(height: 24),
            TitleActionChild(
              titlePadding: EdgeInsets.only(bottom: 8),

              title: 'Name',
              child: CustomTextField(
                hintText: 'Enter your Full Name',
                keyboardType: TextInputType.name,
                controller: nameController,
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
            ),
            Gaps.verticalGapOf(20),
            TitleActionChild(
              title: 'Year of Birth',

              titlePadding: EdgeInsets.only(bottom: 8),
              child: CustomTextField(
                hintText: 'Enter your Year of Birth',
                isNumberField: true,
                controller: yobController,
                prefixIcon: Icon(Icons.calendar_today_outlined),
                textInputAction: TextInputAction.done,
              ),
            ),
            Gaps.verticalGapOf(5),
            InfoWidget.info('It will be the password for the parent zone.'),
            Spacer(),
            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return CustomMaterialButton(
      label: 'Next',
      onTap: () {
        Utility.navigateMaterialRoute(context, RS4Screen());
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
