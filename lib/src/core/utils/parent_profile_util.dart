import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src.dart';

class ParentProfileUtil {
  /// Show parent profile completion popup
  static void showProfileCompletionDialog(
    BuildContext context, {
    bool isFromParentZone = false,
  }) {
    final userProvider = context.read<UserProvider>();
    final missingFields = userProvider.getMissingFields();

    final String missingFieldsText = missingFields.length == 1
        ? missingFields.first
        : missingFields.length == 2
        ? '${missingFields[0]} and ${missingFields[1]}'
        : '${missingFields.sublist(0, missingFields.length - 1).join(', ')}, and ${missingFields.last}';

    DialogManager.showCustomDialog(
      context: context,
      title: 'Complete Your Profile',
      content: '',
      confirmButtonText: 'Update Profile',
      image: Assets.profileUpdateSvg,
      hasSingleButton: true,
      isSvg: true,
      barrierDismissible: false,
      onConfirm: () async {
        Navigator.of(context).pop();
        await Future.delayed(Duration(milliseconds: 200));

        if (context.mounted) {
          logger.d('Navigating to UserScreen after dialog close');
          Utility.navigateMaterialRoute(
            context,
            UserScreen(isFromParentZone: isFromParentZone),
            routeName: AppRoutes.parentProfileScreen,
          );
        }
      },
    );
  }

  static bool checkAndShowProfileCompletion(BuildContext context) {
    logger.d('Checking parent profile completion status');
    final userProvider = context.read<UserProvider>();
    logger.d('UserProvider status: ${userProvider.status}');
    logger.d('UserProvider user data: ${userProvider.user?.toJson()}');

    // Don't show for guest users
    if (GuestUtil.isGuestUser()) {
      logger.d('Skipping profile check - guest user detected');
      return true;
    }

    // If user data is still loading or in error state, wait and try again
    if (userProvider.status == DataFetchStatus.loading ||
        userProvider.status == DataFetchStatus.error ||
        userProvider.user == null) {
      if (userProvider.status == DataFetchStatus.error) {
        logger.w(
          '⚠️ User data fetch failed, retrying fetch and check in 2 seconds...',
        );
        Future.delayed(Duration(seconds: 2), () async {
          if (context.mounted) {
            // Try to fetch the profile again
            await context.read<UserProvider>().fetchOwnProfile();
            if (context.mounted) {
              checkAndShowProfileCompletion(context);
            }
          }
        });
      } else {
        logger.d('User data still loading, retrying in 1 second...');
        Future.delayed(Duration(seconds: 1), () {
          if (context.mounted) {
            checkAndShowProfileCompletion(context);
          }
        });
      }
      return true;
    }

    if (!userProvider.hasCompleteProfile()) {
      logger.w('👤 Parent profile incomplete - showing completion dialog');

      Misc.onLayoutRendered(() {
        if (context.mounted) {
          showProfileCompletionDialog(context);
        }
      });

      return false;
    }

    logger.d('✅ Parent profile complete');
    return true;
  }
}
