import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onepali/src/src.dart';

class StoryRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<StoryModel>> fetchStories() async {
    try {
      final querySnapshot = await _firestore.collection('stories').get();
      final List<StoryModel> stories = [];
      for (final doc in querySnapshot.docs) {
        final data = doc.data();
        try {
          stories.add(StoryModel.fromJson(data));
          logger.d('Story added: ${data['thumbnail']}');
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
