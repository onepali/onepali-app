import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:onepali/src/core/constants/assets.dart';
import 'package:onepali/src/core/model/model.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';

class ChooseCorrectStoryProvider extends ChangeNotifier {
  ChooseCorrectStoryProvider({AudioPlayerService? audioPlayerService})
    : _audioPlayerService = audioPlayerService ?? AudioPlayerServiceImpl();

  Content? _content;
  Content? get content => _content;
  final AudioPlayerService _audioPlayerService;
  StreamSubscription<void>? _audioSub;
  bool _isQuestionAudioPlaying = false;
  bool _isCorrectAnswerSelected = false;
  bool _isCorrectFeedbackCompleted = false;
  bool _disposed = false;
  int _selectionGeneration = 0;
  Future<void>? _selectionAudioFuture;
  Conversation? _currentConversation;
  Conversation? _userSelectedConversation;
  bool get isQuestionAudioPlaying => _isQuestionAudioPlaying;
  bool get isCorrectAnswerSelected => _isCorrectAnswerSelected;
  bool get isCorrectFeedbackCompleted => _isCorrectFeedbackCompleted;
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

  void onTappedItem(Conversation conversation) {
    if (_disposed) return;

    final selectionGeneration = ++_selectionGeneration;
    _userSelectedConversation = conversation;
    _isCorrectAnswerSelected = conversation == _currentConversation;
    _isCorrectFeedbackCompleted = false;
    _cancelAudioSubscription();
    _isQuestionAudioPlaying = false;
    _selectionAudioFuture = _playSelectionAudio(
      conversation,
      isCorrect: _isCorrectAnswerSelected,
      selectionGeneration: selectionGeneration,
    );
    unawaited(_selectionAudioFuture);
    _notifyListenersIfActive();
  }

  Future<void> _playSelectionAudio(
    Conversation conversation, {
    required bool isCorrect,
    required int selectionGeneration,
  }) async {
    final feedbackAsset = isCorrect ? Assets.starBlast : Assets.wrongSfx;
    final feedbackComplete = _audioPlayerService.onPlayerComplete.first.timeout(
      const Duration(seconds: 3),
      onTimeout: () {},
    );

    var didStartFeedback = false;
    try {
      await _audioPlayerService.playAsset(feedbackAsset);
      didStartFeedback = true;
    } catch (_) {}

    if (didStartFeedback) {
      await feedbackComplete.catchError((_) {});
    }

    if (!_isCurrentSelection(selectionGeneration)) {
      return;
    }

    final audioItem = conversation.audioItem;
    if (audioItem != null && audioItem.isNotEmpty) {
      final itemComplete = _audioPlayerService.onPlayerComplete.first.timeout(
        const Duration(seconds: 5),
        onTimeout: () {},
      );
      try {
        await _audioPlayerService.play(audioItem);
        await itemComplete.catchError((_) {});
      } catch (_) {}
    }

    if (!_isCurrentSelection(selectionGeneration)) {
      return;
    }

    if (isCorrect) {
      _isCorrectFeedbackCompleted = true;
      _notifyListenersIfActive();
    }
  }

  Future<void> waitForSelectionAudio() {
    return _selectionAudioFuture ?? Future<void>.value();
  }

  bool _isCurrentSelection(int selectionGeneration) {
    return !_disposed && selectionGeneration == _selectionGeneration;
  }

  void _cancelSelectionPlayback() {
    _selectionGeneration++;
    _isCorrectFeedbackCompleted = false;
    unawaited(_audioPlayerService.stop().catchError((_) {}));
  }

  void clearSelection() {
    _cancelSelectionPlayback();
    _userSelectedConversation = null;
    _isCorrectAnswerSelected = false;
    _notifyListenersIfActive();
  }

  @override
  void dispose() {
    _disposed = true;
    _selectionGeneration++;
    _cancelAudioSubscription();
    unawaited(_audioPlayerService.dispose());
    super.dispose();
  }
}
