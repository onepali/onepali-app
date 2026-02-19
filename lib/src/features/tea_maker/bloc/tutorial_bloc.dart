import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';
part 'tutorial_bloc.freezed.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final player = AudioPlayer();
  final hunxaPlayer = AudioPlayer();
  List<String> ingridents = [];
  List<String> onDraggedItems = [];
  List<String> audioFiles = [];
  String kitleyLeyAudio = '';
  String teapotVapour = '';
  String abaPaniUmalaSound = '';
  String teaReadySound = '';
  String stoveImage = '';
  String bearTakingTea = '';

  Map<String, String> _cachedPaths = {};

  TutorialBloc() : super(TutorialState()) {
    on<_Started>((event, emit) async {
      final content = event.content;

      ingridents = content.ingredients.map((e) => e.image).toList();
      onDraggedItems = content.ingredients
          .map((e) => e.imageOutline ?? '')
          .toList();
      audioFiles = content.ingredients.map((e) => e.question ?? '').toList();

      kitleyLeyAudio = audioFiles.first;
      audioFiles.removeAt(0);
      teapotVapour = content.teapotVapour;
      abaPaniUmalaSound = content.abaPaniUmalaSound;
      teaReadySound = content.teaReadySound;
      stoveImage = content.stoveImage;
      bearTakingTea = content.bearTakingTea;

      emit(state.copyWith(showLoading: true));

      final allImageUrls = [
        ...ingridents,
        ...onDraggedItems,
        teapotVapour,
        stoveImage,
        bearTakingTea,
      ].where((e) => e.isNotEmpty).toList();

      final allAudioUrls = [
        event.content.audioInstruction,
        kitleyLeyAudio,
        ...audioFiles,
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
          ingredients: ingridents,
          index: 0,
          stoveImage: stoveImage,
          bearTakingTea: bearTakingTea,
        ),
      );

      final instructionAudioPath = _cachedPaths[event.content.audioInstruction];
      if (instructionAudioPath != null) {
        await player.play(DeviceFileSource(instructionAudioPath));
      } else {
        await player.play(UrlSource(event.content.audioInstruction));
      }

      emit(state.copyWith(showBearWithTea: true));
      await player.onPlayerComplete.first;
      emit(state.copyWith(showBearWithTea: false, showHunchButton: true));
    });

    on<_HunchaButtonPressed>((event, emit) async {
      emit(state.copyWith(showHunchButton: false));
      await hunxaPlayer.play(AssetSource('tea_maker/music/making-tea-ok.mp3'));
      await Future.delayed(const Duration(seconds: 2));

      await _playAudio(kitleyLeyAudio);
      await player.onPlayerComplete.first;
      emit(state.copyWith(showDragIndicator: true, index: 0));
    });

    on<_OnDragAccept>((event, emit) async {
      if (event.index != state.index) return;
      if (player.state == PlayerState.playing) return;

      droppedItemText(event.index, emit);
      unawaited(player.play(AssetSource('tea_maker/music/correct.mp3')));

      emit(
        state.copyWith(
          index: state.index + 1,
          draggedItemPath: onDraggedItems[event.index],

          showDragIndicator: false,
        ),
      );

      if (event.index == 2) {
        await Future.delayed(const Duration(seconds: 2));
        await _playAudio(abaPaniUmalaSound);
        await player.onPlayerComplete.first;
        emit(
          state.copyWith(draggedItemPath: teapotVapour, droppedItem: 'उमाल'),
        );
        await Future.delayed(const Duration(seconds: 2));
        await playNextAudio(event.index, audioFiles[event.index]);
      } else if (event.index == 5) {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(teaReady: true));

        await _playAudio(teaReadySound);
        await player.onPlayerComplete.first;
      } else {
        await playNextAudio(event.index, audioFiles[event.index]);
      }
    });
  }

  Future<void> _playAudio(String url) async {
    final cachedPath = _cachedPaths[url];
    if (cachedPath != null) {
      await player.play(DeviceFileSource(cachedPath));
    } else {
      await player.play(UrlSource(url));
    }
  }

  Future<void> playNextAudio(int index, audioFile) async {
    await Future.delayed(const Duration(seconds: 2));
    await _playAudio(audioFiles[index]);
    await player.onPlayerComplete.first;
  }

  Future<void> droppedItemText(int index, Emitter<TutorialState> emit) async {
    switch (index) {
      case 0:
        emit(state.copyWith(droppedItem: 'कित्ली'));
        break;
      case 1:
        emit(state.copyWith(droppedItem: 'पानी'));
        break;
      case 2:
        emit(state.copyWith(droppedItem: 'दुध'));
      case 3:
        emit(state.copyWith(droppedItem: 'अदुवा'));
        break;
      case 4:
        emit(state.copyWith(droppedItem: 'चियापति'));
        break;
      case 5:
        emit(state.copyWith(droppedItem: 'चम्चा'));
        break;
    }
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
