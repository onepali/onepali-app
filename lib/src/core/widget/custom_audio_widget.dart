import 'package:audioplayers/audioplayers.dart';
import '../../core/enums/app_enums.dart';

class CustomAudioWidget {
  final String audioPath;
  final AudioSourceType audioSourceType;
  final AudioPlayer _audioPlayer = AudioPlayer();

  CustomAudioWidget({
    required this.audioPath,
    this.audioSourceType = AudioSourceType.asset,
  });

  Future<void> play() async {
    if (audioSourceType == AudioSourceType.asset &&
        !audioPath.startsWith('/')) {
      // Play from bundled assets
      await _audioPlayer.play(AssetSource(audioPath));
    } else if (audioPath.startsWith('/')) {
      // Play from local file (cache)
      await _audioPlayer.play(DeviceFileSource(audioPath));
    } else {
      // Play from network URL
      await _audioPlayer.play(UrlSource(audioPath));
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
