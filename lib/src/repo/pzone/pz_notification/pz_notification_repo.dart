import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../src.dart';

class PzNotificationRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fetch notification settings for the current user
  Future<NotificationSettings?> fetchSettings() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc =
        await _firestore
            .collection(AppConstants.notificationSettingCollection)
            .doc(user.uid)
            .get();
    if (doc.exists && doc.data() != null) {
      return NotificationSettings.fromMap(
        doc.data()!['notification_settings'] ?? {},
      );
    }
    return null;
  }

  // Update notification settings for the current user
  Future<void> updateSettings(NotificationSettings settings) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection(AppConstants.notificationSettingCollection)
        .doc(user.uid)
        .set({
          'notification_settings': settings.toMap(),
        }, SetOptions(merge: true));
  }

  // Fetch all notification templates
  Future<List<NotificationTemplate>> fetchTemplates() async {
    final snapshot =
        await _firestore.collection(AppConstants.notificationCollection).get();
    return snapshot.docs
        .map((doc) => NotificationTemplate.fromMap(doc.data()))
        .toList();
  }

  // Fetch notification settings for the current user
  Future<NotificationSettings?> fetchNotificationSettings() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final doc =
        await _firestore
            .collection(AppConstants.notificationSettingCollection)
            .doc(user.uid)
            .get();
    if (doc.exists && doc.data() != null) {
      return NotificationSettings.fromMap(
        doc.data()!['notification_settings'] ?? {},
      );
    }
    return null;
  }

  // Update notification settings for the current user
  Future<void> updateNotificationSettings(NotificationSettings settings) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection(AppConstants.notificationSettingCollection)
        .doc(user.uid)
        .set({
          'notification_settings': settings.toMap(),
        }, SetOptions(merge: true));
  }

  // Fetch all notification templates
  Future<List<NotificationTemplate>> fetchNotificationTemplates() async {
    final snapshot =
        await _firestore.collection(AppConstants.notificationCollection).get();
    return snapshot.docs
        .map((doc) => NotificationTemplate.fromMap(doc.data()))
        .toList();
  }

  Future<void> ensureNotificationSettingsExists() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final docRef = _firestore
        .collection(AppConstants.notificationSettingCollection)
        .doc(user.uid);
    final doc = await docRef.get();
    if (!doc.exists) {
      await docRef.set({
        'notification_settings':
            NotificationSettings(
              isEnabledAll: true,
              isPracticeEnabled: true,
              isProgressReportEnabled: true,
              isNewsEnabled: true,
            ).toMap(),
      });
    }
  }

  // Ensure notifications collection has at least one template
  Future<void> ensureNotificationsCollectionExists() async {
    final snapshot =
        await _firestore
            .collection(AppConstants.notificationCollection)
            .limit(1)
            .get();
    if (snapshot.docs.isEmpty) {
      await _firestore.collection(AppConstants.notificationCollection).add({
        'title': 'Welcome!',
        'body': 'This is your first notification.',
        'publishedDate': DateTime.now().toIso8601String(),
        'seen': false,
      });
    }
  }

  Future<void> ensureCollections() async {
    await ensureNotificationSettingsExists();
    await ensureNotificationsCollectionExists();
  }
}
