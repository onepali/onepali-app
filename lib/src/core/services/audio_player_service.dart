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
  static final Set<AudioPlayerServiceImpl> _instances = {};

  static Future<void> stopAll() async {
    await Future.wait(
      _instances.toList().map((instance) async {
        try {
          await instance.stop();
        } catch (_) {
          // Best-effort route cleanup should not surface stale player errors.
        }
      }),
      eagerError: false,
    );
  }

  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<void>? _completeSubscription;
  int _playbackGeneration = 0;
  bool _isDisposed = false;

  final StreamController<void> _completeController =
      StreamController<void>.broadcast();

  AudioPlayerServiceImpl() {
    _instances.add(this);
  }

  @override
  Stream<void> get onPlayerComplete => _completeController.stream;

  bool _isCurrentPlayback(int generation) {
    return !_isDisposed &&
        !_completeController.isClosed &&
        _playbackGeneration == generation;
  }

  void _listenForCompletionOnce(int generation) {
    _completeSubscription?.cancel();
    _completeSubscription = _player.onPlayerComplete.listen((_) {
      _completeSubscription?.cancel();
      _completeSubscription = null;
      if (_isCurrentPlayback(generation)) {
        _completeController.add(null);
      }
    });
  }

  @override
  Future<void> play(String audioSource) async {
    await stop();
    if (_isDisposed) return;
    final generation = ++_playbackGeneration;
    final cachedFile = await MediaCacheManager.instance.getSingleFile(
      audioSource,
    );
    if (!_isCurrentPlayback(generation)) return;
    _listenForCompletionOnce(generation);
    if (cachedFile.existsSync()) {
      await _player.play(DeviceFileSource(cachedFile.path));
    } else {
      await _player.play(UrlSource(audioSource));
    }
  }

  @override
  Future<void> stop() async {
    _playbackGeneration++;
    await _completeSubscription?.cancel();
    _completeSubscription = null;
    if (_isDisposed) return;
    await _player.stop();
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _playbackGeneration++;
    _instances.remove(this);
    await _completeSubscription?.cancel();
    await _player.stop();
    await _player.dispose();
    await _completeController.close();
  }

  @override
  Future<void> playAsset(String url) async {
    await stop();
    if (_isDisposed) return;
    final generation = ++_playbackGeneration;
    _listenForCompletionOnce(generation);
    await _player.play(AssetSource(url));
  }
}
