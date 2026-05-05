import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/core.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/custom_cache_image.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/templates/option_selection/option_selection_bloc/option_slection_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';

class OptionSelectionView extends StatefulWidget {
  const OptionSelectionView({super.key, required this.content});
  final OptionSelectionLessonContent content;

  @override
  State<OptionSelectionView> createState() => _OptionSelectionViewState();
}

class _OptionSelectionViewState extends State<OptionSelectionView> {
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
          OptionSlectionBloc()
            ..add(OptionSlectionEvent.started(widget.content)),
      child: BlocConsumer<OptionSlectionBloc, OptionSlectionState>(
        listener: (context, state) {
          if (state.status == OptionSelectionStatus.completed) {
            audioPlayerService.playAsset(Assets.starBlast);
          }
        },
        builder: (context, state) {
          if (state.content == null) {
            return SizedBox.shrink();
          }
          return Stack(
            children: [
              if (state.content!.image != null)
                Center(
                  child: CustomCachedImage(
                    imageUrl: state.content!.image!,
                    height: size.height * 0.45,
                    width: size.width * 0.9,
                  ),
                ),
              if (state.status == OptionSelectionStatus.ideal ||
                  state.status == OptionSelectionStatus.completed)
                Positioned(
                  bottom: size.height * 0.1,
                  right: 0,
                  left: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: state.content!.options.map((item) {
                      return GestureDetector(
                        onTap: () {
                          if (state.status == OptionSelectionStatus.completed) {
                            return;
                          }
                          context.read<OptionSlectionBloc>().add(
                            OptionSlectionEvent.optionTapped(item),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 8,
                          ),

                          decoration: BoxDecoration(
                            color:
                                item.isCorrect &&
                                    state.status ==
                                        OptionSelectionStatus.completed
                                ? AppColors.kButtonGreen
                                : AppColors.kButtonGrey,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Text(
                            item.isCorrect &&
                                    state.status ==
                                        OptionSelectionStatus.completed
                                ? "     ✓    "
                                : item.nameNp,
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
              if (state.status == OptionSelectionStatus.completed)
                Positioned.fill(
                  child: IgnorePointer(
                    child: LottieHelper.fromSource(
                      path: Assets.confetti1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              TopRightPositionedCloseButton(
                onTap: () => Navigator.of(context).pop(),
              ),
              if (state.status == OptionSelectionStatus.completed)
                CenterLeftAlignedBackButton(
                  onTap: () => context.read<LessonBloc>().add(
                    const LessonEvent.previousContent(),
                  ),
                ),
              if (state.status == OptionSelectionStatus.completed)
                CenterRightAlignedForwardButton(
                  onTap: () => context.read<LessonBloc>().add(
                    const LessonEvent.nextContent(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
