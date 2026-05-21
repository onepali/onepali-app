import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';
import 'grid_position_helper.dart';

/// A widget that displays an interactive park scene for tap_target type lessons.
///
/// This widget follows the specified flow:
/// 1. Automatically plays the Nepali audio question (word_audio)
/// 2. Child hears the voice, sees the animals, and taps the correct animal
/// 3. When child taps an animal, they hear the animal name audio and see Nepali text
/// 4. Shows mini feedback with audio, lottie animation, and Nepali text for correct answers
/// 5. For wrong answers, provides feedback and reminder after 3 attempts
///
/// The widget is fully responsive and positions animals naturally in a park scene.
class TapTargetLessonCard extends StatefulWidget {
  final LessonContent content;
  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onCorrectAnswer;
  final VoidCallback? onLessonComplete;
  final int index;
  final bool isLastItem;

  const TapTargetLessonCard({
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
  State<TapTargetLessonCard> createState() => _TapTargetLessonCardState();
}

class _TapTargetLessonCardState extends State<TapTargetLessonCard>
    with TickerProviderStateMixin {
  String? selectedTargetId;
  bool showCorrectFeedback = false;
  bool showIncorrectFeedback = false;
  String? feedbackText;
  String? selectedTargetNameNp;
  int wrongAttempts = 0;
  bool showHintAnimation = false;
  bool showQuestionText = false; // Controls when to show the question text
  late AnimationController _feedbackController;
  late AnimationController _textController;
  late AnimationController _hintController;
  CustomAudioWidget? _correctFeedbackAudio;
  CustomAudioWidget? _incorrectFeedbackAudio;
  CustomAudioWidget? _targetAudio;

  // Preloaded audio widgets for faster playback
  final Map<String, CustomAudioWidget> _preloadedTargetAudios = {};

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _hintController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Preload all target audios
    _preloadAllAudios();

    // Log lesson content details for rabbit and cat
    _logLessonContentDetails();

    // Start the lesson by playing the question audio
    Misc.onLayoutRendered(() {
      _playQuestionAudio();
    });
  }

  void _logLessonContentDetails() {
    logger.d('=== LESSON CONTENT DETAILS ===');
    logger.d('Content Index: ${widget.index}');
    logger.d('Question Audio (wordAudio): ${widget.content.wordAudio}');
    logger.d('Correct Answer ID: ${widget.content.correctAnswerId}');
    logger.d('Content Type: ${widget.content.type}');

    if (widget.content.tapTargets != null) {
      logger.d('Available Animals (${widget.content.tapTargets!.length}):');
      for (final target in widget.content.tapTargets!) {
        final isCorrect = target.id == widget.content.correctAnswerId;
        logger.d(
          '  - ${target.id} (${target.nameEn} / ${target.nameNp})${isCorrect ? " ⭐ CORRECT" : ""}',
        );
        logger.d('    Image: ${target.image}');
        logger.d('    Audio: ${target.audio}');
      }
    }

    // Check if this is rabbit or cat question
    if (widget.content.correctAnswerId?.toLowerCase() == 'rabbit') {
      logger.d('>>> THIS IS THE RABBIT QUESTION <<<');
    } else if (widget.content.correctAnswerId?.toLowerCase() == 'cat') {
      logger.d('>>> THIS IS THE CAT QUESTION <<<');
    }
    logger.d('================================');
  }

  void _preloadAllAudios() {
    if (widget.content.tapTargets?.isEmpty != false) return;

    for (final target in widget.content.tapTargets!) {
      if (target.id?.isEmpty == true || target.audio?.isEmpty == true) continue;

      try {
        _preloadedTargetAudios[target.id!] = CustomAudioWidget(
          audioPath: target.audio!,
          audioSourceType: AudioSourceType.network,
        );
        logger.d('Preloaded audio for ${target.id}');
      } catch (e) {
        logger.e('Error preloading audio for ${target.id}: $e');
      }
    }

    logger.d('Preloaded ${_preloadedTargetAudios.length} target audios');
  }

  @override
  void didUpdateWidget(TapTargetLessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      // Dispose audio before resetting state for new content
      _disposeAudioWidgets();

      _resetState();

      // Preload audios for new content
      _preloadAllAudios();

      Misc.onLayoutRendered(() {
        _playQuestionAudio();
      });
    }
  }

  void _resetState() {
    selectedTargetId = null;
    showCorrectFeedback = false;
    showIncorrectFeedback = false;
    feedbackText = null;
    selectedTargetNameNp = null;
    wrongAttempts = 0;
    showHintAnimation = false;
    showQuestionText = false;
    _feedbackController.reset();
    _textController.reset();
    _hintController.reset();
    _disposeAudioWidgets();
  }

  void _playQuestionAudio() async {
    // Show question text when audio plays
    setState(() {
      showQuestionText = true;
    });

    // Step 1: Play the question audio (word_audio)
    if (widget.content.wordAudio?.isNotEmpty == true) {
      try {
        final audioProvider = context.read<LessonAudioProvider>();
        await audioProvider.playWordAudio(widget.content.wordAudio!);
      } catch (e) {
        logger.e('Error playing question audio: $e');
      }
    }

    // Hide question text after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showQuestionText = false;
        });
      }
    });
  }

  void _onTargetTap(TapTarget target) async {
    if (showCorrectFeedback || showIncorrectFeedback) return;

    setState(() {
      selectedTargetId = target.id;
      selectedTargetNameNp = target.nameNp;
    });

    // Add haptic feedback for better UX
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Haptic feedback not available on all platforms
    }

    // Step 3: Play the target audio when tapped (use preloaded audio)
    try {
      // Use preloaded audio if available, otherwise create new one
      final preloadedAudio = _preloadedTargetAudios[target.id];
      if (preloadedAudio != null) {
        await preloadedAudio.play();
        logger.d('Playing preloaded audio for ${target.id}');
      } else {
        // Fallback to creating new audio widget
        _targetAudio = CustomAudioWidget(
          audioPath: target.audio ?? '',
          audioSourceType: AudioSourceType.network,
        );
        await _targetAudio!.play();
        logger.d('Playing audio for ${target.id}');
      }
    } catch (e) {
      logger.e('Error playing target audio: $e');
    }

    // Check if this is the correct answer
    final isCorrect = target.id == widget.content.correctAnswerId;

    if (isCorrect) {
      _handleCorrectAnswer(target);
    } else {
      _handleIncorrectAnswer();
    }
  }

  void _handleCorrectAnswer(TapTarget target) async {
    setState(() {
      showCorrectFeedback = true;
      feedbackText = target.nameNp; // Show Nepali name on top
    });

    // Step 4: Show mini feedback with animation and play correct feedback audio
    _feedbackController.forward();
    _textController.forward();

    try {
      // Play correct feedback audio
      final correctFeedback = widget.content.feedback?.correct;
      if (correctFeedback?.audio?.isNotEmpty == true) {
        _correctFeedbackAudio = CustomAudioWidget(
          audioPath: correctFeedback!.audio!,
          audioSourceType: AudioSourceType.network,
        );
        await _correctFeedbackAudio!.play();
      }
    } catch (e) {
      logger.e('Error playing correct feedback audio: $e');
    }

    // Wait for feedback animation and proceed
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (widget.isLastItem) {
          // For last item, dispose audio and call lesson complete
          _disposeAudioWidgets();

          // Reset audio provider state
          try {
            final audioProvider = Provider.of<LessonAudioProvider>(
              context,
              listen: false,
            );
            audioProvider.stopAudio();
            audioProvider.clearCache();
          } catch (e) {
            logger.e('Error stopping audio provider: $e');
          }

          widget.onLessonComplete?.call();
        } else {
          // Dispose audio before moving to next content
          _disposeAudioWidgets();

          // Reset audio provider state to prevent background audio
          try {
            final audioProvider = Provider.of<LessonAudioProvider>(
              context,
              listen: false,
            );
            audioProvider.stopAudio();
          } catch (e) {
            logger.e('Error stopping audio provider: $e');
          }

          widget.onCorrectAnswer?.call();
        }
      }
    });
  }

  void _handleIncorrectAnswer() async {
    wrongAttempts++;

    setState(() {
      showIncorrectFeedback = true;
    });

    try {
      // Play incorrect feedback audio
      final incorrectFeedback = widget.content.feedback?.incorrect;
      if (incorrectFeedback?.audio?.isNotEmpty == true) {
        _incorrectFeedbackAudio = CustomAudioWidget(
          audioPath: incorrectFeedback!.audio!,
          audioSourceType: AudioSourceType.network,
        );
        await _incorrectFeedbackAudio!.play();
      }
    } catch (e) {
      logger.e('Error playing incorrect feedback audio: $e');
    }

    // Hide incorrect feedback after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          showIncorrectFeedback = false;
          selectedTargetId = null;
        });
      }
    });

    // Play reminder every 3 wrong attempts (3, 6, 9, 12, 15, etc.)
    final reminderAttempts =
        widget.content.feedback?.reminderAfterAttempts ?? 3;
    if (wrongAttempts % reminderAttempts == 0) {
      setState(() {
        showHintAnimation = true;
      });
      _hintController.repeat(reverse: true);

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _playQuestionAudio(); // Replay the question
          // Stop hint animation after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                showHintAnimation = false;
              });
              _hintController.stop();
            }
          });
        }
      });
    }
  }

  void _disposeAudioWidgets() async {
    try {
      await _correctFeedbackAudio?.dispose();
      await _incorrectFeedbackAudio?.dispose();
      await _targetAudio?.dispose();
      _correctFeedbackAudio = null;
      _incorrectFeedbackAudio = null;
      _targetAudio = null;

      // Dispose preloaded audios
      for (final audio in _preloadedTargetAudios.values) {
        await audio.dispose();
      }
      _preloadedTargetAudios.clear();
    } catch (e) {
      logger.e('Error disposing audio widgets: $e');
    }
  }

  /// Get usable dimensions for positioning (centralized calculation)
  Map<String, double> _getUsableDimensions(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    final isLandscape = PlatformUtility.isLandscape(context);
    final double marginX, marginY, usableWidthPercent, usableHeightPercent;

    if (isMobile) {
      marginX = screenWidth * 0.05; // 5% margin
      marginY = screenHeight * 0.15; // 15% from top
      usableWidthPercent = 0.9; // 90% of width
      usableHeightPercent = 0.80; // 80% of height to fill most of the screen
    } else {
      // Tablet handling
      marginX = screenWidth * 0.08; // 8% margin
      marginY = isLandscape ? screenHeight * 0.12 : screenHeight * 0.18;
      usableWidthPercent = isLandscape ? 0.85 : 0.82;
      usableHeightPercent = isLandscape ? 0.7 : 0.55;
    }

    return {
      'marginX': marginX,
      'marginY': marginY,
      'usableWidth': screenWidth * usableWidthPercent,
      'usableHeight': screenHeight * usableHeightPercent,
    };
  }

  /// Get the appropriate size for different animals (grid-based)
  double _getTargetSizeForAnimal(
    String animalId,
    bool isMobile,
    double usableWidth,
    double usableHeight,
  ) {
    final isLandscape = PlatformUtility.isLandscape(context);
    return GridPositionHelper.getImageSizeForAnimal(
      animalId,
      isMobile,
      isLandscape: isLandscape,
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _textController.dispose();
    _hintController.dispose();
    _disposeAudioWidgets();
    super.dispose();
  }

  Widget _buildParkScene() {
    // Get screen size - use full screen for grid, but account for SafeArea in startY
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    // Background image is handled at parent level in lesson_content_screen.dart
    // to fill the entire screen (appears once)

    return SizedBox.expand(
      child: Stack(
        clipBehavior:
            Clip.none, // Allow overflow so rabbit can be visible at edges
        children: [
          // Background image is handled at parent level in lesson_content_screen.dart
          // to fill the entire screen (appears once)

          // Positioned animals/targets
          if (widget.content.tapTargets != null)
            ...widget.content.tapTargets!.asMap().entries.map((entry) {
              final index = entry.key;
              final target = entry.value;

              return _buildTargetWidget(
                target,
                index,
                screenWidth,
                screenHeight,
              );
            }),

          // Show Nepali text on top when correct target is selected
          // Positioned above audio icon (which is at top: 16) to appear on top
          if (showCorrectFeedback && selectedTargetNameNp != null)
            AnimatedBuilder(
              animation: _textController,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kSecondaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  selectedTargetNameNp!,
                  style: AppStyles.text24PxBold.copyWith(
                    color: AppColors.kWhite,
                    fontSize:
                        PlatformUtility.isTablet(context) &&
                            PlatformUtility.isLandscape(context)
                        ? 64
                        : 40,
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
                          _textController
                              .value), // 1/3rd from top with animation
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Transform.scale(
                      scale: 0.8 + (0.2 * _textController.value),
                      child: Opacity(
                        opacity: _textController.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Success feedback animation - positioned on the correct target
          if (showCorrectFeedback && selectedTargetId != null)
            AnimatedBuilder(
              animation: _feedbackController,
              child: LottieHelper.fromSource(
                path: widget.content.feedback?.correct?.animation ?? '',
                height: 160,
                width: 160,
                repeat: false,
                type: LottieSourceType.network,
              ),
              builder: (context, child) {
                // Find the position of the selected target
                final targetIndex =
                    widget.content.tapTargets?.indexWhere(
                      (target) => target.id == selectedTargetId,
                    ) ??
                    0;

                final isMobile = PlatformUtility.isMobile(context);
                final positionsMap = _getTargetPositionsMap(
                  screenWidth,
                  screenHeight,
                  isMobile,
                );
                final selectedTarget = widget.content.tapTargets?[targetIndex];
                final animalId = selectedTarget?.id?.toLowerCase() ?? '';
                final position =
                    positionsMap[animalId] ?? positionsMap.values.first;

                return Positioned(
                  left:
                      position['left']! - 10, // Center the lottie on the target
                  bottom: position['bottom'] != null
                      ? position['bottom']! - 10
                      : null,
                  child: Transform.scale(
                    scale: _feedbackController.value,
                    child: Opacity(
                      opacity: _feedbackController.value,
                      child: child,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTargetWidget(
    TapTarget target,
    int index,
    double screenWidth,
    double screenHeight,
  ) {
    final isSelected = selectedTargetId == target.id;
    final isCorrectTarget = target.id == widget.content.correctAnswerId;
    final shouldShowHint = showHintAnimation && isCorrectTarget;
    final isMobile = PlatformUtility.isMobile(context);

    // Use centralized dimension calculation
    final dimensions = _getUsableDimensions(
      screenWidth,
      screenHeight,
      isMobile,
    );
    final double usableWidth = dimensions['usableWidth']!;
    final double usableHeight = dimensions['usableHeight']!;

    // Get position by animal ID (same as drag-to-match)
    final positionsMap = _getTargetPositionsMap(
      screenWidth,
      screenHeight,
      isMobile,
    );
    final animalId = target.id?.toLowerCase() ?? '';
    final position = positionsMap[animalId] ?? positionsMap.values.first;

    final targetSize = _getTargetSizeForAnimal(
      target.id ?? '',
      isMobile,
      usableWidth,
      usableHeight,
    );

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: position['left']!,
      bottom: position['bottom']!,
      child: GestureDetector(
        onTap: () => _onTargetTap(target),
        child: shouldShowHint
            ? AnimatedBuilder(
                animation: _hintController,
                child: _buildTargetImage(target, targetSize, isSelected),
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (0.2 * _hintController.value),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.kYellow.withValues(
                              alpha: 0.6 * _hintController.value,
                            ),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  );
                },
              )
            : Transform.scale(
                scale: isSelected ? 1.1 : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: _buildTargetImage(target, targetSize, isSelected),
                ),
              ),
      ),
    );
  }

  Widget _buildTargetImage(
    TapTarget target,
    double targetSize,
    bool isSelected,
  ) {
    // Check if this is a rabbit to apply horizontal flip
    final bool isRabbit = target.id?.toLowerCase() == 'rabbit';

    return SizedBox(
      width: targetSize,
      height: targetSize,
      child: Transform(
        alignment: Alignment.center,
        transform: isRabbit ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
        child: SvgHelper.fromSource(
          path: target.image ?? '',
          width: targetSize,
          height: targetSize,
          fit: BoxFit.contain,
          type: SvgSourceType.network,
        ),
      ),
    );
  }

  Map<String, Map<String, double>> _getTargetPositionsMap(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    final mediaQuery = MediaQuery.of(context);

    // Build image size map for accurate bottom-left alignment
    final isLandscape = PlatformUtility.isLandscape(context);
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        clipBehavior:
            Clip.none, // Allow overflow so rabbit can be visible at edges
        children: [
          // Main park scene content
          _buildParkScene(),
          // Close button is handled by parent _buildActionButtons
        ],
      ),
    );
  }
}
