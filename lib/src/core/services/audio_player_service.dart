import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';

abstract class AudioPlayerService {
  Stream<void> get onPlayerComplete;
  // Plays audio from a URL or cached file
  Future<void> play(String url);
  Future<void> stop();
  Future<void> dispose();
}


class AudioPlayerServiceImpl implements AudioPlayerService {
  // final String audioSource;
  final AudioPlayer _player = AudioPlayer();

  final StreamController<void> _completeController =
      StreamController<void>.broadcast();

  // AudioPlayerServiceImpl._();

  @override
  Stream<void> get onPlayerComplete => _completeController.stream;

  @override
  Future<void> play(String audioSource) async {
    final cachedFile = await MediaCacheManager.instance.getSingleFile(
      audioSource,
    );
    if (cachedFile.existsSync()) {
      await _player.play(DeviceFileSource(cachedFile.path));
    } else {
      await _player.play(UrlSource(audioSource));
    }
    _player.onPlayerComplete.listen((_) => _completeController.add(null));
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }


  @override
  Future<void> dispose() async {
    await _player.dispose();
    await _completeController.close();
  }
}
