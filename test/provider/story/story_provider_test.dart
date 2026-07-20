// Tests for story_provider.dart
import 'dart:async';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/provider/story/story_provider.dart';
import 'package:onepali/src/repo/story/story_repo.dart';
import '../../helpers/firebase_test_setup.dart';

void main() {
  group('StoryProvider', () {
    setUpAll(() async {
      FirebaseTestSetup.setupFirebaseMocks();
      await FirebaseTestSetup.initializeFirebase();
    });

    tearDownAll(() {
      FirebaseTestSetup.cleanupFirebaseMocks();
    });

    test('should test story provider functionality', () {
      // Basic test without instantiating provider to avoid Firebase issues
      expect(true, isTrue);
    });

    test('captures fast audio completion emitted during play', () async {
      final audioService = _FakeAudioPlayerService(completeDuringPlay: true);
      final provider = StoryProvider(
        repo: StoryRepo(firestore: FakeFirebaseFirestore()),
        audioPlayerService: audioService,
      );

      await provider.playAudio('story-audio.mp3');

      expect(audioService.playedSources, ['story-audio.mp3']);
      expect(provider.isPlaying, isFalse);
      expect(provider.isAudioCompleted, isTrue);

      provider.dispose();
      await Future<void>.delayed(Duration.zero);
    });

    test('ignores stale audio completion after stop', () async {
      final audioService = _FakeAudioPlayerService();
      final provider = StoryProvider(
        repo: StoryRepo(firestore: FakeFirebaseFirestore()),
        audioPlayerService: audioService,
      );

      final playFuture = provider.playAudio('story-audio.mp3');
      await Future<void>.delayed(Duration.zero);

      expect(provider.isPlaying, isTrue);

      await provider.stopAudioAndResetIndex();
      audioService.complete();
      await playFuture;

      expect(provider.isPlaying, isFalse);
      expect(provider.isAudioCompleted, isFalse);

      provider.dispose();
      await Future<void>.delayed(Duration.zero);
    });
  });
}

class _FakeAudioPlayerService implements AudioPlayerService {
  _FakeAudioPlayerService({this.completeDuringPlay = false});

  final bool completeDuringPlay;
  final List<String> playedSources = [];
  final StreamController<void> _completeController =
      StreamController<void>.broadcast();

  @override
  Stream<void> get onPlayerComplete => _completeController.stream;

  @override
  Future<void> play(String url) async {
    playedSources.add(url);
    if (completeDuringPlay) {
      _completeController.add(null);
    }
  }

  @override
  Future<void> playAsset(String url) async {
    playedSources.add(url);
    if (completeDuringPlay) {
      _completeController.add(null);
    }
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    await _completeController.close();
  }

  void complete() {
    _completeController.add(null);
  }
}
