import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

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

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.1, 0.0),
    ).animate(
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
  }

  void _startLessonFlow() async {
    // Step 1: Play Nepali audio question
    await _playQuestionAudio();

    // Step 2: Start sequential animal sound flow
    _startAnimalSounds();
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

    try {
      setState(() {
        _isWaitingForMatch = true;
      });

      _animalSoundAudio?.dispose();
      _animalSoundAudio = CustomAudioWidget(
        audioPath: target.audio!,
        audioSourceType: AudioSourceType.network,
      );
      await _animalSoundAudio!.play();
      logger.d(
        'Playing animal sound for ${target.nameEn} (index: $_currentAnimalIndex)',
      );
    } catch (e) {
      logger.e('Error playing animal sound: $e');
    }
  }

  void _playNextAnimalSound() {
    // Move to next animal and play its sound
    _currentAnimalIndex++;
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

    // Play vocabulary audio
    if (target.wordAudio?.isNotEmpty == true) {
      try {
        _vocabularyAudio?.dispose();
        _vocabularyAudio = CustomAudioWidget(
          audioPath: target.wordAudio!,
          audioSourceType: AudioSourceType.network,
        );
        await _vocabularyAudio!.play();
      } catch (e) {
        logger.e('Error playing vocabulary audio: $e');
      }
    }

    // Show vocabulary box animation
    _vocabularyController.forward();
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });

    // Check if all matches are completed
    if (_completedCount >= _totalMatches) {
      setState(() {
        _allCompleted = true;
      });

      // Show success lottie animation if confettiOnComplete is true and it's the last item
      if (widget.content.feedback?.confettiOnComplete == true &&
          widget.isLastItem) {
        setState(() {
          _showSuccessLottie = true;
        });

        // Hide success lottie after 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showSuccessLottie = false;
            });
          }
        });
      }

      // Show leopard animation for completion (only for last item)
      if (widget.isLastItem) {
        setState(() {
          showLeopardAnimation = true;
        });
      }

      // Dispose all audio widgets before proceeding
      _disposeAllAudioWidgets();

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
      Future.delayed(const Duration(seconds: 3), () {
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
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showLeopardAnimation = false;
            });
          }
        });
      }

      logger.d(
        'All matches completed! Course will auto-complete in 3 seconds.',
      );
    } else {
      // Hide vocabulary box after showing it and play next animal sound
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showVocabularyBox = false;
          _showCorrectFeedback = false;
        });
        _vocabularyController.reverse();

        // Play next animal sound after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          _playNextAnimalSound();
        });
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

    _questionAudio = null;
    _animalSoundAudio = null;
    _correctFeedbackAudio = null;
    _incorrectFeedbackAudio = null;
    _vocabularyAudio = null;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // Background park scene
          _buildParkBackground(),

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
        ],
      ),
    );
  }

  Widget _buildParkBackground() {
    // Use the background image from the lesson content or a default park scene
    final backgroundImage = widget.content.mbImage;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,

      child: SvgHelper.fromSource(
        path: backgroundImage ?? "",
        type: SvgSourceType.network,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  List<Widget> _buildDragTargets(
    Size screenSize,
    bool isMobile,
    bool isTablet,
    bool isLandscape,
  ) {
    if (widget.content.dragTargets?.isEmpty != false) return [];

    final targets = <Widget>[];
    final positions = _getTargetPositions(
      screenSize.width,
      screenSize.height,
      isMobile,
    );

    for (int i = 0; i < widget.content.dragTargets!.length; i++) {
      final target = widget.content.dragTargets![i];
      if (target.id?.isEmpty != false) continue;

      final position = positions[i % positions.length];
      final isCompleted = _completedMatches[target.id] ?? false;
      final size = _getTargetSizeForItem(target.id!, isMobile);

      targets.add(
        Positioned(
          left: position['left']!,
          top: position['top']!,
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
                    return Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border:
                            candidateData.isNotEmpty
                                ? Border.all(
                                  color: AppColors.kPureSkyBlue,
                                  width: 3,
                                )
                                : null,
                      ),
                      child:
                          isCompleted
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
    final positions = _getDraggableItemPositions(
      screenSize.width,
      screenSize.height,
      isMobile,
    );

    for (int i = 0; i < widget.content.dragTargets!.length; i++) {
      final target = widget.content.dragTargets![i];
      if (target.id?.isEmpty != false) continue;

      final isCompleted = _completedMatches[target.id] ?? false;
      if (isCompleted) continue; // Don't show completed items

      final position = positions[i % positions.length];
      final size = _getDraggableItemSizeForItem(target.id!, isMobile);

      draggables.add(
        Positioned(
          left: position['left']!,
          top: position['top']!,
          child: AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset:
                    _showIncorrectFeedback
                        ? _shakeAnimation.value * 10
                        : Offset.zero,
                child: Draggable<String>(
                  data: target.id!,
                  feedback: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.kBlack.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SvgHelper.fromSource(
                      path: target.image ?? '',
                      type: SvgSourceType.network,
                      width: size,
                      height: size,
                      color: null,
                      fit: BoxFit.contain,
                    ),
                  ),
                  childWhenDragging: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: AppColors.kLightGrey.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.kGrey,
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  child: Container(
                    key: _dragItemKeys[target.id!],
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: AppColors.kBlack.withValues(alpha: 0.1),
                      //     blurRadius: 4,
                      //     offset: const Offset(0, 2),
                      //   ),
                      // ],
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.kSecondaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _vocabularyText ?? '',
          style: AppStyles.text24PxBold.copyWith(
            color: AppColors.kWhite,
            fontFamily: AppConstants.kMuktaFont,
          ),
        ),
      ),
      builder: (context, child) {
        return Positioned(
          top: 40 + (20 * _vocabularyController.value),
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

  List<Map<String, double>> _getTargetPositions(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    // Define relative positions for drag targets in the park scene
    // Using the same positioning logic as tap_target_lesson_card.dart
    final double usableWidth = screenWidth * 0.9; // Leave some margin
    final double usableHeight =
        screenHeight * 0.5; // Use middle portion of screen
    final double startX = screenWidth * 0.05; // Start with 5% margin
    final double startY = screenHeight * 0.15; // Start from 15% down

    return [
      // Position 1 (bottom right, on grass)
      // Dog
      {
        'left': startX + usableWidth * 0.15,
        'top': startY + usableHeight * 0.44,
      },

      // Position 2 (left side, on grass)
      // Fish
      {'left': startX + usableWidth * 0.2, 'top': startY + usableHeight * 1.2},

      // Position 3 (center-left, near trees)
      // Rabbit
      {
        'left': startX + usableWidth * 0.78,
        'top': startY + usableHeight * 0.97,
      },

      // Position 4 (in water area - bottom center)
      // Bird
      {
        'left': startX + usableWidth * 0.80,
        'top': startY + usableHeight * 0.015 - 41,
      },

      // Position 5 (on tree branch - top area)
      // Cat
      {'left': startX + usableWidth * 0.68, 'top': startY + usableHeight * 0.4},

      // Tortoise
      {'left': startX + usableWidth * 0.5, 'top': startY + usableHeight * 1.10},

      //Additional positions for more targets
      {'left': startX + usableWidth * 0.45, 'top': startY + usableHeight * 0.3},
      {'left': startX + usableWidth * 0.6, 'top': startY + usableHeight * 0.6},
    ];
  }

  List<Map<String, double>> _getDraggableItemPositions(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    // Position draggable items at the bottom area of the screen
    // Using similar screen-based calculation as targets
    final double usableWidth = screenWidth * 0.9; // Leave some margin
    final double startX = screenWidth * 0.05; // Start with 5% margin
    final double bottomY = screenHeight * 0.8; // Bottom area

    return [
      // Dog
      {
        'left': startX + usableWidth * 0.0015,
        'top': bottomY * 0.75,
      }, // Bottom left
      // Fish
      {
        'left': startX + usableWidth * 0.0015,
        'top': bottomY * 0.6,
      }, // Bottom center-left
      // Rabbit
      {
        'left': startX + usableWidth * 0.92,
        'top': bottomY * 0.55,
      }, // Bottom center
      // Bird
      {
        'left': startX + usableWidth * 0.95,
        'top': bottomY * 0.25,
      }, // Bottom center-right
      // Cat
      {
        'left': startX + usableWidth * 0.0015,
        'top': bottomY * 0.12,
      }, // Bottom right
      // Tortoise
      {
        'left': startX + usableWidth * 0.95,
        'top': bottomY * 0.92,
      }, // Bottom right
      // Additional positions if needed
      {'left': startX + usableWidth * 0.2, 'top': bottomY + 40},
      {'left': startX + usableWidth * 0.6, 'top': bottomY + 40},
      {'left': startX + usableWidth * 0.8, 'top': bottomY + 40},
    ];
  }

  /// Get the appropriate size for different animals/items
  /// Using the same sizing logic as tap_target_lesson_card.dart
  double _getTargetSizeForItem(String itemId, bool isMobile) {
    final baseSizeMobile = isMobile ? 60.0 : 80.0;

    // For drag-to-match, we use slightly larger sizes than tap_target
    switch (itemId.toLowerCase()) {
      case 'rabbit':
      case 'cat':
        return baseSizeMobile * 1.75; // Smaller animals
      case 'dog':
        return baseSizeMobile * 2.85; // Medium-large animal
      case 'fish':
        return baseSizeMobile * 1.15; // Small animal
      case 'bird':
        return baseSizeMobile * 1.15; // Small-medium animal
      case 'tortoise':
        return baseSizeMobile * 1.15; // Medium animal
      case 'elephant':
        return baseSizeMobile * 1.3; // Large animal
      case 'tiger':
      case 'lion':
        return baseSizeMobile * 1.2; // Large animals
      case 'mouse':
        return baseSizeMobile * 0.7; // Very small animal
      default:
        return baseSizeMobile; // Default size
    }
  }

  double _getDraggableItemSizeForItem(String itemId, bool isMobile) {
    // Slightly smaller than targets for better UX
    final targetSize = _getTargetSizeForItem(itemId, isMobile);
    final isDog = itemId.toLowerCase() == 'dog';
    final size = isDog ? targetSize * 0.55 : targetSize * 0.85;

    return size; // 15% smaller than target
  }
}
