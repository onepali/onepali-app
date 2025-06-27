import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

class SystemProvider extends ChangeNotifier {
  DataFetchStatus _status = DataFetchStatus.initial;
  DataFetchStatus get status => _status;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AboutModel? _aboutData;
  ContactModel? _contactData;
  final List<FaqModel> _faqsData = [];

  AboutModel? get aboutData => _aboutData;
  ContactModel? get contactData => _contactData;
  List<FaqModel> get faqsData => _faqsData;

  Future<void> fetchSystemData() async {
    setStatus(DataFetchStatus.loading);
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    if (user == null) {
      logger.e('User is not authenticated.');
      handleError("User not signed in.");
      return;
    }

    try {
      // Fetch About data
      final aboutDoc =
          await _firestore.collection('onepali').doc('about').get();
      if (aboutDoc.exists && aboutDoc.data() != null) {
        _aboutData = AboutModel.fromJson(aboutDoc.data()!);
      }

      // Fetch Contact data
      final contactDoc =
          await _firestore.collection('onepali').doc('contact').get();
      if (contactDoc.exists && contactDoc.data() != null) {
        _contactData = ContactModel.fromJson(contactDoc.data()!);
      }

      // Fetch FAQs data
      final faqsDoc = await _firestore.collection('onepali').doc('faqs').get();
      if (faqsDoc.exists && faqsDoc.data() != null) {
        final faqsMap = faqsDoc.data()!;
        _faqsData.clear();
        faqsMap.forEach((key, value) {
          if (value is String) {
            // key is the title, value is the answer
            _faqsData.add(FaqModel.fromJson({'title': key, 'answer': value}));
          } else if (value is Map<String, dynamic> &&
              value.containsKey('title')) {
            // Handle case where value might have nested structure
            _faqsData.add(
              FaqModel.fromJson({
                'title': key,
                'answer': value['title'] ?? value.toString(),
              }),
            );
          }
        });
      }

      setStatus(DataFetchStatus.success);
    } catch (e) {
      logger.e('Error fetching system data: $e');
      handleError(e.toString());
    }
  }

  void handleError(String error) {
    _status = DataFetchStatus.error;
    showCustomToaster(error, isError: true);
    notifyListeners();
  }

  void setStatus(DataFetchStatus status) {
    _status = status;
    notifyListeners();
  }
}
