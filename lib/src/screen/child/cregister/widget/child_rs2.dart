import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class ChildRS2Screen extends StatefulWidget {
  const ChildRS2Screen({super.key});

  @override
  State<ChildRS2Screen> createState() => _ChildRS2ScreenState();
}

class _ChildRS2ScreenState extends State<ChildRS2Screen> {
  double selectedRange = 20;

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthState>();
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 3,
        totalSteps: 4,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Would you like to create a daily screen time limit for Dev?',
              style: AppStyles.text20PxSemiBold,
            ),
            Gaps.verticalGapOf(24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.kButtonGrey.withValues(alpha: 0.5),
                ),
              ),
              child: CustomRangeSlider(
                min: 0,
                max: 120,
                value: selectedRange,
                onChanged: (val) {
                  setState(() {
                    selectedRange = val;
                  });
                },
                recommended: selectedRange,
              ),
            ),
            Gaps.verticalGapOf(26),
            Center(
              child: Text(
                'We will notify ${authState.childName} when the time is up.',
                style: AppStyles.text14PxRegular,
                textAlign: TextAlign.end,
              ),
            ),
            Gaps.verticalGapOf(40),

            _buildNextButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    final childProvider = context.read<ChildAuthProvider>();

    return CustomMaterialButton(
      label: 'Next',
      isLoading: childProvider.status == DataFetchStatus.loading,
      onTap: () async {
        final authState = context.read<AuthState>();
        final parentUser = FirebaseAuth.instance.currentUser;
        logger.d('Parent user: ${parentUser?.uid}, ${parentUser?.email}');
        if (parentUser == null) {
          showCustomToaster('No parent user found', isError: true);
          logger.e('No parent user found');
          return;
        }
        logger.d('Selected screen time: $selectedRange');
        // Save screen time to state
        authState.setChildScreenTime(selectedRange);
        // Save child to Firestore
        await childProvider.createChildUser(
          childName: authState.childName ?? "",
          childDob: authState.childDob ?? "",
          screenTime: selectedRange,
          avatarFilePath: authState.childAvatar ?? '',
          parentUid: parentUser.uid,
          parentEmail: parentUser.email ?? '',
        );
        if (context.mounted) {
          showCustomToaster('Child account created successfully');

          Utility.navigateMaterialRoute(context, ChildRS3Screen());
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      elevation: 0,
    );
  }
}
