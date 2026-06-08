import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/src.dart';

class ChooseCorrectStoryProvider extends ChangeNotifier {
  Content? _content;
  Content? get content => _content;
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  bool _isQuestionAudioPlaying = false;
  bool _isCorrectAnswerSelected = false;
  bool _disposed = false;
  Conversation? _currentConversation;
  Conversation? _userSelectedConversation;
  bool get isQuestionAudioPlaying => _isQuestionAudioPlaying;
  bool get isCorrectAnswerSelected => _isCorrectAnswerSelected;
  Conversation? get currentConversation => _currentConversation;
  Conversation? get userSelectedConversation => _userSelectedConversation;

  void _notifyListenersIfActive() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  void _cancelAudioSubscription() {
    final audioSub = _audioSub;
    _audioSub = null;
    if (audioSub != null) {
      unawaited(audioSub.cancel());
    }
  }

  void setContent(Content content) {
    _content = content;
    playQuestionAudio();
  }

  void playQuestionAudio() {
    final conversations = content?.conversation ?? const <Conversation>[];
    if (conversations.isEmpty) {
      _currentConversation = null;
      _isQuestionAudioPlaying = false;
      _notifyListenersIfActive();
      return;
    }

    final random = Random();
    _currentConversation = conversations[random.nextInt(conversations.length)];
    final questionAudio = _currentConversation?.question;
    if (questionAudio == null || questionAudio.isEmpty) {
      _isQuestionAudioPlaying = false;
      _notifyListenersIfActive();
      return;
    }

    _isQuestionAudioPlaying = true;
    _notifyListenersIfActive();
    _cancelAudioSubscription();
    _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
      onQuestionAudioCompleted();
    });
    unawaited(
      _audioPlayerService.play(questionAudio).catchError((_) {
        _isQuestionAudioPlaying = false;
        _notifyListenersIfActive();
      }),
    );
  }

  void onQuestionAudioCompleted() {
    _cancelAudioSubscription();
    _isQuestionAudioPlaying = false;
    _notifyListenersIfActive();
  }

  Future<void> onTappedItem(Conversation conversation) async {
    if (_disposed) return;

    _userSelectedConversation = conversation;
    _isCorrectAnswerSelected = conversation == _currentConversation;
    _cancelAudioSubscription();
    _isQuestionAudioPlaying = false;
    _notifyListenersIfActive();

    if (_isCorrectAnswerSelected) {
      await _audioPlayerService.playAsset(Assets.starBlast).catchError((_) {});
      if (_disposed) return;
      final audioItem = conversation.audioItem;
      if (audioItem != null && audioItem.isNotEmpty) {
        await Future.delayed(const Duration(seconds: 1));
        if (_disposed) return;
        unawaited(_audioPlayerService.play(audioItem).catchError((_) {}));
      }
    } else {
      unawaited(
        _audioPlayerService.playAsset(Assets.wrongSfx).catchError((_) {}),
      );
    }
  }

  void resetSelection() {
    _userSelectedConversation = null;
    _isCorrectAnswerSelected = false;
    _notifyListenersIfActive();
  }

  @override
  void dispose() {
    _disposed = true;
    _cancelAudioSubscription();
    unawaited(_audioPlayerService.dispose());
    super.dispose();
  }
}
