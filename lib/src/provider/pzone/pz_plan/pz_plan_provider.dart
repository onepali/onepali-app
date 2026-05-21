import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onepali/src/src.dart';

class PzPlanProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PzPlanModel? _currentPlan;
  PzPlanModel? get currentPlan => _currentPlan;
  List<PzPlanModel> _plans = [];
  List<PzPlanModel> get plans => _plans;
  DateTime? _activeDate;
  DateTime? get activeDate => _activeDate;
  DateTime? _expiryDate;
  DateTime? get expiryDate => _expiryDate;

  Future<void> fetchPlans() async {
    setStatus(DataFetchStatus.loading);
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.planCollection)
          .get();
      final List<Map<String, dynamic>> planList = querySnapshot.docs
          .map((doc) => doc.data())
          .toList();
      _plans = pzPlanModelFromJson(jsonEncode(planList));
      await fetchUserPlan();
      setStatus(DataFetchStatus.success);
    } catch (e) {
      handleError('Error fetching plans: $e');
    }
  }

  Future<void> fetchUserPlan() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();
    final data = doc.data() ?? {};
    final planId = data['plan_id'] ?? 'free';
    _currentPlan = _plans.firstWhere(
      (p) => p.id == planId,
      orElse: () => _plans.firstWhere(
        (p) => p.id == 'free',
        orElse: () => _plans.isNotEmpty
            ? _plans.first
            : PzPlanModel(
                id: 'free',
                name: 'Free Plan',
                price: 0,
                currency: 'USD',
                billingCycle: 'monthly',
                description: 'Free forever, no credit card required',
              ),
      ),
    );
    _activeDate = data['plan_active_date'] != null
        ? DateTime.tryParse(data['plan_active_date'])
        : null;
    _expiryDate = data['plan_expiry_date'] != null
        ? DateTime.tryParse(data['plan_expiry_date'])
        : null;
    notifyListeners();
  }

  Future<void> assignPlanToUser(
    String planId, {
    int durationInDays = 30,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final now = DateTime.now();
    final expiry = now.add(Duration(days: durationInDays));
    final plan = _plans.firstWhere(
      (p) => p.id == planId,
      orElse: () => _plans.first,
    );
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set({
          'plan_id': planId,
          'plan_name': plan.name,
          'plan_active_date': now.toIso8601String(),
          'plan_expiry_date': expiry.toIso8601String(),
        }, SetOptions(merge: true));
    await fetchUserPlan();
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }
}
