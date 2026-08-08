import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onepali/src/core/constants/assets.dart';
import 'package:onepali/src/core/router/app_router.dart';
import 'package:onepali/src/core/services/audio_player_service.dart';
import 'package:onepali/src/core/services/audio_record_service.dart';
import 'package:onepali/src/core/services/media_cache_manager.dart';
import 'package:onepali/src/core/utils/guest_util.dart';
import 'package:onepali/src/core/utils/metrics_tracking_helper.dart';
import 'package:onepali/src/core/widget/common/back_arrow_button.dart';
import 'package:onepali/src/core/widget/common/close_button.dart';
import 'package:onepali/src/core/widget/common/forward_arrow_button.dart';
import 'package:onepali/src/core/widget/custom_lottie.dart';
import 'package:onepali/src/core/widget/custom_audio_widget.dart';
import 'package:onepali/src/core/widget/fixed_appbar.dart';
import 'package:onepali/src/features/lessons/blocs/lesson_bloc/lesson_bloc.dart';
import 'package:onepali/src/features/lessons/models/lesson.dart';
import 'package:onepali/src/features/lessons/templates/ball_slide/ball_slide_view.dart';
import 'package:onepali/src/features/lessons/templates/balloon_fill/balloon_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/char_tracing/new_letter_tracing_page.dart';
import 'package:onepali/src/features/lessons/templates/choose_correct/choose_correct_lesson_content_bloc/choose_correct_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/templates/choose_correct/choose_correct_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/drag_to_match/drag_to_match_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/flip_card/flip_card_view.dart';
import 'package:onepali/src/features/lessons/templates/gun_fill/gun_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/holi_animate/holi_animate_view.dart';
import 'package:onepali/src/features/lessons/templates/info/info_lesson_content_bloc/info_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/templates/info/info_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/intro/intro_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/lesson_recommendation/lesson_recommendation_view.dart';
import 'package:onepali/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_bloc/listen_and_repeat_bloc.dart';
import 'package:onepali/src/features/lessons/templates/listen_and_repeat/listen_and_repeat_view.dart';
import 'package:onepali/src/features/lessons/templates/option_selection/option_selection_view.dart';
import 'package:onepali/src/features/lessons/templates/put_in_bag/put_in_bag_view.dart';
import 'package:onepali/src/features/lessons/templates/slide_up_to_match/ball_match_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_the_button/tap_the_button_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_change/tap_to_change_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_fill/tap_to_fill_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_pop/tap_to_pop_bloc/tap_to_pop_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_pop/tap_to_pop_lesson_view.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_content_bloc/tap_to_reveal_lesson_content_bloc.dart';
import 'package:onepali/src/features/lessons/templates/tap_to_reveal/tap_to_reveal_lesson_view.dart';
import 'package:onepali/src/features/lessons/widgets/unknown_lesson_type.dart';
import 'package:onepali/src/features/lessons/templates/tea_making/pages/kitchen_page.dart';
import 'package:onepali/src/provider/lesson/lesson_provider.dart';

class LessonPage extends StatefulWidget {
  const LessonPage({super.key, required this.lessonId});
  final String lessonId;

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  static const _lessonCompletionFeedbackDuration = Duration(seconds: 3);

  int? _lastContentIndex;
  int? _introNavigationReadyIndex;
  LessonDetail? _lastCachedLessonDetails;
  bool _showLessonCompletionFeedback = false;
  bool _isPlayingLessonCompletionFeedback = false;
  bool _hasPlayedLessonCompletionFeedback = false;
  bool _hasTrackedLessonCompletion = false;
  bool _isCompletingLesson = false;
  bool _isCompletingFinalContent = false;
  bool _popAfterLessonCompletionFeedback = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _stopActiveLessonAudio() async {
    await Future.wait([
      AudioPlayerServiceImpl.stopAll(),
      CustomAudioWidget.stopAll(),
    ], eagerError: false);
  }

  void _navigateHomeAfterLessonCompletion() {
    final homeRoute = GuestUtil.isGuestUser()
        ? AppRoutes.guestDashboardScreen
        : AppRoutes.dashboardScreen;
    Navigator.of(context).pushNamedAndRemoveUntil(homeRoute, (route) => false);
    UserAppBar.setTabIndex(0);
  }

  Future<void> _playLessonCompletionFeedback({
    required bool popAfterFeedback,
  }) async {
    if (popAfterFeedback) {
      _popAfterLessonCompletionFeedback = true;
    }

    if (_hasPlayedLessonCompletionFeedback) {
      if (popAfterFeedback && mounted) {
        _navigateHomeAfterLessonCompletion();
      }
      return;
    }

    if (_isPlayingLessonCompletionFeedback) return;

    _isPlayingLessonCompletionFeedback = true;
    _hasPlayedLessonCompletionFeedback = true;
    await _stopActiveLessonAudio();

    if (!mounted) return;
    setState(() {
      _showLessonCompletionFeedback = true;
    });

    final feedbackPlayer = AudioPlayerServiceImpl();
    try {
      await feedbackPlayer.playAsset(Assets.confettiFeedback);
      await Future<void>.delayed(_lessonCompletionFeedbackDuration);
    } finally {
      await feedbackPlayer.dispose();
    }

    if (!mounted) return;
    setState(() {
      _showLessonCompletionFeedback = false;
    });
    _isPlayingLessonCompletionFeedback = false;

    if (_popAfterLessonCompletionFeedback) {
      _navigateHomeAfterLessonCompletion();
    }
  }

  Future<void> _trackLessonCompletion(LessonDetail lessonDetails) async {
    if (_hasTrackedLessonCompletion || GuestUtil.isGuestUser()) return;
    _hasTrackedLessonCompletion = true;

    await context.read<LessonProvider>().incrementTotalLessonsCompleted(
      context,
      widget.lessonId,
      lessonDetails.lesson.name,
    );
    if (!mounted) return;

    await MetricsTrackingHelper.trackLessonCompletion(
      context: context,
      lessonId: widget.lessonId,
      topicName: lessonDetails.lesson.name,
    );
  }

  Future<void> _completeLessonAndNavigate(LessonDetail lessonDetails) async {
    if (_isCompletingLesson) return;
    _isCompletingLesson = true;

    await _playLessonCompletionFeedback(popAfterFeedback: false);
    if (!mounted) return;

    await _trackLessonCompletion(lessonDetails);
    if (!mounted) return;

    _navigateHomeAfterLessonCompletion();
  }

  @override
  void dispose() {
    unawaited(_stopActiveLessonAudio());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          unawaited(_stopActiveLessonAudio());
        }
      },
      child: BlocProvider(
        create: (context) =>
            LessonBloc()..add(LessonEvent.started(widget.lessonId)),
        child: Scaffold(
          body: BlocConsumer<LessonBloc, LessonState>(
            listenWhen: (previous, current) =>
                current.status == LessonStatus.completed ||
                (current.status == LessonStatus.success &&
                    (previous.lessonDetails != current.lessonDetails ||
                        previous.currentIndex != current.currentIndex)),
            listener: (context, state) {
              if (state.status == LessonStatus.completed) {
                final lessonDetails = state.lessonDetails;
                if (lessonDetails != null) {
                  unawaited(_completeLessonAndNavigate(lessonDetails));
                }
                return;
              }

              if (_lastContentIndex != null &&
                  _lastContentIndex != state.currentIndex) {
                unawaited(_stopActiveLessonAudio());
                _introNavigationReadyIndex = null;
              }
              _lastContentIndex = state.currentIndex;

              if (state.lessonDetails != null &&
                  _lastCachedLessonDetails != state.lessonDetails) {
                MediaCacheManager().cacheLessonMedia(
                  state.lessonDetails!.contents,
                  context,
                );
                _lastCachedLessonDetails = state.lessonDetails;
              }
            },
            builder: (context, state) {
              if (state.lessonDetails == null) {
                return Center(child: CircularProgressIndicator());
              }
              if (state.currentContent == null) {
                return Center(child: Text('No content found'));
              }
              final lessonContent = state.currentContent!;
              final contents = state.lessonDetails!.contents;
              final isLastContent = state.currentIndex >= contents.length - 1;
              final isFirstContent = state.currentIndex == 0;

              void handleNext() {
                unawaited(_stopActiveLessonAudio());
                context.read<LessonBloc>().add(const LessonEvent.nextContent());
              }

              void handlePrevious() {
                unawaited(_stopActiveLessonAudio());
                context.read<LessonBloc>().add(
                  const LessonEvent.previousContent(),
                );
              }

              void markIntroNavigationReady() {
                if (_introNavigationReadyIndex == state.currentIndex) return;
                setState(() {
                  _introNavigationReadyIndex = state.currentIndex;
                });
              }

              void completeLessonAfterFeedback() {
                if (_isCompletingFinalContent) return;
                _isCompletingFinalContent = true;
                unawaited(
                  (() async {
                    await _playLessonCompletionFeedback(
                      popAfterFeedback: false,
                    );
                    if (!mounted) return;
                    context.read<LessonBloc>().add(
                      const LessonEvent.nextContent(),
                    );
                  })(),
                );
              }

              final contentView = switch (lessonContent) {
                IntroLessonContent() => Stack(
                  children: [
                    IntroLessonView(
                      key: ValueKey('intro_${state.currentIndex}'),
                      content: lessonContent,
                      isLast: isLastContent,
                      isFirst: isFirstContent,
                      onNavigationReady: markIntroNavigationReady,
                      onNext: handleNext,
                      onLessonCompleted: completeLessonAfterFeedback,
                    ),
                    TopRightPositionedCloseButton(
                      onTap: () {
                        unawaited(_stopActiveLessonAudio());
                        Navigator.of(context).pop();
                      },
                    ),
                    if (_introNavigationReadyIndex == state.currentIndex &&
                        !isLastContent)
                      CenterRightAlignedForwardButton(onTap: handleNext),
                    if (_introNavigationReadyIndex == state.currentIndex &&
                        !isFirstContent)
                      CenterLeftAlignedBackButton(onTap: handlePrevious),
                  ],
                ),
                InfoLessonContent() => BlocProvider(
                  key: ValueKey('info_${state.currentIndex}'),
                  create: (context) => InfoLessonContentBloc(),
                  child: InfoLessonView(content: lessonContent),
                ),
                ChooseCorrectLessonContent() => BlocProvider(
                  create: (context) => ChooseCorrectLessonContentBloc(),
                  child: ChooseCorrectLessonView(
                    content: lessonContent,
                    isLastContent: isLastContent,
                    onNext: handleNext,
                    onLessonCompleted: completeLessonAfterFeedback,
                  ),
                ),
                TapToRevealLessonContent() => BlocProvider(
                  key: ValueKey('tap_to_reveal_${state.currentIndex}'),
                  create: (context) => TapToRevealLessonContentBloc(),
                  child: TapToRevealLessonView(content: lessonContent),
                ),
                DragToMatchLessonContent() => DragToMatchScreen(
                  lessonContent: lessonContent,
                  isLastContent: isLastContent,
                  onLessonCompleted: completeLessonAfterFeedback,
                ),
                TapToPopLessonContent() => BlocProvider(
                  key: ValueKey('tap_to_pop_${state.currentIndex}'),
                  create: (context) =>
                      TapToPopBloc()..add(TapToPopEvent.started(lessonContent)),
                  child: TapToPopLessonView(content: lessonContent),
                ),
                ListenAndRepeatLessonContent() => BlocProvider(
                  key: ValueKey('listen_and_repeat_${state.currentIndex}'),
                  create: (context) => ListenAndRepeatBloc(
                    audioPlayerService: AudioPlayerServiceImpl(),
                    audioRecorderService: AudioRecorderServiceImpl(),
                  ),
                  child: ListenAndRepeatView(
                    content: lessonContent,
                    onCompleted: handleNext,
                  ),
                ),
                CharTracingLessonContent() => NewLetterTracingPage(
                  content: lessonContent,
                  isLastContent: isLastContent,
                  onNext: handleNext,
                  onLessonCompleted: completeLessonAfterFeedback,
                ),
                TeaMakingLessonContent() => KitchenPage(
                  content: lessonContent,
                  onNext: isLastContent
                      ? completeLessonAfterFeedback
                      : handleNext,
                  onLessonCompleted: isLastContent
                      ? completeLessonAfterFeedback
                      : null,
                ),
                BallSlideLessonContent() => BallSlideView(
                  key: ValueKey('ball_slide_${state.currentIndex}'),
                  content: lessonContent,
                  onNext: handleNext,
                ),
                FlipCardLessonContent() => FlipCardView(
                  key: ValueKey('flip_card_${state.currentIndex}'),
                  content: lessonContent,
                  onNext: handleNext,
                ),
                SlideUpToMatchLessonContent() => MatchGameScreen(
                  key: ValueKey('slide_up_to_match_${state.currentIndex}'),
                  content: lessonContent,
                  isLastContent: isLastContent,
                  onNext: handleNext,
                  onLessonCompleted: completeLessonAfterFeedback,
                ),
                BalloonFillLessonContent() => BalloonFillView(
                  content: lessonContent,
                  onNext: isLastContent
                      ? completeLessonAfterFeedback
                      : handleNext,
                ),
                GunFillLessonContent() => GunFillLessonView(
                  content: lessonContent,
                  onNext: isLastContent
                      ? completeLessonAfterFeedback
                      : handleNext,
                ),
                HoliAnimateLessonContent() => HoliAnimateView(
                  content: lessonContent,
                  onNext: isLastContent
                      ? completeLessonAfterFeedback
                      : handleNext,
                ),
                TapToChangeLessonContent() => TapToChangeView(
                  content: lessonContent,
                  onNext: isLastContent
                      ? completeLessonAfterFeedback
                      : handleNext,
                ),
                TapToFillLessonContent() => TapToFillView(
                  key: ValueKey('tap_to_fill_${state.currentIndex}'),
                  content: lessonContent,
                  onNext: handleNext,
                ),
                OptionSelectionLessonContent() => OptionSelectionView(
                  content: lessonContent,
                  onNext: handleNext,
                ),
                PutInBagLessonContent() => PutInBagView(
                  key: ValueKey('put_in_bag_${state.currentIndex}'),
                  content: lessonContent,
                  onNext: handleNext,
                ),
                TapTheButtonLessonContent() => TapTheButtonView(
                  key: ValueKey('tap_the_button_${state.currentIndex}'),
                  content: lessonContent,
                  onNext: handleNext,
                ),
                LessonRecommendationLessonContent() => LessonRecommendationView(
                  content: lessonContent,
                  onLessonCompleted: isLastContent
                      ? completeLessonAfterFeedback
                      : null,
                ),
                _ => UnknownLessonType(
                  isFirst: isFirstContent,
                  isLast: isLastContent,
                ),
              };

              return Stack(
                children: [
                  contentView,
                  if (_showLessonCompletionFeedback)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: LottieHelper.fromSource(
                          path: Assets.confetti1,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height,
                          fit: BoxFit.cover,
                          repeat: false,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
