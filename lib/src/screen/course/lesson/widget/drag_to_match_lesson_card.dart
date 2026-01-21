import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import 'grid_position_helper.dart';

/// A widget that displays an interactive park scene for drag_to_match type lessons.
///
/// This widget follows the specified flow:
/// 1. Automatically plays the Nepali audio question (word_audio)
/// 2. Continuously plays animal sounds to help identification
/// 3. Child drags animals to match their silhouettes/outlines
/// 4. When correct, shows vocabulary box with Nepali pronunciation and plays correct audio
/// 5. When wrong, returns draggable items to original position and plays try again audio
///
/// The widget is fully responsive and positions elements naturally in a park scene.
class DragToMatchLessonCard extends StatefulWidget {
  final LessonContent content;
  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onCorrectAnswer;
  final VoidCallback? onLessonComplete;
  final int index;
  final bool isLastItem;

  const DragToMatchLessonCard({
    super.key,
    required this.content,
    required this.isPlaying,
    this.onPlay,
    this.onCorrectAnswer,
    this.onLessonComplete,
    this.index = 0,
    this.isLastItem = false,
  });

  @override
  State<DragToMatchLessonCard> createState() => _DragToMatchLessonCardState();
}

class _DragToMatchLessonCardState extends State<DragToMatchLessonCard>
    with TickerProviderStateMixin {
  final Map<String, bool> _completedMatches = {};
  final Map<String, GlobalKey> _dragItemKeys = {};
  bool _showVocabularyBox = false;
  String? _currentMatchedItem;
  String? _vocabularyText;
  int _totalMatches = 0;
  int _completedCount = 0;
  bool _allCompleted = false;
  bool _showCorrectFeedback = false;
  bool _showIncorrectFeedback = false;
  bool showLeopardAnimation = false; // Controls leopard animation display
  bool _showSuccessLottie = false; // Controls success lottie animation display

  // Sequential audio flow state
  int _currentAnimalIndex = 0;
  bool _isWaitingForMatch = false;

  // Animation controllers
  late AnimationController _vocabularyController;
  late AnimationController _feedbackController;
  late AnimationController _bounceController;
  late AnimationController _shakeController;

  // Audio widgets
  CustomAudioWidget? _questionAudio;
  CustomAudioWidget? _animalSoundAudio;
  CustomAudioWidget? _correctFeedbackAudio;
  CustomAudioWidget? _incorrectFeedbackAudio;
  CustomAudioWidget? _vocabularyAudio;
  CustomAudioWidget? _confettiFeedbackAudio;
  CustomAudioWidget? _goodRemarkAudio;

  // Preloaded audio widgets for faster playback
  final Map<String, CustomAudioWidget> _preloadedVocabularyAudios = {};
  final Map<String, CustomAudioWidget> _preloadedAnimalSounds = {};

  // Animation values
  late Animation<double> _vocabularyAnimation;
  late Animation<double> _feedbackAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDragTargets();
    _initializeAudioWidgets();

    // Start the lesson flow
    Misc.onLayoutRendered(() {
      _startLessonFlow();
    });
  }

  @override
  void didUpdateWidget(DragToMatchLessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the content changed (different index), dispose audio and reset state
    if (oldWidget.index != widget.index) {
      setState(() {
        _completedMatches.clear();
        _showVocabularyBox = false;
        _currentMatchedItem = null;
        _vocabularyText = null;
        _totalMatches = 0;
        _completedCount = 0;
        _allCompleted = false;
        _showCorrectFeedback = false;
        _showIncorrectFeedback = false;
        showLeopardAnimation = false;
        _showSuccessLottie = false;
        _currentAnimalIndex = 0;
        _isWaitingForMatch = false;
      });
      _disposeAllAudioWidgets();

      // Reinitialize for new content
      _initializeDragTargets();
      _initializeAudioWidgets();

      // Start the lesson flow for new content
      Misc.onLayoutRendered(() {
        _startLessonFlow();
      });
    }
  }

  void _initializeAnimations() {
    _vocabularyController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _vocabularyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _vocabularyController, curve: Curves.elasticOut),
    );

    _feedbackAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticInOut),
    );

    _shakeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.1, 0.0)).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.elasticInOut),
        );
  }

  void _initializeDragTargets() {
    if (widget.content.dragTargets?.isNotEmpty == true) {
      _totalMatches = widget.content.dragTargets!.length;

      for (final target in widget.content.dragTargets!) {
        if (target.id?.isNotEmpty == true) {
          _completedMatches[target.id!] = false;
          _dragItemKeys[target.id!] = GlobalKey();
        }
      }
    }
  }

  void _initializeAudioWidgets() {
    // Initialize question audio
    if (widget.content.wordAudio?.isNotEmpty == true) {
      _questionAudio = CustomAudioWidget(
        audioPath: widget.content.wordAudio!,
        audioSourceType: AudioSourceType.network,
      );
    }

    // Initialize feedback audio widgets
    if (widget.content.feedback?.correct?.audio?.isNotEmpty == true) {
      _correctFeedbackAudio = CustomAudioWidget(
        audioPath: widget.content.feedback!.correct!.audio!,
        audioSourceType: AudioSourceType.network,
      );
    }

    if (widget.content.feedback?.incorrect?.wordAudio?.isNotEmpty == true) {
      _incorrectFeedbackAudio = CustomAudioWidget(
        audioPath: widget.content.feedback!.incorrect!.wordAudio!,
        audioSourceType: AudioSourceType.network,
      );
    }

    // Initialize confetti feedback audio from assets
    try {
      _confettiFeedbackAudio = CustomAudioWidget(
        audioPath: Assets.confettiFeedback,
        audioSourceType: AudioSourceType.asset,
      );
      logger.d('Confetti feedback audio initialized successfully');
    } catch (e) {
      logger.e('Error initializing confetti feedback audio: $e');
    }

    // Initialize good remark audio from assets
    try {
      _goodRemarkAudio = CustomAudioWidget(
        audioPath: Assets.goodFeedback,
        audioSourceType: AudioSourceType.asset,
      );
      logger.d('Good remark audio initialized successfully');
    } catch (e) {
      logger.e('Error initializing good remark audio: $e');
    }

    // Preload all vocabulary audios and animal sounds for faster playback
    _preloadAllAudios();
  }

  void _preloadAllAudios() {
    if (widget.content.dragTargets?.isEmpty != false) return;

    for (final target in widget.content.dragTargets!) {
      if (target.id?.isEmpty == true) continue;

      // Preload vocabulary audio (wordAudio)
      if (target.wordAudio?.isNotEmpty == true) {
        try {
          _preloadedVocabularyAudios[target.id!] = CustomAudioWidget(
            audioPath: target.wordAudio!,
            audioSourceType: AudioSourceType.network,
          );
          logger.d('Preloaded vocabulary audio for ${target.nameEn}');
        } catch (e) {
          logger.e(
            'Error preloading vocabulary audio for ${target.nameEn}: $e',
          );
        }
      }

      // Preload animal sound audio
      if (target.audio?.isNotEmpty == true) {
        try {
          _preloadedAnimalSounds[target.id!] = CustomAudioWidget(
            audioPath: target.audio!,
            audioSourceType: AudioSourceType.network,
          );
          logger.d('Preloaded animal sound for ${target.nameEn}');
        } catch (e) {
          logger.e('Error preloading animal sound for ${target.nameEn}: $e');
        }
      }
    }

    logger.d(
      'Preloaded ${_preloadedVocabularyAudios.length} vocabulary audios and ${_preloadedAnimalSounds.length} animal sounds',
    );
  }

  void _startLessonFlow() async {
    // Step 1: Play Nepali audio question
    await _playQuestionAudio();

    // Step 2: Start sequential animal sound flow
    Future.delayed(const Duration(seconds: 2), () {
      _startAnimalSounds();
    });
  }

  Future<void> _playQuestionAudio() async {
    try {
      if (_questionAudio != null) {
        await _questionAudio!.play();
        logger.d('Playing question audio for drag_to_match lesson');
      }
    } catch (e) {
      logger.e('Error playing question audio: $e');
    }
  }

  void _startAnimalSounds() {
    // Initialize sequential flow
    setState(() {
      _currentAnimalIndex = 0;
      _isWaitingForMatch = false;
    });

    // Start with the first animal sound
    if (widget.content.dragTargets?.isNotEmpty == true) {
      _playCurrentAnimalSound();
    }
  }

  void _playCurrentAnimalSound() async {
    if (_allCompleted ||
        widget.content.dragTargets?.isEmpty == true ||
        _currentAnimalIndex >= widget.content.dragTargets!.length) {
      return;
    }

    // Find the next incomplete animal to play
    while (_currentAnimalIndex < widget.content.dragTargets!.length) {
      final target = widget.content.dragTargets![_currentAnimalIndex];
      final isCompleted = _completedMatches[target.id] ?? false;

      if (!isCompleted && target.audio?.isNotEmpty == true) {
        break;
      }
      _currentAnimalIndex++;
    }

    // If we've gone through all animals, we're done
    if (_currentAnimalIndex >= widget.content.dragTargets!.length) {
      return;
    }

    final target = widget.content.dragTargets![_currentAnimalIndex];

    // Set state and play audio without waiting for setState to complete
    setState(() {
      _isWaitingForMatch = true;
    });

    try {
      // Use preloaded audio if available, otherwise create new one
      final preloadedAudio = _preloadedAnimalSounds[target.id];
      if (preloadedAudio != null) {
        await preloadedAudio.play();
        logger.d(
          'Playing preloaded animal sound for ${target.nameEn} (index: $_currentAnimalIndex)',
        );
      } else {
        // Fallback to creating new audio widget
        _animalSoundAudio?.dispose();
        _animalSoundAudio = CustomAudioWidget(
          audioPath: target.audio!,
          audioSourceType: AudioSourceType.network,
        );
        await _animalSoundAudio!.play();
        logger.d(
          'Playing animal sound for ${target.nameEn} (index: $_currentAnimalIndex)',
        );
      }
    } catch (e) {
      logger.e('Error playing animal sound: $e');
    }
  }

  void _playNextAnimalSound() {
    // Move to next animal and play its sound
    _currentAnimalIndex++;
    _playCurrentAnimalSound();
  }

  void _repeadCurrentAnimalSound() {
    _playCurrentAnimalSound();
  }

  void _replayCurrentAnimalSound() {
    // Ensure we don't go beyond the available targets
    if (_currentAnimalIndex >= widget.content.dragTargets!.length) {
      return;
    }

    // Get the current target that should be playing
    final target = widget.content.dragTargets![_currentAnimalIndex];

    // Only replay if this animal is not completed yet
    if (_completedMatches[target.id] ?? false) {
      return;
    }

    setState(() {
      _isWaitingForMatch = false;
    });

    // Play the same animal sound after a brief delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_allCompleted) {
        _playCurrentAnimalSound();
        logger.d('Replaying current animal sound: ${target.nameEn}');
      }
    });
  }

  void _onDragTargetAccept(String targetId, String draggedId) async {
    if (!_isWaitingForMatch) return; // Only accept drags when waiting for match

    // Get the current animal that should be matched based on the sound being played
    final currentTarget = widget.content.dragTargets![_currentAnimalIndex];
    final expectedAnimalId = currentTarget.id;

    final target = widget.content.dragTargets!.firstWhere(
      (t) => t.id == targetId,
      orElse: () => DragTargets(),
    );

    // Check if:
    // 1. The dragged item matches the drop target (targetId == draggedId)
    // 2. AND the dragged animal is the same as the currently playing animal sound
    if (targetId == draggedId && draggedId == expectedAnimalId) {
      // CORRECT: Right animal dragged to right place AND matches current sound
      await _handleCorrectMatch(target);
    } else {
      // INCORRECT: Either wrong animal or doesn't match current sound
      await _handleIncorrectMatch();
    }
  }

  Future<void> _handleCorrectMatch(DragTargets target) async {
    setState(() {
      _completedMatches[target.id!] = true;
      _completedCount++;
      _currentMatchedItem = target.id;
      _vocabularyText = target.nameNp;
      _showVocabularyBox = true;
      _showCorrectFeedback = true;
      _isWaitingForMatch = false;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    // Play correct feedback audio
    if (_correctFeedbackAudio != null) {
      try {
        await _correctFeedbackAudio!.play();
      } catch (e) {
        logger.e('Error playing correct feedback audio: $e');
      }
    }

    // Show vocabulary box animation
    _vocabularyController.forward();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    // Play vocabulary audio and wait for it to complete (use preloaded audio)
    if (target.wordAudio?.isNotEmpty == true) {
      try {
        // Use preloaded audio if available, otherwise create new one
        final preloadedAudio = _preloadedVocabularyAudios[target.id];
        if (preloadedAudio != null) {
          await preloadedAudio.play();
          logger.d('Playing preloaded vocabulary audio for ${target.nameEn}');
        } else {
          // Fallback to creating new audio widget
          _vocabularyAudio?.dispose();
          _vocabularyAudio = CustomAudioWidget(
            audioPath: target.wordAudio!,
            audioSourceType: AudioSourceType.network,
          );
          await _vocabularyAudio!.play();
          logger.d('Playing vocabulary audio for ${target.nameEn}');
        }
      } catch (e) {
        logger.e('Error playing vocabulary audio: $e');
      }
    }

    // Check if all matches are completed
    if (_completedCount >= _totalMatches) {
      setState(() {
        _allCompleted = true;
      });

      // Wait a bit after vocabulary audio, then show success lottie animation
      await Future.delayed(const Duration(milliseconds: 1500));

      // Show success lottie animation if confettiOnComplete is true and it's the last item
      if (widget.content.feedback?.confettiOnComplete == true &&
          widget.isLastItem) {
        setState(() {
          _showSuccessLottie = true;
        });

        // Play confetti feedback audio simultaneously with lottie animation (don't await)
        bool confettiAudioFinished = false;
        bool confettiAnimationFinished = false;

        void checkIfBothFinished() {
          if (confettiAudioFinished && confettiAnimationFinished && mounted) {
            setState(() {
              _showSuccessLottie = false;
              showLeopardAnimation = true;
            });
            logger.d(
              'Showing leopard animation after both confetti and audio finished',
            );

            // Play good remark audio after both confetti animation and audio finish
            try {
              if (_goodRemarkAudio != null) {
                logger.d(
                  'Starting good remark audio after confetti completion',
                );
                _goodRemarkAudio!
                    .play()
                    .then((_) {
                      logger.d('Good remark audio finished playing');
                    })
                    .catchError((e) {
                      logger.e('Error playing good remark audio: $e');
                    });
              } else {
                logger.w('Good remark audio widget is null');
              }
            } catch (e) {
              logger.e('Error starting good remark audio: $e');
            }
          }
        }

        try {
          if (_confettiFeedbackAudio != null) {
            logger.d('Starting confetti feedback audio with lottie animation');
            _confettiFeedbackAudio!
                .play()
                .then((_) {
                  logger.d('Confetti feedback audio finished playing');
                  confettiAudioFinished = true;
                  checkIfBothFinished();
                })
                .catchError((e) {
                  logger.e('Error playing confetti feedback audio: $e');
                  confettiAudioFinished =
                      true; // Consider it finished even on error
                  checkIfBothFinished();
                });

            logger.d('Confetti feedback audio play() call initiated');
          } else {
            logger.w('Confetti feedback audio widget is null');
            confettiAudioFinished = true; // Skip audio
            checkIfBothFinished();
          }
        } catch (e) {
          logger.e('Error starting confetti feedback audio: $e');
          confettiAudioFinished = true; // Consider it finished even on error
          checkIfBothFinished();
        }

        // Wait for confetti animation to complete (typically 3-4 seconds for lottie)
        Future.delayed(const Duration(seconds: 4), () {
          logger.d('Confetti animation duration completed');
          confettiAnimationFinished = true;
          checkIfBothFinished();
        });
      } else if (widget.isLastItem) {
        // Show leopard animation for completion (only for last item) when confetti is not enabled
        setState(() {
          showLeopardAnimation = true;
        });

        // Play good remark audio
        try {
          if (_goodRemarkAudio != null) {
            logger.d('Starting good remark audio (no confetti)');
            _goodRemarkAudio!
                .play()
                .then((_) {
                  logger.d('Good remark audio finished playing (no confetti)');
                })
                .catchError((e) {
                  logger.e('Error playing good remark audio (no confetti): $e');
                });
            logger.d('Good remark audio play() call initiated (no confetti)');
          } else {
            logger.w('Good remark audio widget is null (no confetti)');
          }
        } catch (e) {
          logger.e('Error starting good remark audio (no confetti): $e');
        }
      }

      // Reset audio provider state only if this is the last item
      if (widget.isLastItem) {
        try {
          final audioProvider = Provider.of<LessonAudioProvider>(
            context,
            listen: false,
          );
          await audioProvider.stopAudio();
          await audioProvider.clearCache();
        } catch (e) {
          logger.e('Error stopping audio: $e');
        }
      }

      // Auto-complete the course after a brief delay to let user see the completion
      Future.delayed(const Duration(seconds: 9), () {
        if (mounted) {
          if (widget.isLastItem) {
            // Only call lesson complete if this is the last item in the lesson sequence
            widget.onLessonComplete?.call();
            logger.d('All matches completed! Last item - completing lesson.');
          } else {
            // For non-last items, call onCorrectAnswer to proceed to next content
            widget.onCorrectAnswer?.call();
            logger.d('All matches completed! Moving to next content.');
          }
        }
      });

      // Hide leopard animation after delay (only if it was shown for last item)
      if (widget.isLastItem) {
        // Adjust timing based on whether confetti was shown
        final hideDelay = widget.content.feedback?.confettiOnComplete == true
            ? const Duration(
                seconds: 8,
              ) // Hide after confetti animation (4s) + good remark audio (3-4s)
            : const Duration(seconds: 4); // Hide after good remark audio only

        Future.delayed(hideDelay, () {
          if (mounted) {
            setState(() {
              showLeopardAnimation = false;
            });

            // Dispose audio widgets after all animations and audio are complete
            _disposeAllAudioWidgets();
          }
        });
      } else {
        // For non-last items, dispose audio widgets after a shorter delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _disposeAllAudioWidgets();
          }
        });
      }

      logger.d(
        'All matches completed! Course will auto-complete in 3 seconds.',
      );
    } else {
      // Start preparing the next animal sound BEFORE hiding the vocabulary box
      // This ensures it's ready to play immediately when the box disappears
      final nextAnimalIndex = _currentAnimalIndex + 1;
      if (nextAnimalIndex < widget.content.dragTargets!.length) {
        final nextTarget = widget.content.dragTargets![nextAnimalIndex];
        // Ensure the next audio is preloaded and ready
        if (_preloadedAnimalSounds[nextTarget.id] == null &&
            nextTarget.audio?.isNotEmpty == true) {
          try {
            _preloadedAnimalSounds[nextTarget.id!] = CustomAudioWidget(
              audioPath: nextTarget.audio!,
              audioSourceType: AudioSourceType.network,
            );
            logger.d('Pre-prepared next animal sound: ${nextTarget.nameEn}');
          } catch (e) {
            logger.e('Error pre-preparing next animal sound: $e');
          }
        }
      }

      // Hide vocabulary box after showing it and play next animal sound immediately
      Future.delayed(const Duration(seconds: 2), () {
        // Start both animation and sound simultaneously for faster transition
        setState(() {
          _showVocabularyBox = false;
          _showCorrectFeedback = false;
        });

        // Start animation reverse and play sound at the same time
        _vocabularyController.reverse();
        _playNextAnimalSound(); // This now plays immediately without waiting for animation
      });
    }

    logger.d(
      'Correct match for ${target.nameEn}. Progress: $_completedCount/$_totalMatches',
    );
  }

  Future<void> _handleIncorrectMatch() async {
    setState(() {
      _showIncorrectFeedback = true;
      _isWaitingForMatch = false;
    });

    // Haptic feedback for wrong answer
    HapticFeedback.heavyImpact();

    // Show shake animation for incorrect feedback
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    // Play incorrect feedback audio first (try again - "फेरि प्रयास गर्नुहोस्")
    if (_incorrectFeedbackAudio != null) {
      try {
        await _incorrectFeedbackAudio!.play();
        logger.d('Playing incorrect feedback audio: try again');
      } catch (e) {
        logger.e('Error playing incorrect feedback audio: $e');
      }
    }

    // Hide incorrect feedback after showing it
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showIncorrectFeedback = false;
        });
      }
    });

    // Reset stickers back to original position (handled by UI rebuild)
    // The draggable items will automatically return to their original positions
    // because we're not changing any completion state

    // After feedback audio finishes, replay ONLY the current animal sound
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_allCompleted) {
        logger.d('Replaying current animal sound after incorrect match');
        _replayCurrentAnimalSound();
      }
    });

    logger.d('Incorrect match - will reset and replay current animal sound');
  }

  @override
  void dispose() {
    _vocabularyController.dispose();
    _feedbackController.dispose();
    _bounceController.dispose();
    _shakeController.dispose();

    _disposeAllAudioWidgets();

    super.dispose();
  }

  void _disposeAllAudioWidgets() {
    _questionAudio?.dispose();
    _animalSoundAudio?.dispose();
    _correctFeedbackAudio?.dispose();
    _incorrectFeedbackAudio?.dispose();
    _vocabularyAudio?.dispose();
    _confettiFeedbackAudio?.dispose();
    _goodRemarkAudio?.dispose();

    _questionAudio = null;
    _animalSoundAudio = null;
    _correctFeedbackAudio = null;
    _incorrectFeedbackAudio = null;
    _vocabularyAudio = null;
    _confettiFeedbackAudio = null;
    _goodRemarkAudio = null;

    // Dispose preloaded audios
    for (final audio in _preloadedVocabularyAudios.values) {
      audio.dispose();
    }
    _preloadedVocabularyAudios.clear();

    for (final audio in _preloadedAnimalSounds.values) {
      audio.dispose();
    }
    _preloadedAnimalSounds.clear();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final screenSize = MediaQuery.of(context).size;

    return SizedBox.expand(
      child: Stack(
        clipBehavior:
            Clip.none, // Allow overflow so rabbit can be visible at edges
        children: [
          // Background image is handled at parent level in lesson_content_screen.dart
          // to fill the entire screen (appears once)

          // Drag targets (silhouettes/outlines) positioned in the scene
          ..._buildDragTargets(screenSize, isMobile, isTablet, isLandscape),

          // Draggable items positioned at the bottom/side
          ..._buildDraggableItems(screenSize, isMobile, isTablet, isLandscape),

          // Vocabulary box overlay
          if (_showVocabularyBox) _buildVocabularyBox(),

          // Feedback overlays
          if (_showCorrectFeedback) _buildCorrectFeedback(),
          if (_showIncorrectFeedback) _buildIncorrectFeedback(),

          // Success lottie animation overlay (shown when all matches are completed, confetti is enabled, and is last item)
          if (_showSuccessLottie)
            Positioned.fill(
              child: LottieHelper.fromSource(
                path: Assets.lessonSuccessLottie,
                type: LottieSourceType.asset,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                repeat: false,
              ),
            ),

          // Leopard animation from corner (shown when all matches are completed and is last item)
          if (showLeopardAnimation && _allCompleted && widget.isLastItem)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              bottom: -50,
              right: -50,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: 1.0,
                child: CustomImage(
                  Assets.goodRemark,
                  height: 270,
                  width: 270,
                  imageType: CustomImageType.local,
                ),
              ),
            ),

          // Close button is handled by parent _buildActionButtons
        ],
      ),
    );
  }

  // Background image is handled at parent level in lesson_content_screen.dart
  // to fill the entire screen (appears once)

  List<Widget> _buildDragTargets(
    Size screenSize,
    bool isMobile,
    bool isTablet,
    bool isLandscape,
  ) {
    if (widget.content.dragTargets?.isEmpty != false) return [];

    final targets = <Widget>[];
    final positionsMap = _getTargetPositionsMap(
      screenSize.width,
      screenSize.height,
      isMobile,
    );

    for (int i = 0; i < widget.content.dragTargets!.length; i++) {
      final target = widget.content.dragTargets![i];
      if (target.id?.isEmpty != false) continue;

      // Get position by animal ID (same as tap target)
      final animalId = target.id!.toLowerCase();
      final position = positionsMap[animalId] ?? positionsMap.values.first;
      final isCompleted = _completedMatches[target.id] ?? false;

      // Use same usable dimensions and size calculation as tap target
      final isLandscape = PlatformUtility.isLandscape(context);
      final double usableWidthPercent = isMobile
          ? 0.9
          : (isLandscape ? 0.85 : 0.82);
      final double usableHeightPercent = isMobile
          ? 0.5
          : (isLandscape ? 0.7 : 0.55);
      final double usableWidth = screenSize.width * usableWidthPercent;
      final double usableHeight = screenSize.height * usableHeightPercent;
      final size = _getTargetSizeForItem(
        target.id!,
        isMobile,
        usableWidth,
        usableHeight,
      );

      targets.add(
        Positioned(
          left: position['left']!,
          bottom: position['bottom']!,
          child: AnimatedBuilder(
            animation: _bounceAnimation,
            builder: (context, child) {
              final scale =
                  (_currentMatchedItem == target.id && _showCorrectFeedback)
                  ? _bounceAnimation.value
                  : 1.0;

              return Transform.scale(
                scale: scale,
                child: DragTarget<String>(
                  onAcceptWithDetails: (details) {
                    _onDragTargetAccept(target.id!, details.data);
                  },
                  builder: (context, candidateData, rejectedData) {
                    return SizedBox(
                      width: size,
                      height: size,
                      child: isCompleted
                          ? _buildCompletedTarget(target)
                          : _buildTargetSilhouette(target, size),
                    );
                  },
                ),
              );
            },
          ),
        ),
      );
    }

    return targets;
  }

  Widget _buildTargetSilhouette(DragTargets target, double size) {
    // Show silhouette/outline image if available, otherwise show a placeholder
    if (target.imageOutline?.isNotEmpty == true) {
      return SvgHelper.fromSource(
        path: target.imageOutline!,
        type: SvgSourceType.network,
        color: null,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    // Fallback silhouette
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.kBlack.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.kWhite,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Icon(
        Icons.help_outline,
        color: AppColors.kWhite,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildCompletedTarget(DragTargets target) {
    return SvgHelper.fromSource(
      path: target.image ?? '',
      type: SvgSourceType.network,
      color: null,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.contain,
    );
  }

  List<Widget> _buildDraggableItems(
    Size screenSize,
    bool isMobile,
    bool isTablet,
    bool isLandscape,
  ) {
    if (widget.content.dragTargets?.isEmpty != false) return [];

    final draggables = <Widget>[];
    final positionsMap = _getDraggableItemPositionsMap(
      screenSize.width,
      screenSize.height,
      isMobile,
    );

    // Calculate draggable sizes (grid-based, use larger area for cell size calculation)
    // Use same usable dimensions as targets for consistent sizing
    final isLandscape = PlatformUtility.isLandscape(context);
    final double usableWidthPercent = isMobile
        ? 0.9
        : (isLandscape ? 0.85 : 0.82);
    final double usableHeightPercent = isMobile
        ? 0.5
        : (isLandscape ? 0.7 : 0.55);
    final double usableWidth = screenSize.width * usableWidthPercent;
    final double usableHeight = screenSize.height * usableHeightPercent;

    for (int i = 0; i < widget.content.dragTargets!.length; i++) {
      final target = widget.content.dragTargets![i];
      if (target.id?.isEmpty != false) continue;

      final isCompleted = _completedMatches[target.id] ?? false;
      if (isCompleted) continue; // Don't show completed items

      // Get position by animal ID (scattered in spaces between targets)
      final animalId = target.id!.toLowerCase();
      final position = positionsMap[animalId] ?? positionsMap.values.first;

      // Use grid-based size calculation (same usable area as targets for consistent cell size)
      final size = _getDraggableItemSizeForItem(
        target.id!,
        isMobile,
        usableWidth,
        usableHeight,
      );

      draggables.add(
        Positioned(
          left: position['left']!,
          bottom: position['bottom']!,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: _showIncorrectFeedback
                    ? _shakeAnimation.value * 10
                    : Offset.zero,
                child: Draggable<String>(
                  data: target.id!,
                  feedback: SizedBox(
                    width: size,
                    height: size,
                    child: SvgHelper.fromSource(
                      path: target.image ?? '',
                      type: SvgSourceType.network,
                      width: size,
                      height: size,
                      color: null,
                      fit: BoxFit.contain,
                    ),
                  ),
                  childWhenDragging: SizedBox(width: size, height: size),
                  child: Container(
                    key: _dragItemKeys[target.id!],
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SvgHelper.fromSource(
                      path: target.image ?? '',
                      type: SvgSourceType.network,
                      color: null,
                      width: size,
                      height: size,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return draggables;
  }

  Widget _buildVocabularyBox() {
    return AnimatedBuilder(
      animation: _vocabularyAnimation,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.kSecondaryColor,
          borderRadius: BorderRadius.circular(60),
        ),
        child: Text(
          _vocabularyText ?? '',
          style: AppStyles.text24PxBold.copyWith(
            color: AppColors.kWhite,
            fontSize: PlatformUtility.isTablet(context) ? 60 : 40,
            fontWeight: FontWeight.bold,
            fontFamily: AppConstants.kMuktaFont,
          ),
        ),
      ),
      builder: (context, child) {
        // Position at 1/3rd from the top of the screen
        final screenHeight = MediaQuery.of(context).size.height;
        return Positioned(
          top:
              (screenHeight / 3) -
              30 +
              (10 *
                  _vocabularyController.value), // 1/3rd from top with animation
          left: 0,
          right: 0,
          child: Center(
            child: Transform.scale(
              scale: 0.8 + (0.2 * _vocabularyController.value),
              child: Opacity(
                opacity: _vocabularyController.value,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorrectFeedback() {
    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: AppColors.kButtonGreen.withValues(
              alpha: 0.1 * _feedbackAnimation.value,
            ),
            child: Center(
              child: Transform.scale(
                scale: _feedbackAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.kButtonGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: AppColors.kWhite, size: 60),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncorrectFeedback() {
    return AnimatedBuilder(
      animation: _feedbackAnimation,
      builder: (context, child) {
        return Positioned.fill(
          child: Container(
            color: AppColors.kButtonRed.withValues(
              alpha: 0.1 * _feedbackAnimation.value,
            ),
            child: Center(
              child: Transform.scale(
                scale: _feedbackAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.kButtonRed,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: AppColors.kWhite, size: 60),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Map<String, Map<String, double>> _getTargetPositionsMap(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    final mediaQuery = MediaQuery.of(context);

    // Calculate image sizes for accurate bottom-left alignment
    // Use same dimensions as target size calculation
    final isLandscape = PlatformUtility.isLandscape(context);
    final double usableWidthPercent = isMobile
        ? 0.9
        : (isLandscape ? 0.85 : 0.82);
    final double usableHeightPercent = isMobile
        ? 0.5
        : (isLandscape ? 0.7 : 0.55);
    final double usableWidth = screenWidth * usableWidthPercent;
    final double usableHeight = screenHeight * usableHeightPercent;

    final imageSizeMap = <String, double>{};
    final animalOrder = ['rabbit', 'dog', 'cat', 'fish', 'bird', 'tortoise'];
    for (final animalId in animalOrder) {
      imageSizeMap[animalId] = GridPositionHelper.getImageSizeForAnimal(
        animalId,
        isMobile,
        isLandscape: isLandscape,
      );
    }

    return GridPositionHelper.getTargetPositionsMap(
      screenWidth,
      screenHeight,
      mediaQuery.padding.top,
      mediaQuery.padding.bottom,
      isMobile,
      imageSizeMap,
      safeAreaLeft: mediaQuery.padding.left,
      safeAreaRight: mediaQuery.padding.right,
    );
  }

  Map<String, Map<String, double>> _getDraggableItemPositionsMap(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    // Use grid-based positioning system (same as targets)
    // Use full screen width to allow draggables to reach screen edges
    final mediaQuery = MediaQuery.of(context);
    return GridPositionHelper.getDraggablePositionsMap(
      screenWidth,
      screenHeight,
      mediaQuery.padding.top,
      mediaQuery.padding.bottom,
      isMobile,
      safeAreaLeft: mediaQuery.padding.left,
      safeAreaRight: mediaQuery.padding.right,
    );
  }

  /// Get the appropriate size for different animals/items (grid-based, same as tap target)
  double _getTargetSizeForItem(
    String itemId,
    bool isMobile,
    double usableWidth,
    double usableHeight,
  ) {
    final isLandscape = PlatformUtility.isLandscape(context);
    return GridPositionHelper.getImageSizeForAnimal(
      itemId,
      isMobile,
      isLandscape: isLandscape,
    );
  }

  /// Get draggable item size (grid-based, same as targets)
  double _getDraggableItemSizeForItem(
    String itemId,
    bool isMobile,
    double usableWidth,
    double usableHeight,
  ) {
    final isLandscape = PlatformUtility.isLandscape(context);
    return GridPositionHelper.getDraggableSizeForAnimal(
      itemId,
      isMobile,
      isLandscape: isLandscape,
    );
  }
}
