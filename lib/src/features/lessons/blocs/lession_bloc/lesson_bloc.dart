import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/repository/lesson_repository.dart';

part 'lesson_event.dart';
part 'lesson_state.dart';
part 'lesson_bloc.freezed.dart';

class LessonBloc extends Bloc<LessonEvent, LessonState> {
  // final LessonRepository repository;
  final _wordPlayer = AudioPlayer();
  final _soundPlayer = AudioPlayer();
  LessonBloc() : super(LessonState()) {
    on<_Started>(_onStarted);
    // Info related content events
    on<_PlayInfo>(_onPlayInfo);
    on<_PlayItemAudio>(_onPlayItemAudio);
    // Choose correct related content events
    on<_PlayChooseCorrectItem>(_onPlayChooseCorrectItem);
    on<_ChooseItem>(_onChooseItem);
    // Common events
    on<_NextContent>(_onNextContent);
    on<_PreviousContent>(_onPreviousContent);
  }

  Future<void> _onStarted(_Started event, Emitter<LessonState> emit) async {
    emit(state.copyWith(lessonId: event.lessonId));

    await emit.forEach(
      LessonRepository().watchLessonWithContents(event.lessonId),
      onData: (lessonDetail) {
        lessonDetail.contents.sort((a, b) => a.index.compareTo(b.index));
        return state.copyWith(
          lessonDetails: lessonDetail,
          errorMessage: null,
          currentIndex: 0,
          currentContent: lessonDetail.contents.isNotEmpty
              ? lessonDetail.contents[0]
              : null,
        );
      },
      onError: (error, _) {
        return state.copyWith(errorMessage: error.toString());
      },
    );
  }

  // Info related content events
  Future<void> _onPlayInfo(_PlayInfo event, Emitter<LessonState> emit) async {
    if (state.currentContent == null) return;
    if (state.currentContent is InfoLessonContent) {
      // final audioWord = (state.currentContent as InfoLessonContent).audioWord;
      // final audioBg = (state.currentContent as InfoLessonContent).audioBg;
      // _playAudio(audioBg, _soundPlayer);
    }
  }

  // ------------------------Choose correct related content events------------------------
  void _onPlayChooseCorrectItem(
    _PlayChooseCorrectItem event,
    Emitter<LessonState> emit,
  ) {
    if (state.currentContent == null) return;
    if (state.currentContent is ChooseCorrectLessonContent) {
      emit(
        state.copyWith(
          itemQuestioned: null,
          userSelectedItem: null,
          isAnswerCorrect: null,
        ),
      );
      final items = List<Item>.from(
        (state.currentContent as ChooseCorrectLessonContent).items,
      );
      if (items.isNotEmpty) {
        // select a random item to play audio question
        final randomItem = (items..shuffle()).first;
        emit(state.copyWith(itemQuestioned: randomItem));
        _playAudio(randomItem.question, _soundPlayer);
      }
    }
  }

  void _onChooseItem(_ChooseItem event, Emitter<LessonState> emit) {
    if (state.currentContent == null) return;
    emit(
      state.copyWith(
        userSelectedItem: event.item,
        isAnswerCorrect: state.itemQuestioned == event.item,
      ),
    );
    _playAudio(event.item.audioItem, _soundPlayer);
  }

  void _onPlayItemAudio(_PlayItemAudio event, Emitter<LessonState> emit) async {
    if (state.currentContent == null) return;
    if (state.currentContent is InfoLessonContent) {
      final audioWord = (state.currentContent as InfoLessonContent).audioWord;
      _playAudio(audioWord, _wordPlayer);
    }
  }

  void _playAudio(String url, AudioPlayer audioPlayer) async {
    if (audioPlayer.state == PlayerState.playing) return;
    final file = await DefaultCacheManager().getSingleFile(url);
    log('Cached file: ${file.path}');
    if (file.existsSync()) {
      await audioPlayer.play(DeviceFileSource(file.path));
    } else {
      // cache the file and then play
      await DefaultCacheManager().removeFile(url);
      await audioPlayer.play(UrlSource(url));
    }
  }

  void _onNextContent(_NextContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < lessonDetails.contents.length) {
      final nextContent = lessonDetails.contents[nextIndex];
      emit(
        state.copyWith(
          currentIndex: nextIndex,
          currentContent: nextContent,
          itemQuestioned: null,
          userSelectedItem: null,
          isAnswerCorrect: null,
        ),
      );
    }
  }

  void _onPreviousContent(_PreviousContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final prevIndex = state.currentIndex - 1;
    if (prevIndex >= 0) {
      final prevContent = lessonDetails.contents[prevIndex];
      emit(
        state.copyWith(
          currentIndex: prevIndex,
          currentContent: prevContent,
          itemQuestioned: null,
          userSelectedItem: null,
          isAnswerCorrect: null,
        ),
      );
    }
  }

  // dispose
  @override
  Future<void> close() async {
    log('Disposing LessonBloc');
    await _wordPlayer.dispose();
    await _soundPlayer.dispose();
    return super.close();
  }
}
