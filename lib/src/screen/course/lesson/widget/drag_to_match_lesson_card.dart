import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLessonFlow();
    });
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

    if (widget.content.feedback?.incorrect?.audio?.isNotEmpty == true) {
      _incorrectFeedbackAudio = CustomAudioWidget(
        audioPath: widget.content.feedback!.incorrect!.audio!,
        audioSourceType: AudioSourceType.network,
      );
    }
  }

  void _startLessonFlow() async {
    // Step 1: Play Nepali audio question
    await _playQuestionAudio();

    // Step 2: Start playing animal sounds continuously
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
    // Play animal sounds for each drag target periodically
    if (widget.content.dragTargets?.isNotEmpty == true) {
      _playNextAnimalSound(0);
    }
  }

  void _playNextAnimalSound(int index) async {
    if (index >= widget.content.dragTargets!.length || _allCompleted) return;

    final target = widget.content.dragTargets![index];
    if (target.audio?.isNotEmpty == true &&
        !(_completedMatches[target.id] ?? false)) {
      try {
        _animalSoundAudio?.dispose();
        _animalSoundAudio = CustomAudioWidget(
          audioPath: target.audio!,
          audioSourceType: AudioSourceType.network,
        );
        await _animalSoundAudio!.play();
        logger.d('Playing animal sound for ${target.nameEn}');
      } catch (e) {
        logger.e('Error playing animal sound: $e');
      }
    }

    // Continue to next animal sound after a delay, but only if not all completed
    if (!_allCompleted) {
      Future.delayed(const Duration(seconds: 3), () {
        final nextIndex = (index + 1) % widget.content.dragTargets!.length;
        _playNextAnimalSound(nextIndex);
      });
    }
  }

  void _onDragTargetAccept(String targetId, String draggedId) async {
    final target = widget.content.dragTargets!.firstWhere(
      (t) => t.id == targetId,
      orElse: () => DragTargets(),
    );

    if (targetId == draggedId) {
      // Step 4: Correct match
      await _handleCorrectMatch(target);
    } else {
      // Step 5: Incorrect match
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
    if (target.audio?.isNotEmpty == true) {
      try {
        _vocabularyAudio?.dispose();
        _vocabularyAudio = CustomAudioWidget(
          audioPath: target.audio!,
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

      // Auto-complete the course after a brief delay to let user see the completion
      Future.delayed(const Duration(seconds: 3), () {
        if (widget.onLessonComplete != null) {
          widget.onLessonComplete!();
          logger.d('All matches completed! Auto-completing the course.');
        }
      });

      logger.d(
        'All matches completed! Course will auto-complete in 3 seconds.',
      );
    } else {
      // Hide vocabulary box after showing it
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showVocabularyBox = false;
          _showCorrectFeedback = false;
        });
        _vocabularyController.reverse();
      });
    }

    logger.d(
      'Correct match for ${target.nameEn}. Progress: $_completedCount/$_totalMatches',
    );
  }

  Future<void> _handleIncorrectMatch() async {
    setState(() {
      _showIncorrectFeedback = true;
    });

    // Haptic feedback
    HapticFeedback.heavyImpact();

    // Play incorrect feedback audio (try again)
    if (_incorrectFeedbackAudio != null) {
      try {
        await _incorrectFeedbackAudio!.play();
      } catch (e) {
        logger.e('Error playing incorrect feedback audio: $e');
      }
    }

    // Shake animation
    _shakeController.forward().then((_) {
      _shakeController.reverse();
    });

    // Hide incorrect feedback after a delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _showIncorrectFeedback = false;
      });
    });

    logger.d('Incorrect match attempted');
  }

  @override
  void dispose() {
    _vocabularyController.dispose();
    _feedbackController.dispose();
    _bounceController.dispose();
    _shakeController.dispose();

    _questionAudio?.dispose();
    _animalSoundAudio?.dispose();
    _correctFeedbackAudio?.dispose();
    _incorrectFeedbackAudio?.dispose();
    _vocabularyAudio?.dispose();

    super.dispose();
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
      builder: (context, child) {
        return Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Transform.scale(
            scale: _vocabularyAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.kButtonGreen, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kBlack.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: AppColors.kButtonGreen,
                    size: 40,
                  ),
                  Gaps.verticalGapOf(8),
                  Text(
                    _vocabularyText ?? '',
                    style: AppStyles.text24PxBold.copyWith(
                      color: AppColors.kSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Gaps.verticalGapOf(4),
                  Text(
                    'शाबास! (Shabash!)',
                    style: AppStyles.text16PxMedium.copyWith(
                      color: AppColors.kButtonGreen,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
        'top': bottomY * 0.7,
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
    return targetSize * 0.85; // 15% smaller than target
  }
}
