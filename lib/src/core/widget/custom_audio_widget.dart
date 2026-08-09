import 'package:audioplayers/audioplayers.dart';
import '../../core/enums/app_enums.dart';

class CustomAudioWidget {
  static final Set<CustomAudioWidget> _instances = {};

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

  final String audioPath;
  final AudioSourceType audioSourceType;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPreloaded = false;
  bool _isDisposed = false;
  Source? _cachedSource;

  CustomAudioWidget({
    required this.audioPath,
    this.audioSourceType = AudioSourceType.asset,
  }) {
    _instances.add(this);
  }

  AudioPlayer get audioPlayer => _audioPlayer;

  Source _getSource() {
    if (audioSourceType == AudioSourceType.asset &&
        !audioPath.startsWith('/')) {
      return AssetSource(audioPath);
    } else if (audioPath.startsWith('/')) {
      return DeviceFileSource(audioPath);
    } else {
      return UrlSource(audioPath);
    }
  }

  Future<void> preload() async {
    if (_isPreloaded || _isDisposed) return;

    try {
      _cachedSource = _getSource();
      if (_isDisposed) return;
      await _audioPlayer.setSource(_cachedSource!);
      _isPreloaded = true;
    } catch (e) {
      // Preload failure is non-critical, playback will still work
    }
  }

  Future<void> play() async {
    if (_isDisposed) return;

    final audioContext = AudioContext(
      android: AudioContextAndroid(
        stayAwake: false,
        audioFocus: AndroidAudioFocus.gainTransientMayDuck,
        audioMode: AndroidAudioMode.normal,
        contentType: AndroidContentType.speech,
      ),
      iOS: AudioContextIOS(
        category: AVAudioSessionCategory.playAndRecord,
        options: const {AVAudioSessionOptions.duckOthers},
      ),
    );

    final source = _cachedSource ?? _getSource();

    if (_isDisposed) return;
    await _audioPlayer.play(source, ctx: audioContext);
  }

  Future<void> stop() async {
    if (_isDisposed) return;
    await _audioPlayer.stop();
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    _instances.remove(this);
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
