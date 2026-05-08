import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/model/model.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';

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
    _audioSub?.cancel();
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
    _isQuestionAudioPlaying = false;
    _notifyListenersIfActive();
  }

  void onTappedItem(Conversation conversation) {
    _userSelectedConversation = conversation;
    _isCorrectAnswerSelected = conversation == _currentConversation;
    _notifyListenersIfActive();
  }

  void clearSelection() {
    _userSelectedConversation = null;
    _isCorrectAnswerSelected = false;
    _notifyListenersIfActive();
  }

  @override
  void dispose() {
    _disposed = true;
    _audioSub?.cancel();
    unawaited(_audioPlayerService.dispose());
    super.dispose();
  }
}
