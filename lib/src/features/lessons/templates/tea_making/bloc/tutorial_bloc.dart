import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';
part 'tutorial_bloc.freezed.dart';

/// Ingredients with an empty [Item.image] are instruction-only (no drag).
bool ingredientHasImage(Item item) => item.image.trim().isNotEmpty;

bool ingredientHasPronunciation(Item item) {
  final audio = item.audioItem?.trim();
  return audio != null && audio.isNotEmpty;
}

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  static const Duration _completionDelay = Duration(seconds: 2);

  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;
  bool _isFinishingIngredientStep = false;

  TutorialBloc() : super(TutorialState()) {
    on<TutorialEvent>((event, emit) async {
      await event.map(
        started: (e) async => _onStarted(e, emit),
        instructionAudioCompleted: (e) async =>
            _onInstructionAudioCompleted(emit),
        hunchaButtonPressed: (e) async => _onHunchaButtonPressed(emit),
        hunchaAudioCompleted: (e) async => _onHunchaAudioCompleted(emit),
        guideAudioCompleted: (e) async => _onGuideAudioCompleted(emit),
        itemDropped: (e) async => _onItemDropped(e.item, emit),
        itemAudioCompleted: (e) async => _onItemAudioCompleted(emit),
        processInstructionOnlyStep: (e) async =>
            _onProcessInstructionOnlyStep(emit),
        ideal: (e) async => _onIdeal(e, emit),
        completed: (e) async => _onCompleted(emit),
      );
    });
  }

  bool _isCurrentItem(Item item) {
    final current = state.currentItem;
    return current != null &&
        item.nameEn == current.nameEn &&
        item.nameNp == current.nameNp;
  }

  Future<void> _completeLesson(
    Emitter<TutorialState> emit, {
    int? currentIndex,
  }) async {
    final teaReadySound = state.content?.teaReadySound.trim() ?? '';

    emit(
      state.copyWith(
        status: TutorialStatus.completed,
        currentIndex: currentIndex ?? state.currentIndex,
      ),
    );

    // Let leopard/confetti paint before starting audio work.
    await Future<void>.delayed(Duration.zero);

    if (teaReadySound.isNotEmpty) {
      unawaited(_playTeaReadySound(teaReadySound));
    }
  }

  Future<void> _playTeaReadySound(String url) async {
    try {
      await _audioSub?.cancel();
      await _audioPlayerService.play(url);
    } catch (e, stackTrace) {
      log('Failed to play teaReadySound: $e', stackTrace: stackTrace);
    }
  }

  /// One-shot listen; avoids stacked [onPlayerComplete] subscribers.
  Future<void> _playAudioAwait(Future<void> Function() play) async {
    await _audioSub?.cancel();
    await _audioPlayerService.stop();

    final completer = Completer<void>();
    _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    });
    try {
      await play();
      await completer.future.timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          log('Audio playback timed out waiting for completion');
        },
      );
    } finally {
      await _audioSub?.cancel();
      _audioSub = null;
    }
  }

  Future<void> _onStarted(_Started event, Emitter<TutorialState> emit) async {
    final content = event.content;
    final ingredients = content.ingredients.toList()
      ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    emit(state.copyWith(content: content.copyWith(ingredients: ingredients)));
    emit(state.copyWith(status: TutorialStatus.instructionPlaying));
    await _playAudioAwait(
      () => _audioPlayerService.play(content.audioInstruction),
    );
    if (!emit.isDone) {
      await _onInstructionAudioCompleted(emit);
    }
  }

  Future<void> _onInstructionAudioCompleted(Emitter<TutorialState> emit) async {
    emit(
      state.copyWith(
        status: TutorialStatus.instructionCompleted,
        showHunchButton: true,
      ),
    );
  }

  Future<void> _onHunchaButtonPressed(Emitter<TutorialState> emit) async {
    emit(
      state.copyWith(
        status: TutorialStatus.hunchaPressed,
        showHunchButton: false,
      ),
    );
    emit(state.copyWith(status: TutorialStatus.hunchaAudioPlaying));
    final hunchaAudio = state.content?.abaPaniUmalaSound.trim() ?? '';
    if (hunchaAudio.isNotEmpty) {
      await _playAudioAwait(() => _audioPlayerService.play(hunchaAudio));
    }
    if (!emit.isDone) {
      await _onHunchaAudioCompleted(emit);
    }
  }

  Future<void> _onHunchaAudioCompleted(Emitter<TutorialState> emit) async {
    if (state.content == null) return;
    emit(
      state.copyWith(
        status: TutorialStatus.hunchaAudioCompleted,
        showHunchButton: false,
      ),
    );
    await _playGuideForCurrentItem(emit);
  }

  Future<void> _playGuideForCurrentItem(Emitter<TutorialState> emit) async {
    if (state.content == null) return;
    final currentItem = state.content!.ingredients[state.currentIndex];
    emit(
      state.copyWith(
        currentItem: currentItem,
        status: TutorialStatus.guidePlaying,
      ),
    );

    final question = currentItem.question?.trim();
    if (question == null || question.isEmpty) {
      if (!emit.isDone) {
        await _onGuideAudioCompleted(emit);
      }
      return;
    }

    await _playAudioAwait(() => _audioPlayerService.play(question));
    if (!emit.isDone) {
      await _onGuideAudioCompleted(emit);
    }
  }

  Future<void> _onGuideAudioCompleted(Emitter<TutorialState> emit) async {
    final item = state.currentItem;
    if (item == null) {
      emit(state.copyWith(status: TutorialStatus.ideal));
      return;
    }

    // Instruction-only steps run in a separate event so we do not chain
    // multiple ingredients inside one handler stack.
    if (!ingredientHasImage(item)) {
      if (!isClosed) {
        add(const TutorialEvent.processInstructionOnlyStep());
      }
      return;
    }

    emit(state.copyWith(status: TutorialStatus.ideal));
  }

  Future<void> _onProcessInstructionOnlyStep(
    Emitter<TutorialState> emit,
  ) async {
    final item = state.currentItem;
    if (item == null || ingredientHasImage(item)) return;
    await _processItemCompletion(item, emit);
  }

  Future<void> _onItemDropped(Item item, Emitter<TutorialState> emit) async {
    if (!_isCurrentItem(item)) return;
    if (!ingredientHasImage(item)) return;
    if (state.status != TutorialStatus.ideal) return;
    await _processItemCompletion(item, emit);
  }

  Future<void> _processItemCompletion(
    Item item,
    Emitter<TutorialState> emit,
  ) async {
    emit(
      state.copyWith(status: TutorialStatus.itemDropped, lastDroppedItem: item),
    );

    if (ingredientHasPronunciation(item)) {
      emit(state.copyWith(status: TutorialStatus.itemAudioPlaying));
      await _playAudioAwait(
        () => _audioPlayerService.play(item.audioItem!.trim()),
      );
    } else {
      await Future.delayed(_completionDelay);
    }

    if (!emit.isDone) {
      await _finishIngredientStep(emit);
    }
  }

  /// Marks the current ingredient done, waits, then plays exactly one next guide.
  Future<void> _finishIngredientStep(Emitter<TutorialState> emit) async {
    if (state.content == null) return;
    if (state.status == TutorialStatus.completed) return;
    if (_isFinishingIngredientStep) return;

    _isFinishingIngredientStep = true;
    try {
      final completedIndex = state.currentIndex;
      if (state.completedIngredientIndices.contains(completedIndex)) {
        return;
      }

      emit(
        state.copyWith(
          status: TutorialStatus.itemAudioCompleted,
          completedIngredientIndices: {
            ...state.completedIngredientIndices,
            completedIndex,
          },
        ),
      );

      final nextIndex = completedIndex + 1;
      if (nextIndex >= state.content!.ingredients.length) {
        await Future.delayed(_completionDelay);
        await _completeLesson(emit, currentIndex: nextIndex);
        return;
      }

      await Future.delayed(_completionDelay);
      if (emit.isDone) return;

      emit(state.copyWith(currentIndex: nextIndex));
      await _playGuideForCurrentItem(emit);
    } finally {
      _isFinishingIngredientStep = false;
    }
  }

  /// Legacy event path — delegates to [_finishIngredientStep].
  Future<void> _onItemAudioCompleted(Emitter<TutorialState> emit) async {
    await _finishIngredientStep(emit);
  }

  Future<void> _onIdeal(_Ideal event, Emitter<TutorialState> emit) async {
    emit(state.copyWith(status: TutorialStatus.ideal));
  }

  Future<void> _onCompleted(Emitter<TutorialState> emit) async {
    await _completeLesson(emit);
  }

  @override
  Future<void> close() {
    _audioSub?.cancel();
    _audioPlayerService.dispose();
    return super.close();
  }
}

class AssetCacheService {
  static final _imageCacheManager = CacheManager(
    Config(
      'tutorial_images',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 50,
    ),
  );

  static final _audioCacheManager = CacheManager(
    Config(
      'tutorial_audios',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 50,
    ),
  );

  static Future<Map<String, String>> cacheAll({
    required List<String> imageUrls,
    required List<String> audioUrls,
  }) async {
    final Map<String, String> cachedPaths = {};

    final futures = [
      ...imageUrls.map(
        (url) => _cacheFile(url, _imageCacheManager, cachedPaths),
      ),
      ...audioUrls.map(
        (url) => _cacheFile(url, _audioCacheManager, cachedPaths),
      ),
    ];

    await Future.wait(futures, eagerError: false);
    return cachedPaths;
  }

  static Future<void> _cacheFile(
    String url,
    CacheManager manager,
    Map<String, String> pathMap,
  ) async {
    try {
      final file = await manager.getSingleFile(url);
      pathMap[url] = file.path;
    } catch (e) {
      log('Failed to cache: $url, error: $e');
    }
  }

  static Future<String?> getCachedPath(
    String url, {
    bool isAudio = false,
  }) async {
    final manager = isAudio ? _audioCacheManager : _imageCacheManager;
    final info = await manager.getFileFromCache(url);
    return info?.file.path;
  }
}
