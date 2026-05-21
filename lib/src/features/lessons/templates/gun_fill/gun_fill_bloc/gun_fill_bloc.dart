import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:http/http.dart' as http;
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
      final response = await http.get(Uri.parse(gunImageUrl ?? ''));
      if (response.statusCode == 200) {
        final svgContent = response.body;
        final paths = XmlDocument.parse(svgContent);
        final allPaths = paths.findAllElements('path');
        log('Found ${allPaths.length} paths in the SVG');
        List<GunPart> gunParts = [];
        List<GunLabel> gunLabels = [];
        for (var element in allPaths) {
          final partId = element.getAttribute('id') ?? '';
          if (partId.isEmpty || !partId.startsWith("#")) {
            gunLabels.add(
              GunLabel(
                path: element.getAttribute('d') ?? '',
                color: element.getAttribute('fill'),
                gunPartId: element.getAttribute('partId') ?? '#FFFFFF',
              ),
            );
            continue;
          }
          final item = items.firstWhere(
            (e) => e.nameEn == partId,
          ); // Using nameEn as unique identifier(like #FFFFFF)
          final partPath = element.getAttribute('d').toString();
          gunParts.add(
            GunPart(id: partId, path: partPath, color: partId, item: item),
          );
        }
        gunParts.shuffle();
        emit(
          state.copyWith(
            content: event.content,
            gunParts: gunParts,
            labelPaths: gunLabels,
          ),
        );
        if (event.content.audio != null) {
          emit(state.copyWith(status: GunFillStatus.instructionPlaying));
          await _audioPlayerService.play(event.content.audio!);
          await _audioSub?.cancel();
          _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
            add(const GunFillEvent.instructionComplete());
          });
        } else {
          emit(state.copyWith(status: GunFillStatus.ideal));
        }
      }
    });
    on<_InstructionComplete>((event, emit) {
      emit(state.copyWith(status: GunFillStatus.ideal));
    });
    on<_ColorFilled>((event, emit) async {
      if (state.status != GunFillStatus.ideal) return;
      // Already filled
      final part = state.gunParts.firstWhere((part) => part.id == event.partId);
      if (part.isFilled) return;

      final updatedParts = state.gunParts.map((part) {
        if (part.id == event.partId) {
          return part.copyWith(isFilled: true);
        }
        return part;
      }).toList();

      emit(state.copyWith(gunParts: updatedParts));
      emit(state.copyWith(status: GunFillStatus.audioPlaying));
      await _audioPlayerService.playAsset(
        Assets.starBlast,
      ); // Play the star blust
      await _audioSub?.cancel();
      _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
        add(GunFillEvent.starBlustCompleted(part));
      });
    });
    on<_StarBlustCompleted>((event, emit) async {
      final part = event.part;
      if (part.item?.audioItem != null) {
        await _audioPlayerService.play(part.item!.audioItem!);
        await _audioSub?.cancel();
        _audioSub = _audioPlayerService.onPlayerComplete.listen((_) {
          add(GunFillEvent.audioComplete());
        });
      } else {
        emit(state.copyWith(status: GunFillStatus.ideal));
      }
    });
    on<_AudioComplete>((event, emit) {
      final isCompleted = state.gunParts.every((part) => part.isFilled);
      emit(
        state.copyWith(status: GunFillStatus.ideal, isCompleted: isCompleted),
      );
    });
  }
  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    _audioPlayerService.dispose();
    super.close();
  }
}
