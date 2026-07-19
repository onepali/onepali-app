import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

Future<void> navigateAfterParentLogin(
  BuildContext context,
  String? parentUid,
) async {
  if (parentUid == null || parentUid.isEmpty) {
    if (!context.mounted) return;
    Utility.navigate(context, AppRoutes.dashboardScreen);
    return;
  }

  final childSnapshot = await FirebaseFirestore.instance
      .collection(AppConstants.usersCollection)
      .doc(parentUid)
      .collection(AppConstants.childrenCollection)
      .limit(1)
      .get();

  if (!context.mounted) return;
  Utility.navigate(
    context,
    childSnapshot.docs.isEmpty
        ? AppRoutes.childRegisterScreen
        : AppRoutes.dashboardScreen,
  );
}
