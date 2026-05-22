import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';
part 'tutorial_bloc.freezed.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final player = AudioPlayer();
  final hunxaPlayer = AudioPlayer();
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  List<String> ingredientImages = [];
  List<String> onDraggedItems = [];
  List<String> audioFiles = [];
  List<String> ingredientAudioFiles = [];
  String kitleyLeyAudio = '';
  String teapotVapour = '';
  String abaPaniUmalaSound = '';
  String teaReadySound = '';
  String stoveImage = '';
  String leopardTakingTeaTb = '';
  String leopardTakingTeaMb = '';

  Map<String, String> _cachedPaths = {};

  TutorialBloc() : super(TutorialState()) {
    on<_Started>((event, emit) async {
      final content = event.content;

      ingredientImages = content.ingredients.map((e) => e.image).toList();
      onDraggedItems = content.ingredients
          .map((e) => e.imageOutline ?? '')
          .toList();
      audioFiles = content.ingredients.map((e) => e.question ?? '').toList();
      ingredientAudioFiles = content.ingredients
          .map((e) => e.audioItem != null ? e.audioItem! : '')
          .toList();
      kitleyLeyAudio = audioFiles.isNotEmpty ? audioFiles.first : '';
      audioFiles = audioFiles.length > 1 ? audioFiles.sublist(1) : [];
      teapotVapour = content.teapotVapour;
      abaPaniUmalaSound = content.abaPaniUmalaSound;
      teaReadySound = content.teaReadySound;
      stoveImage = content.stoveImage;
      leopardTakingTeaTb = content.leopardTakingTeaTb;
      leopardTakingTeaMb = content.leopardTakingTeaMb;

      emit(state.copyWith(showLoading: true));

      final allImageUrls = [
        ...ingredientImages,
        ...onDraggedItems,
        teapotVapour,
        stoveImage,
        leopardTakingTeaTb,
        leopardTakingTeaMb,
      ].where((e) => e.isNotEmpty).toList();

      final allAudioUrls = [
        event.content.audioInstruction,
        kitleyLeyAudio,
        ...audioFiles,
        ...ingredientAudioFiles,
        abaPaniUmalaSound,
        teaReadySound,
      ].where((e) => e.isNotEmpty).toList();

      _cachedPaths = await AssetCacheService.cacheAll(
        imageUrls: allImageUrls,
        audioUrls: allAudioUrls,
      );

      log('Cached ${_cachedPaths.length} assets');

      emit(
        state.copyWith(
          showLoading: false,
          ingredients: ingredientImages,
          index: 0,
          stoveImage: stoveImage,
          leopardTakingTeaTb: leopardTakingTeaTb,
          leopardTakingTeaMb: leopardTakingTeaMb,
        ),
      );

      final didStartInstructionAudio = await _playAudio(
        event.content.audioInstruction,
      );
      emit(state.copyWith(showLeopardWithTea: true));
      if (didStartInstructionAudio) {
        await player.onPlayerComplete.first;
      }
      emit(state.copyWith(showLeopardWithTea: false, showHunchButton: true));
    });

    on<_HunchaButtonPressed>((event, emit) async {
      emit(state.copyWith(showHunchButton: false));
      await hunxaPlayer.play(AssetSource('tea_maker/music/making-tea-ok.mp3'));
      await Future.delayed(const Duration(seconds: 2));

      await _playAudioAndWait(kitleyLeyAudio);
      emit(
        state.copyWith(
          showDragIndicator: ingredientImages.isNotEmpty,
          index: 0,
        ),
      );
    });

    on<_OnDragAccept>((event, emit) async {
      if (event.index != state.index) return;
      if (event.index < 0 || event.index >= onDraggedItems.length) return;
      if (player.state == PlayerState.playing) return;

      droppedItemText(event.index, emit);

      emit(
        state.copyWith(
          index: state.index + 1,
          draggedItemPath: onDraggedItems[event.index],

          showDragIndicator: false,
        ),
      );

      if (event.index == 2) {
        await Future.delayed(const Duration(seconds: 2));
        await _playAudioAndWait(abaPaniUmalaSound);
        emit(
          state.copyWith(draggedItemPath: teapotVapour, droppedItem: 'उमाल'),
        );
        await Future.delayed(const Duration(seconds: 2));
        await playNextAudio(event.index);
      } else if (event.index == 5) {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(teaReady: true));

        await _playAudioAndWait(teaReadySound);
      } else {
        await playNextAudio(event.index);
      }
    });
  }

  Future<bool> _playAudio(String url) async {
    if (url.isEmpty) return false;
    final cachedPath = _cachedPaths[url];
    if (cachedPath != null) {
      await player.play(DeviceFileSource(cachedPath));
    } else {
      await player.play(UrlSource(url));
    }
    return true;
  }

  Future<void> _playAudioAndWait(String url) async {
    final didStartAudio = await _playAudio(url);
    if (didStartAudio) {
      await player.onPlayerComplete.first;
    }
  }

  Future<void> playNextAudio(int index) async {
    await Future.delayed(const Duration(seconds: 2));
    if (index < 0 || index >= audioFiles.length) return;
    await _playAudioAndWait(audioFiles[index]);
  }

  Future<void> droppedItemText(int index, Emitter<TutorialState> emit) async {
    switch (index) {
      case 0:
        emit(state.copyWith(droppedItem: 'कित्ली'));
        await _playIngredientAudio(0);
        break;
      case 1:
        emit(state.copyWith(droppedItem: 'पानी'));
        await _playIngredientAudio(1);
        break;
      case 2:
        emit(state.copyWith(droppedItem: 'दुध'));
        await _playIngredientAudio(2);
        break;
      case 3:
        emit(state.copyWith(droppedItem: 'अदुवा'));
        await _playIngredientAudio(3);
        break;
      case 4:
        emit(state.copyWith(droppedItem: 'चियापति'));
        await _playIngredientAudio(4);
        break;
      case 5:
        emit(state.copyWith(droppedItem: 'चम्चा'));
        break;
    }
  }

  Future<void> _playIngredientAudio(int index) async {
    if (index < 0 || index >= ingredientAudioFiles.length) return;
    final audio = ingredientAudioFiles[index];
    if (audio.isEmpty) return;
    await _audioPlayerService.play(audio);
  }

  @override
  Future<void> close() {
    _audioPlayerService.dispose();
    player.stop();
    player.dispose();
    hunxaPlayer.stop();
    hunxaPlayer.dispose();
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
