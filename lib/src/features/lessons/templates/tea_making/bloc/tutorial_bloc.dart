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
  List<String> ingredients = [];
  List<String> ingredientNames = [];
  List<String> onDraggedItems = [];
  List<String> audioFiles = [];
  List<String> ingredientAudioFiles = [];
  String kitleyLeyAudio = '';
  String teapotVapour = '';
  String abaPaniUmalaSound = '';
  String teaReadySound = '';
  String stoveImage = '';
  String dragIndicator = '';
  String hunchaButton = '';
  String hunchaButtonAudio = '';
  String checkIcon = '';
  String boilStepName = '';
  int boilStepAfterIndex = -1;
  String leopardWithTeaTb = '';
  String leopardWithTeaMb = '';

  Map<String, String> _cachedPaths = {};

  TutorialBloc() : super(TutorialState()) {
    on<_Started>((event, emit) async {
      final content = event.content;
      final ingredientItems = _orderedIngredientItems(content.ingredients);
      final data = _buildIngredientData(ingredientItems);
      final draggableIngredientItems = data.draggableItems;

      ingredients = draggableIngredientItems.map((e) => e.image).toList();
      ingredientNames = draggableIngredientItems.map((e) => e.nameNp).toList();
      onDraggedItems = draggableIngredientItems
          .map((e) => e.imageOutline ?? '')
          .toList();
      audioFiles = draggableIngredientItems
          .map((e) => e.question ?? '')
          .toList();
      ingredientAudioFiles = draggableIngredientItems
          .map((e) => e.audioItem != null ? e.audioItem! : '')
          .toList();
      boilStepName = data.boilStepName;
      boilStepAfterIndex = data.boilStepAfterIndex;
      kitleyLeyAudio = audioFiles.isNotEmpty ? audioFiles.first : '';
      audioFiles = audioFiles.length > 1 ? audioFiles.sublist(1) : [];
      teapotVapour = content.teapotVapour;
      abaPaniUmalaSound = content.abaPaniUmalaSound;
      teaReadySound = content.teaReadySound;
      stoveImage = content.stoveImage;
      dragIndicator = content.dragIndicator;
      hunchaButton = content.hunchaButton;
      hunchaButtonAudio = content.hunchaButtonAudio;
      checkIcon = content.checkIcon;
      leopardWithTeaTb = content.leopardWithTeaTb;
      leopardWithTeaMb = content.leopardWithTeaMb;

      emit(state.copyWith(showLoading: true));

      final allImageUrls = [
        ...ingredients,
        ...onDraggedItems,
        teapotVapour,
        stoveImage,
        dragIndicator,
        hunchaButton,
        checkIcon,
        leopardWithTeaTb,
        leopardWithTeaMb,
      ].where((e) => e.isNotEmpty).toList();

      final allAudioUrls = [
        event.content.audioInstruction,
        kitleyLeyAudio,
        ...audioFiles,
        ...ingredientAudioFiles,
        abaPaniUmalaSound,
        teaReadySound,
        hunchaButtonAudio,
      ].where((e) => e.isNotEmpty).toList();

      _cachedPaths = await AssetCacheService.cacheAll(
        imageUrls: allImageUrls,
        audioUrls: allAudioUrls,
      );

      log('Cached ${_cachedPaths.length} assets');

      emit(
        state.copyWith(
          showLoading: false,
          ingredients: ingredients,
          index: 0,
          stoveImage: stoveImage,
          dragIndicator: dragIndicator,
          hunchaButton: hunchaButton,
          checkIcon: checkIcon,
          leopardWithTeaTb: leopardWithTeaTb,
          leopardWithTeaMb: leopardWithTeaMb,
          showLeopardWithTea: true,
        ),
      );

      final instructionCompletion = event.content.audioInstruction.isEmpty
          ? null
          : player.onPlayerComplete.first;
      final didStartInstructionAudio = await _playAudio(
        event.content.audioInstruction,
      );
      if (didStartInstructionAudio && instructionCompletion != null) {
        await instructionCompletion;
      }
      emit(state.copyWith(showLeopardWithTea: false, showHunchButton: true));
    });

    on<_HunchaButtonPressed>((event, emit) async {
      emit(state.copyWith(showHunchButton: false));
      try {
        await _playHunchaButtonAudio();
      } catch (e) {
        log('Failed to play huncha button audio: $e');
      }
      await Future.delayed(const Duration(seconds: 2));

      await _playAudioAndWait(kitleyLeyAudio);
      emit(state.copyWith(showDragIndicator: ingredients.isNotEmpty, index: 0));
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

      if (event.index == boilStepAfterIndex) {
        await Future.delayed(const Duration(seconds: 2));
        await _playAudioAndWait(abaPaniUmalaSound);
        emit(
          state.copyWith(
            draggedItemPath: teapotVapour,
            droppedItem: boilStepName,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        await playNextAudio(event.index);
      } else if (event.index == ingredients.length - 1) {
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(teaReady: true, completionFeedbackReady: false));

        await _playAudioAndWait(teaReadySound);
        emit(state.copyWith(completionFeedbackReady: true));
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
    final completion = url.isEmpty ? null : player.onPlayerComplete.first;
    final didStartAudio = await _playAudio(url);
    if (didStartAudio && completion != null) {
      await completion;
    }
  }

  Future<void> _playHunchaButtonAudio() async {
    if (hunchaButtonAudio.isEmpty) return;
    final cachedPath = _cachedPaths[hunchaButtonAudio];
    if (cachedPath != null) {
      await hunxaPlayer.play(DeviceFileSource(cachedPath));
    } else {
      await hunxaPlayer.play(UrlSource(hunchaButtonAudio));
    }
  }

  Future<void> playNextAudio(int index) async {
    await Future.delayed(const Duration(seconds: 2));
    if (index < 0 || index >= audioFiles.length) return;
    await _playAudioAndWait(audioFiles[index]);
  }

  Future<void> droppedItemText(int index, Emitter<TutorialState> emit) async {
    if (index < 0 || index >= ingredientNames.length) return;
    emit(state.copyWith(droppedItem: ingredientNames[index]));
    await _playIngredientAudio(index);
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

List<Item> _orderedIngredientItems(List<Item> items) {
  final entries = items.asMap().entries.toList()
    ..sort((a, b) {
      final aOrder = a.value.order;
      final bOrder = b.value.order;
      if (aOrder == null && bOrder == null) return a.key.compareTo(b.key);
      if (aOrder == null) return 1;
      if (bOrder == null) return -1;

      final orderCompare = aOrder.compareTo(bOrder);
      return orderCompare == 0 ? a.key.compareTo(b.key) : orderCompare;
    });

  return entries.map((entry) => entry.value).toList();
}

_IngredientData _buildIngredientData(List<Item> items) {
  final draggableItems = <Item>[];
  var boilStepName = '';
  var boilStepAfterIndex = -1;

  for (final item in items) {
    if (_isDraggableIngredient(item)) {
      draggableItems.add(item);
      continue;
    }

    if (boilStepAfterIndex == -1) {
      boilStepName = item.nameNp;
      boilStepAfterIndex = draggableItems.length - 1;
    }
  }

  return _IngredientData(
    draggableItems: draggableItems,
    boilStepName: boilStepName,
    boilStepAfterIndex: boilStepAfterIndex,
  );
}

bool _isDraggableIngredient(Item item) =>
    item.image.isNotEmpty && item.imageOutline?.isNotEmpty == true;

class _IngredientData {
  const _IngredientData({
    required this.draggableItems,
    required this.boilStepName,
    required this.boilStepAfterIndex,
  });

  final List<Item> draggableItems;
  final String boilStepName;
  final int boilStepAfterIndex;
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
