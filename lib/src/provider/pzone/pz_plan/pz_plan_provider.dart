// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:onepali/src/src.dart';

// class PzPlanProvider extends ChangeNotifier {
//   DataFetchStatus _status = DataFetchStatus.initial;
//   DataFetchStatus get status => _status;

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   PlanModel? _currentPlan;
//   PlanModel? get currentPlan => _currentPlan;
//   List<PlanModel> _plans = [];
//   List<PlanModel> get plans => _plans;

//   Future<void> fetchPlans() async {
//     setStatus(DataFetchStatus.loading);
//     try {
//       final querySnapshot = await _firestore.collection('plans').get();
//       final List<Map<String, dynamic>> planList =
//           querySnapshot.docs.map((doc) => doc.data()).toList();
//       _plans = planModelFromJson(jsonEncode(planList));
//       await fetchUserPlan();
//       setStatus(DataFetchStatus.success);
//     } catch (e) {
//       handleError('Error fetching plans: $e');
//     }
//   }

//   Future<void> fetchUserPlan() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     final doc = await _firestore.collection('users').doc(user.uid).get();
//     final planId = doc.data()?['plan_id'] ?? 'free';
//     _currentPlan = _plans.firstWhere(
//       (p) => p.id == planId,
//       orElse: () => _plans.firstWhere((p) => p.id == 'free', orElse: () => _plans.first),
//     );
//     notifyListeners();
//   }

//   Future<void> assignPlanToUser(String planId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;
//     await _firestore.collection('users').doc(user.uid).set(
//       {'plan_id': planId},
//       SetOptions(merge: true),
//     );
//     await fetchUserPlan();
//   }

//   void setStatus(DataFetchStatus status) {
//     _status = status;
//     notifyListeners();
//   }

//   void handleError(String error) {
//     _status = DataFetchStatus.error;
//     showCustomToaster(error, isError: true);
//     notifyListeners();
//   }
// }
