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

    // Platform responsive variables
    final bool isTabletPortrait = PlatformUtility.isTabletPortrait(context);

    // Responsive sizing and styling
    final double horizontalPadding = isTabletPortrait ? 32.0 : 16.0;
    final double titleBottomGap = isTabletPortrait ? 32.0 : 24.0;
    final double sliderBottomGap = isTabletPortrait ? 36.0 : 26.0;
    final double nextButtonGap = isTabletPortrait ? 50.0 : 40.0;
    final double buttonSpacing = isTabletPortrait ? 25.0 : 20.0;
    final double buttonHeight = isTabletPortrait ? 56.0 : 48.0;
    final double buttonRadius = isTabletPortrait ? 12.0 : 8.0;

    final TextStyle titleStyle = isTabletPortrait
        ? AppStyles.text24PxSemiBold
        : AppStyles.text20PxSemiBold;

    final TextStyle noteStyle = isTabletPortrait
        ? AppStyles.text16PxRegular
        : AppStyles.text14PxRegular;

    final TextStyle buttonTextStyle = isTabletPortrait
        ? AppStyles.text18PxMedium
        : AppStyles.text16PxMedium;

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showStepper: true,
        currentStep: 3,
        totalSteps: 5,
      ),
      backgroundColor: AppColors.kWhite,
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Would you like to create a daily screen time limit for ${authState.childName}?',
                style: titleStyle,
              ),
              Gaps.verticalGapOf(titleBottomGap),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.kButtonGrey.withValues(alpha: 0.5),
                  ),
                ),
                child: CustomRangeSlider(
                  min: 5,
                  max: 120,
                  value: selectedRange,
                  fiveMinuteSteps: true,
                  onChanged: (val) {
                    setState(() {
                      selectedRange = val;
                    });
                  },
                  recommended: selectedRange,
                ),
              ),
              Gaps.verticalGapOf(sliderBottomGap),
              Center(
                child: Text(
                  'We will notify ${authState.childName} when the time is up.',
                  style: noteStyle,
                  textAlign: TextAlign.center,
                ),
              ),
              Gaps.verticalGapOf(nextButtonGap),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: horizontalPadding,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNextButton(
                context,
                isTabletPortrait,
                buttonTextStyle,
                buttonHeight,
                buttonRadius,
              ),
              Gaps.verticalGapOf(buttonSpacing),
              _buildNotNowButton(
                context,
                isTabletPortrait,
                buttonTextStyle,
                buttonHeight,
                buttonRadius,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(
    BuildContext context,
    bool isTabletPortrait,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
    final childProvider = context.watch<ChildAuthProvider>();
    final childUserProvider = context.watch<ChildUserProvider>();

    return CustomMaterialButton(
      label: 'Next',
      isLoading: childProvider.status == DataFetchStatus.loading,
      onTap: () async {
        final authState = context.read<AuthState>();
        final parentUser = FirebaseAuth.instance.currentUser;
        logger.d('👤 Parent user: ${parentUser?.uid}, ${parentUser?.email}');
        if (parentUser == null) {
          showCustomToaster(
            'No parent user found. Please log in again.',
            isError: true,
          );
          logger.e('❌ No parent user found');
          return;
        }

        // Verify user is still authenticated before proceeding
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null || currentUser.uid != parentUser.uid) {
          showCustomToaster(
            'Authentication error. Please log in again.',
            isError: true,
          );
          logger.e('❌ Authentication state changed during child creation');
          return;
        }

        logger.d('Selected screen time: $selectedRange');
        // Save screen time to state
        authState.setChildScreenTime(selectedRange);

        try {
          // Save child to Firestore and get the child ID
          final childId = await childProvider.createChildUser(
            childName: authState.childName ?? "",
            childDob: authState.childDob ?? "",
            screenTime: selectedRange,
            hasScreenTime: true, // User has set up screen time
            avatarFilePath: authState.childAvatar ?? '',
            parentUid: parentUser.uid,
            parentEmail: parentUser.email ?? '',
          );

          if (childId == null) {
            throw Exception('Child creation returned null ID');
          }

          logger.d(
            '👶 Created child with ID: $childId, now fetching children...',
          );

          // Fetch children with retry logic, specifically waiting for the newly created child
          await childUserProvider.fetchChildUser(
            maxRetries: 5, // More retries for newly created children
            retryDelayMs: 600, // Slightly longer delay
            expectedChildId: childId, // Wait for this specific child
          );

          // Verify the child is in the list
          final children = childUserProvider.childUser;
          final foundChild = children.any((child) => child.uid == childId);
          if (!foundChild) {
            logger.w(
              '⚠️ Created child $childId not found in fetched list, but continuing...',
            );
            // Don't throw error - child might appear later, and we don't want to block the user
          } else {
            logger.d(
              '✅ Created child $childId successfully found in fetched list',
            );
          }

          if (context.mounted) {
            showCustomToaster('Child account created successfully');
            Utility.navigateMaterialRoute(
              context,
              ChildRS3Screen(),
              routeName: AppRoutes.childRS3Screen,
            );
          }
        } catch (e) {
          logger.e('❌ Error creating child: $e');
          if (context.mounted) {
            showCustomToaster(
              'Failed to create child account. Please try again.',
              isError: true,
            );
          }
        }
      },
      backgroundColor: AppColors.kButtonGreen,
      width: double.infinity,
      textStyle: buttonTextStyle,
      height: buttonHeight,
      radius: buttonRadius,
      elevation: 0,
    );
  }

  Widget _buildNotNowButton(
    BuildContext context,
    bool isTabletPortrait,
    TextStyle buttonTextStyle,
    double buttonHeight,
    double buttonRadius,
  ) {
    return CustomMaterialButton(
      onTap: () async {
        final authState = context.read<AuthState>();
        final childProvider = context.read<ChildAuthProvider>();
        final childUserProvider = context.read<ChildUserProvider>();
        final parentUser = FirebaseAuth.instance.currentUser;

        if (parentUser == null) {
          showCustomToaster(
            'No parent user found. Please log in again.',
            isError: true,
          );
          logger.e('❌ No parent user found');
          return;
        }

        // Verify user is still authenticated before proceeding
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null || currentUser.uid != parentUser.uid) {
          showCustomToaster(
            'Authentication error. Please log in again.',
            isError: true,
          );
          logger.e('❌ Authentication state changed during child creation');
          return;
        }

        authState.setChildScreenTime(0);
        logger.d('Not now selected - setting screen time to 0 (no limit)');

        try {
          // Save child to Firestore and get the child ID
          final childId = await childProvider.createChildUser(
            childName: authState.childName ?? "",
            childDob: authState.childDob ?? "",
            screenTime: 0,
            hasScreenTime: false,
            avatarFilePath: authState.childAvatar ?? '',
            parentUid: parentUser.uid,
            parentEmail: parentUser.email ?? '',
          );

          if (childId == null) {
            throw Exception('Child creation returned null ID');
          }

          logger.d(
            '👶 Created child with ID: $childId, now fetching children...',
          );

          // Fetch children with retry logic, specifically waiting for the newly created child
          await childUserProvider.fetchChildUser(
            maxRetries: 5, // More retries for newly created children
            retryDelayMs: 600, // Slightly longer delay
            expectedChildId: childId, // Wait for this specific child
          );

          // Verify the child is in the list
          final children = childUserProvider.childUser;
          final foundChild = children.any((child) => child.uid == childId);
          if (!foundChild) {
            logger.w(
              '⚠️ Created child $childId not found in fetched list, but continuing...',
            );
            // Don't throw error - child might appear later, and we don't want to block the user
          } else {
            logger.d(
              '✅ Created child $childId successfully found in fetched list',
            );
          }

          if (context.mounted) {
            showCustomToaster('Child account created successfully');
            Utility.navigateMaterialRoute(
              context,
              ChildRS3Screen(),
              routeName: AppRoutes.childRS3Screen,
            );
          }
        } catch (e) {
          logger.e('❌ Error creating child: $e');
          if (context.mounted) {
            showCustomToaster(
              'Failed to create child account. Please try again.',
              isError: true,
            );
          }
        }
      },
      label: 'Not now',
      isLoading:
          context.watch<ChildAuthProvider>().status == DataFetchStatus.loading,
      showBorder: false,
      elevation: 0,
      fillButton: true,
      backgroundColor: AppColors.kButtonGrey,
      textStyle: buttonTextStyle.copyWith(color: AppColors.kBlack),
      height: buttonHeight,
      radius: buttonRadius,
    );
  }
}
