import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

abstract class AudioRecorderService {
  /// Starts recording. Throws on permission denied.
  Future<void> startRecording();

  /// Stops recording and returns the file path of the recorded audio.
  Future<String?> stopRecording();

  /// Releases resources.
  Future<void> dispose();
}

/// AndroidManifest.xml:
///   <uses-permission android:name="android.permission.RECORD_AUDIO" />

class AudioRecorderServiceImpl implements AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  String? _outputPath;

  @override
  Future<void> startRecording() async {
    final dir = await getTemporaryDirectory();
    _outputPath =
        '${dir.path}/listen_repeat_${DateTime.now().millisecondsSinceEpoch}.m4a';

    if (!await _recorder.hasPermission()) {
      throw Exception('Microphone permission denied');
    }

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: _outputPath!,
    );
  }

  @override
  Future<String?> stopRecording() async {
    return await _recorder.stop();
  }

  @override
  Future<void> dispose() async {
    await _recorder.dispose();
  }
}
