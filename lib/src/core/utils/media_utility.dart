import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';
import '../../../navigator_key.dart';

class MediaUtility {
  static Future<String> uploadAvatarImage(
    String filePath,
    String childId,
  ) async {
    if (filePath.startsWith('assets/')) {
      try {
        final byteData = await DefaultAssetBundle.of(
          navigatorKey.currentContext!,
        ).load(filePath);
        final tempDir = await Directory.systemTemp.createTemp();
        final tempFile = File('${tempDir.path}/$childId.png');
        await tempFile.writeAsBytes(byteData.buffer.asUint8List());
        filePath = tempFile.path;
      } catch (e) {
        throw Exception(
          'Failed to load avatar asset: '
          '\$filePath. Please check asset path and pubspec.yaml.',
        );
      }
    }
    final storageRef = FirebaseStorage.instance.ref().child(
      'avatars/$childId.png',
    );
    final uploadTask = storageRef.putFile(File(filePath));
    final snapshot = await uploadTask.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();
    return url;
  }
}
