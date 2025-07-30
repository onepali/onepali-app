import 'package:audioplayers/audioplayers.dart';
import '../../core/enums/app_enums.dart';

class CustomAudioWidget {
  final String audioPath;
  final AudioSourceType audioSourceType;
  final String _channel;
  late final AudioPlayer _audioPlayer;

  // Static map to manage different audio channels
  static final Map<String, AudioPlayer> _audioPlayers = {};

  // Factory constructor for different audio channels
  factory CustomAudioWidget({
    required String audioPath,
    AudioSourceType audioSourceType = AudioSourceType.asset,
    String channel = 'default',
  }) {
    return CustomAudioWidget._internal(
      audioPath: audioPath,
      audioSourceType: audioSourceType,
      channel: channel,
    );
  }

  // Private constructor
  CustomAudioWidget._internal({
    required this.audioPath,
    required this.audioSourceType,
    required String channel,
  }) : _channel = channel {
    // Get or create audio player for this channel
    _audioPlayer = _audioPlayers.putIfAbsent(channel, () => AudioPlayer());
  }

  // Factory method specifically for star blast audio
  factory CustomAudioWidget.starBlast({
    required String audioPath,
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) {
    return CustomAudioWidget._internal(
      audioPath: audioPath,
      audioSourceType: audioSourceType,
      channel: 'star_blast',
    );
  }

  // Factory method for lesson audio
  factory CustomAudioWidget.lesson({
    required String audioPath,
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) {
    return CustomAudioWidget._internal(
      audioPath: audioPath,
      audioSourceType: audioSourceType,
      channel: 'lesson',
    );
  }

  // Factory method for story audio
  factory CustomAudioWidget.story({
    required String audioPath,
    AudioSourceType audioSourceType = AudioSourceType.asset,
  }) {
    return CustomAudioWidget._internal(
      audioPath: audioPath,
      audioSourceType: audioSourceType,
      channel: 'story',
    );
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  String get channel => _channel;

  Future<void> play() async {
    // Stop any currently playing audio on this channel first
    await _audioPlayer.stop();

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
    // Don't dispose the shared player, just stop it
    // The player will be reused for the same channel
  }

  // Static method to dispose all audio players (for app cleanup)
  static Future<void> disposeAll() async {
    for (final player in _audioPlayers.values) {
      await player.stop();
      await player.dispose();
    }
    _audioPlayers.clear();
  }

  // Static method to dispose a specific channel
  static Future<void> disposeChannel(String channel) async {
    final player = _audioPlayers[channel];
    if (player != null) {
      await player.stop();
      await player.dispose();
      _audioPlayers.remove(channel);
    }
  }

  // Static method to stop a specific channel
  static Future<void> stopChannel(String channel) async {
    final player = _audioPlayers[channel];
    if (player != null) {
      await player.stop();
    }
  }

  // Static method to stop star blast audio specifically
  static Future<void> stopStarBlast() async {
    await stopChannel('star_blast');
  }

  // Static method to stop lesson audio specifically
  static Future<void> stopLesson() async {
    await stopChannel('lesson');
  }

  static Future<void> stopStory() async {
    await stopChannel('story');
  }
}
