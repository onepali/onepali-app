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
  Conversation? _currentConversation;
  Conversation? _userSelectedConversation;
  bool get isQuestionAudioPlaying => _isQuestionAudioPlaying;
  bool get isCorrectAnswerSelected => _isCorrectAnswerSelected;
  Conversation? get currentConversation => _currentConversation;
  Conversation? get userSelectedConversation => _userSelectedConversation;
  void setContent(Content content) {
    _content = content;
    notifyListeners();
    playQuestionAudio();
  }

  void playQuestionAudio() {
    // choose random conversation from the content.conversation list.
    _isQuestionAudioPlaying = true;
    final random = Random();
    _currentConversation =
        content!.conversation[random.nextInt(content!.conversation.length)];
    notifyListeners();
    if (_currentConversation!.question != null &&
        _currentConversation!.question!.isNotEmpty) {
      _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        onQuestionAudioCompleted();
      });
      _audioPlayerService.play(_currentConversation!.question!);
    }
  }

  void onQuestionAudioCompleted() {
    _isQuestionAudioPlaying = false;
    notifyListeners();
  }

  void onTappedItem(Conversation conversation) {
    _userSelectedConversation = conversation;
    notifyListeners();
    // check if user selected the correct answer
    if (conversation == _currentConversation) {
      _isCorrectAnswerSelected = true;
      _audioPlayerService.playAsset(Assets.starBlast);
    } else {
      _audioPlayerService.playAsset(Assets.wrongSfx);
      _isCorrectAnswerSelected = false;
    }
    notifyListeners();
  }

  void resetSelection() {
    _userSelectedConversation = null;
    _isCorrectAnswerSelected = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _audioSub?.cancel();
    _currentConversation = null;
    _userSelectedConversation = null;
    _isCorrectAnswerSelected = false;
    _isQuestionAudioPlaying = false;
  }
}
