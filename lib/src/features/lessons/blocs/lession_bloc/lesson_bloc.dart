import 'dart:async';
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
  StreamSubscription? _subscription;
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
    // Tap to reveal related content events
    on<_PlayTapToReveal>(_onPlayTapToReveal);
    on<_TapToRevealItem>(_onTapToRevealItem);
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
          currentIndex: 0,
          currentContent: lessonDetail.contents.isNotEmpty
              ? lessonDetail.contents[0]
              : null,
        );
      },
      onError: (error, _) {
        log(error.toString());
        return state;
      },
    );
  }

  // Info related content events
  Future<void> _onPlayInfo(_PlayInfo event, Emitter<LessonState> emit) async {
    if (state.currentContent == null) return;
    if (state.currentContent is InfoLessonContent) {
      // final audioWord = (state.currentContent as InfoLessonContent).audioWord;
      final audioBgAvailable =
          (state.currentContent as InfoLessonContent).audioBg != null;
      // if (!audioBgAvailable) {
      // await Future.delayed(const Duration(milliseconds: 700));
      // add(LessonEvent.playItemAudio());
      // }
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
        _playAudio(randomItem.question!, _soundPlayer);
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

  // ------------------------Tap to reveal related content events------------------------
  Future<void> _onPlayTapToReveal(_PlayTapToReveal event, Emitter<LessonState> emit) async {
    if (state.currentContent == null) return;
    if (state.currentContent is TapToRevealLessonContent) {
      // find two different items to play audio which has audio
      final items = List<Item>.from(
        (state.currentContent as TapToRevealLessonContent).items,
      );
      final itemsToPlay = pickTwoRandomItems(items);
      // make first item selected
      emit(
        state.copyWith(
          selectedTapToRevealItem: itemsToPlay.first,
          tapToRevealItems: itemsToPlay,
        ),
      );

      // _playAudio(itemsToPlay.first.question!, _soundPlayer);
       await _soundPlayer.play(UrlSource(itemsToPlay.first.question!));

      print('itemsToPlay: $itemsToPlay');
    }
  }

  Future<void> _onTapToRevealItem(
    _TapToRevealItem event,
    Emitter<LessonState> emit,
  ) async {
    if (state.currentContent == null) return;
    if (state.currentContent is TapToRevealLessonContent) {
      final userTappedItem = event.item;
      final isCorrect = userTappedItem == state.selectedTapToRevealItem;
      if (isCorrect) {
        print('You tapped the corrent item');
        await _soundPlayer.play(AssetSource("tea_maker/music/correct.mp3"));
        // then add this item to completedItems
        final completedItems = List<Item>.from(
          (state.completedTapToRevealItems),
        );
        completedItems.add(userTappedItem);
        // And also remove the item from selectedTapToRevealItem
        final selectedItems = List<Item>.from((state.tapToRevealItems ?? []));
        selectedItems.remove(userTappedItem);
        if (selectedItems.isEmpty) {
          emit(
            state.copyWith(
              isTapToRevealCompleted: true,
              selectedTapToRevealItem: null,
              completedTapToRevealItems: completedItems,
              tapToRevealItems: selectedItems,
            ),
          );
        } else {
          // find next item to play audio

          emit(
            state.copyWith(
              selectedTapToRevealItem: selectedItems.first,
              completedTapToRevealItems: completedItems,
              tapToRevealItems: selectedItems,
              isTapToRevealCompleted:
                  state.completedTapToRevealItems.length == 2,
            ),
          );
          // _playAudio(selectedItems.first.question!, _soundPlayer);
          await _soundPlayer.play(UrlSource(selectedItems.first.question!, ));
        }
      } else {
       
      }

      // _playAudio(event.item.audioItem, _soundPlayer);
    }
  }

  void _onPlayItemAudio(_PlayItemAudio event, Emitter<LessonState> emit) async {
    if (state.currentContent == null) return;
    if (state.currentContent is InfoLessonContent) {
      final audioWord = (state.currentContent as InfoLessonContent).audioWord;
      _playAudio(audioWord, _wordPlayer);
    }
  }

  void _playAudio(String url, AudioPlayer soundPlayer) async {
    if (soundPlayer.state == PlayerState.playing) return;
    final file = await DefaultCacheManager().getSingleFile(url);
    print('Cached file: ${file.path}');
    if (file.existsSync()) {
      await _soundPlayer.play(DeviceFileSource(file.path));
    } else {
      // cache the file and then play
      DefaultCacheManager().removeFile(url);
      await _soundPlayer.play(UrlSource(url));
    }
  }

  void _onNextContent(_NextContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (lessonDetails == null) return;

    final nextIndex = state.currentIndex + 1;
    if (nextIndex < lessonDetails.contents.length) {
      final nextContent = lessonDetails.contents[nextIndex];
      emit(
        state.copyWith(currentIndex: nextIndex, currentContent: nextContent),
      );
    }
  }

  void _onPreviousContent(_PreviousContent event, Emitter<LessonState> emit) {
    final lessonDetails = state.lessonDetails;
    if (_wordPlayer.state == PlayerState.playing) _wordPlayer.stop();
    if (_soundPlayer.state == PlayerState.playing) _soundPlayer.stop();
    if (lessonDetails == null) return;

    final prevIndex = state.currentIndex - 1;
    if (prevIndex >= 0) {
      final prevContent = lessonDetails.contents[prevIndex];
      emit(
        state.copyWith(currentIndex: prevIndex, currentContent: prevContent),
      );
    }
  }

  List<Item> pickTwoRandomItems(List<Item> items) {
    // only items that have a question
    final validItems = items.where((e) => e.question != null).toList();

    if (validItems.length < 2) {
      return [];
    }

    validItems.shuffle();
    return validItems.take(2).toList();
  }

  // dispose
  @override
  Future<void> close() {
    print('Disposing LessonBloc');
    _subscription?.cancel();
    _wordPlayer.dispose();
    _soundPlayer.dispose();
    return super.close();
  }
}
