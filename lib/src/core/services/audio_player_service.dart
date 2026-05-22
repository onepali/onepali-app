import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';

abstract class AudioPlayerService {
  Stream<void> get onPlayerComplete;
  // Plays audio from a URL or cached file
  Future<void> play(String url);
  Future<void> playAsset(String url);
  Future<void> stop();
  Future<void> dispose();
}


class AudioPlayerServiceImpl implements AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;

  final StreamController<void> _completeController =
      StreamController<void>.broadcast();

  @override
  Stream<void> get onPlayerComplete => _completeController.stream;

  void _listenForCompletionOnce() {
    _completeSubscription?.cancel();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      _completeSubscription?.cancel();
      _completeSubscription = null;
      if (!_completeController.isClosed) {
        _completeController.add(null);
      }
    });
  }

  @override
  Future<void> play(String audioSource) async {
    await stop();
    final cachedFile = await MediaCacheManager.instance.getSingleFile(
      audioSource,
    );
    _listenForCompletionOnce();
    if (cachedFile.existsSync()) {
      await _player.play(DeviceFileSource(cachedFile.path));
    } else {
      await _player.play(UrlSource(audioSource));
    }
  }

  @override
  Future<void> stop() async {
    await _player.stop();
  }


  @override
  Future<void> dispose() async {
    await _completeSubscription?.cancel();
    await _player.dispose();
    await _completeController.close();
  }
  
  @override
  Future<void> playAsset(String url) async {
    await stop();
    _listenForCompletionOnce();
    await _player.play(AssetSource(url));
  }
}
