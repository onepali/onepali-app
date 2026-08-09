import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart' as http;
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/src.dart';
import 'package:xml/xml.dart';

part 'gun_fill_event.dart';
part 'gun_fill_state.dart';
part 'gun_fill_bloc.freezed.dart';

class GunFillBloc extends Bloc<GunFillEvent, GunFillState> {
  final AudioPlayerService _audioPlayerService = AudioPlayerServiceImpl();
  StreamSubscription<void>? _audioSub;

  GunFillBloc() : super(_GunFillState()) {
    on<_Started>((event, emit) async {
      final items = event.content.items;
      final gunImageUrl = event.isMobile
          ? event.content.bgImage
          : event.content.bgImageTb;
      final uri = Uri.tryParse(gunImageUrl ?? '');

      if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
        _emitLoadFailure(event.content, emit, 'Missing gun fill SVG URL');
        return;
      }

      try {
        final response = await http.get(uri);
        if (response.statusCode != 200) {
          _emitLoadFailure(
            event.content,
            emit,
            'Gun fill SVG returned HTTP ${response.statusCode}',
          );
          return;
        }

        final svgContent = response.body;
        final paths = XmlDocument.parse(svgContent);
        final allPaths = paths.findAllElements('path');
        log('Found ${allPaths.length} paths in the SVG');
        List<GunPart> gunParts = [];
        List<GunLabel> gunLabels = [];
        for (var element in allPaths) {
          final partId = element.getAttribute('id') ?? '';
          final pathData = element.getAttribute('d');
          if (pathData == null || pathData.isEmpty) continue;

          if (partId.isEmpty || !partId.startsWith("#")) {
            gunLabels.add(
              GunLabel(
                path: pathData,
                color: element.getAttribute('fill'),
                gunPartId: element.getAttribute('partId'),
              ),
            );
            continue;
          }

          // `nameEn` stores the SVG part id, such as `#FFFFFF`.
          final item = _findItemByPartId(items, partId);
          gunParts.add(
            GunPart(id: partId, path: pathData, color: partId, item: item),
          );
        }

        if (gunParts.isEmpty) {
          _emitLoadFailure(event.content, emit, 'Gun fill SVG has no parts');
          return;
        }

        gunParts.shuffle();
        emit(
          state.copyWith(
            content: event.content,
            gunParts: gunParts,
            labelPaths: gunLabels,
          ),
        );
        await _playInstructionIfNeeded(event.content, emit);
      } catch (error, stackTrace) {
        _emitLoadFailure(
          event.content,
          emit,
          'Failed to load gun fill SVG',
          error: error,
          stackTrace: stackTrace,
        );
      }
    });
    on<_InstructionComplete>((event, emit) {
      emit(state.copyWith(status: GunFillStatus.ideal));
    });
    on<_WrongColorDropped>((event, emit) async {
      if (state.status != GunFillStatus.ideal) return;
      emit(state.copyWith(status: GunFillStatus.audioPlaying));
      try {
        final completion = _audioPlayerService.onPlayerComplete.first;
        await _audioPlayerService.playAsset(Assets.wrongSfx);
        await completion;
      } catch (error, stackTrace) {
        log(
          'Failed to play gun fill wrong audio',
          error: error,
          stackTrace: stackTrace,
        );
      } finally {
        emit(state.copyWith(status: GunFillStatus.ideal));
      }
    });
    on<_ColorFilled>((event, emit) async {
      if (state.status != GunFillStatus.ideal) return;
      // Already filled
      final part = _findPartById(state.gunParts, event.partId);
      if (part == null) return;
      if (part.isFilled) return;

      final updatedParts = state.gunParts.map((part) {
        if (part.id == event.partId) {
          return part.copyWith(isFilled: true);
        }
        return part;
      }).toList();

      emit(state.copyWith(gunParts: updatedParts));
      emit(state.copyWith(status: GunFillStatus.audioPlaying));
      await _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(GunFillEvent.starBlustCompleted(part));
      });
      try {
        await _audioPlayerService.playAsset(Assets.starBlast);
      } catch (error, stackTrace) {
        log(
          'Failed to play gun fill star blast audio',
          error: error,
          stackTrace: stackTrace,
        );
        add(GunFillEvent.starBlustCompleted(part));
      }
    });
    on<_StarBlustCompleted>((event, emit) async {
      await _audioSub?.cancel();
      _audioSub = null;
      final part = event.part;
      final itemAudio = part.item?.audioItem;
      if (itemAudio != null && itemAudio.isNotEmpty) {
        _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
          add(GunFillEvent.audioComplete());
        });
        try {
          await _audioPlayerService.play(itemAudio);
        } catch (error, stackTrace) {
          log(
            'Failed to play gun fill item audio',
            error: error,
            stackTrace: stackTrace,
          );
          add(const GunFillEvent.audioComplete());
        }
      } else {
        _emitAudioComplete(emit);
      }
    });
    on<_AudioComplete>((event, emit) async {
      await _audioSub?.cancel();
      _audioSub = null;
      _emitAudioComplete(emit);
    });
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioSub = null;
    await _audioPlayerService.dispose();
    await super.close();
  }

  void _emitAudioComplete(Emitter<GunFillState> emit) {
    final isCompleted = state.gunParts.every((part) => part.isFilled);
    emit(state.copyWith(status: GunFillStatus.ideal, isCompleted: isCompleted));
  }

  Item? _findItemByPartId(List<Item> items, String partId) {
    for (final item in items) {
      if (item.nameEn == partId) return item;
    }
    return null;
  }

  GunPart? _findPartById(List<GunPart> parts, String partId) {
    for (final part in parts) {
      if (part.id == partId) return part;
    }
    return null;
  }

  Future<void> _playInstructionIfNeeded(
    GunFillLessonContent content,
    Emitter<GunFillState> emit,
  ) async {
    if (content.audio == null) {
      emit(state.copyWith(status: GunFillStatus.ideal));
      return;
    }

    try {
      emit(state.copyWith(status: GunFillStatus.instructionPlaying));
      await _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(const GunFillEvent.instructionComplete());
      });
      await _audioPlayerService.play(content.audio!);
    } catch (error, stackTrace) {
      await _audioSub?.cancel();
      _audioSub = null;
      log(
        'Failed to play gun fill instruction audio',
        error: error,
        stackTrace: stackTrace,
      );
      emit(state.copyWith(status: GunFillStatus.ideal));
    }
  }

  void _emitLoadFailure(
    GunFillLessonContent content,
    Emitter<GunFillState> emit,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(message, error: error, stackTrace: stackTrace);
    emit(
      state.copyWith(
        content: content,
        status: GunFillStatus.failed,
        gunParts: [],
        labelPaths: [],
        isCompleted: false,
      ),
    );
  }
}
