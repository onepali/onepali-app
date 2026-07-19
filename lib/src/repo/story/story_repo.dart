import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onepali/src/src.dart';

class StoryRepo {
  final FirebaseFirestore _firestore;

  StoryRepo({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<StoryModel>> fetchStories() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;

    // Check if it's a guest user
    bool isGuest = GuestUtil.isGuestUser();

    if (user == null && !isGuest) {
      logger.e('User is not authenticated and not a guest user.');
      throw Exception("User not signed in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.storiesCollection)
          .get();
      final List<StoryModel> stories = [];
      for (final doc in querySnapshot.docs) {
        try {
          stories.add(StoryModel.fromJson(doc.data()));
        } catch (e, s) {
          logger.d('error ---> $e $s');
        }
      }
      return stories;
    } catch (e) {
      rethrow;
    }
  }
}
