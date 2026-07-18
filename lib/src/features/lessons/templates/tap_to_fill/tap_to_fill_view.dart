import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_fill/tap_to_fill_bloc/tap_to_fill_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/widgets/background_image.dart';

class TapToFillView extends StatefulWidget {
  const TapToFillView({super.key, required this.content, required this.onNext});
  final TapToFillLessonContent content;
  final VoidCallback onNext;

  @override
  State<TapToFillView> createState() => _TapToFillViewState();
}

class _TapToFillViewState extends State<TapToFillView> {
  final audioPlayerService = AudioPlayerServiceImpl();

  @override
  void dispose() {
    audioPlayerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return BlocProvider(
      create: (context) =>
          TapToFillBloc()..add(TapToFillEvent.started(widget.content)),
      child: BlocConsumer<TapToFillBloc, TapToFillState>(
        listener: (context, state) {
          if (state.status == TapToFillStatus.completed) {
            audioPlayerService.playAsset(Assets.starBlast);
          }
        },
        builder: (context, state) {
          if (state.content == null) {
            return SizedBox.shrink();
          }
          return Stack(
            children: [
              Positioned.fill(
                child: BackgroundImage(
                  bgImageMb: state.bgImageMb,
                  bgImageTb: state.bgImageTb,
                ),
              ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
              if (state.status == TapToFillStatus.ideal)
                Positioned(
                  bottom: size.height * 0.1,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: state.content!.options.map((item) {
                      return GestureDetector(
                        onTap: () {
                          context.read<TapToFillBloc>().add(
                            TapToFillEvent.optionTapped(item),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            item.nameNp,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                                  fontFamily: AppConstants.kMuktaFont,
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              if (state.status == TapToFillStatus.completed)
                Center(
                  child: Text(
                    state.content!.options
                        .firstWhere((option) => option.isCorrect)
                        .nameNp,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontFamily: AppConstants.kMuktaFont,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (state.status == TapToFillStatus.completed)
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    LessonEvent.previousContent(),
                  ),
                ),

              if (state.status == TapToFillStatus.completed)
                CenterRightAlignedForwardButton(onTap: widget.onNext),
            ],
          );
        },
      ),
    );
  }
}
