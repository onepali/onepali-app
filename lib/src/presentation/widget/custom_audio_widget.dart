import 'package:audioplayers/audioplayers.dart';

class CustomAudioWidget {
  final String audioPath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  CustomAudioWidget({required this.audioPath});

  Future<void> play() async {
    await _audioPlayer.play(AssetSource(audioPath));
  }

  Future<void> dispose() async {
    await _audioPlayer.stop();
    await _audioPlayer.dispose();
  }
}
