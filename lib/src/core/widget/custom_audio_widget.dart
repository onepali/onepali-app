import 'package:audioplayers/audioplayers.dart';
import '../../core/enums/app_enums.dart';

class CustomAudioWidget {
  final String audioPath;
  final AudioSourceType audioSourceType;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPreloaded = false;
  Source? _cachedSource;

  CustomAudioWidget({
    required this.audioPath,
    this.audioSourceType = AudioSourceType.asset,
  });

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
    if (_isPreloaded) return;

    try {
      _cachedSource = _getSource();
      await _audioPlayer.setSource(_cachedSource!);
      _isPreloaded = true;
    } catch (e) {
      // Preload failure is non-critical, playback will still work
    }
  }

  Future<void> play() async {
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

    await _audioPlayer.play(source, ctx: audioContext);
  }

  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
