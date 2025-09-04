import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

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

    // Start the lesson by playing the question audio
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _playQuestionAudio();
    });
  }

  @override
  void didUpdateWidget(TapTargetLessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      _resetState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
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

    // Step 3: Play the target audio when tapped
    try {
      _targetAudio = CustomAudioWidget(
        audioPath: target.audio ?? '',
        audioSourceType: AudioSourceType.network,
      );
      await _targetAudio!.play();
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
          widget.onLessonComplete?.call();
        } else {
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
    } catch (e) {
      logger.e('Error disposing audio widgets: $e');
    }
  }

  /// Get the appropriate size for different animals
  double _getTargetSizeForAnimal(String animalId, bool isMobile) {
    final baseSizeMobile = isMobile ? 60.0 : 80.0;

    switch (animalId.toLowerCase()) {
      case 'rabbit':
      case 'cat':
        return baseSizeMobile * 1.75; // Smaller animals
      case 'dog':
        return baseSizeMobile * 1.65; // Medium-large animal
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

  @override
  void dispose() {
    _feedbackController.dispose();
    _textController.dispose();
    _hintController.dispose();
    _disposeAudioWidgets();
    super.dispose();
  }

  Widget _buildParkScene() {
    final isMobile = PlatformUtility.isMobile(context);
    final isTablet = PlatformUtility.isTablet(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Use responsive background image
    final backgroundImage =
        isMobile
            ? widget.content.mbImage
            : (isTablet ? widget.content.tbImage : widget.content.tbImage);

    return SizedBox(
      width: screenWidth,
      height: screenHeight * 0.7,
      // decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        children: [
          // Background park scene
          if (backgroundImage?.isNotEmpty == true)
            Positioned.fill(
              child: ClipRRect(
                // borderRadius: BorderRadius.circular(16),
                child: SvgHelper.fromSource(
                  path: backgroundImage!,
                  fit: BoxFit.cover,
                  type: SvgSourceType.network,
                ),
              ),
            ),

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

          // Show question text at the top only when audio is playing or during reminders
          if (widget.content.text?.isNotEmpty == true && showQuestionText)
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kSecondaryColor.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.kBlack.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.content.text!,
                    style: AppStyles.text18PxBold.copyWith(
                      color: AppColors.kWhite,
                      fontFamily: AppConstants.kMuktaFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

          // Show Nepali text on top when correct target is selected
          if (showCorrectFeedback && selectedTargetNameNp != null)
            AnimatedBuilder(
              animation: _textController,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kSecondaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  selectedTargetNameNp!,
                  style: AppStyles.text24PxBold.copyWith(
                    color: AppColors.kWhite,
                    fontFamily: AppConstants.kMuktaFont,
                  ),
                ),
              ),
              builder: (context, child) {
                return Positioned(
                  top: 40 + (20 * _textController.value),
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

          // Success feedback animation
          if (showCorrectFeedback)
            AnimatedBuilder(
              animation: _feedbackController,
              child: LottieHelper.fromSource(
                path: Assets.starRewardLottie,
                height: 100,
                width: 100,
                repeat: false,
              ),
              builder: (context, child) {
                return Positioned(
                  top: screenHeight * 0.2 + (30 * _feedbackController.value),
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Transform.scale(
                      scale: _feedbackController.value,
                      child: Opacity(
                        opacity: _feedbackController.value,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
            ),

          // Incorrect feedback text is hidden for now
          // if (showIncorrectFeedback)
          //   Positioned(
          //     top: screenHeight * 0.3,
          //     left: 0,
          //     right: 0,
          //     child: Center(
          //       child: Container(
          //         padding: const EdgeInsets.symmetric(
          //           horizontal: 20,
          //           vertical: 10,
          //         ),
          //         decoration: BoxDecoration(
          //           color: AppColors.errorColor.withValues(alpha: 0.9),
          //           borderRadius: BorderRadius.circular(15),
          //         ),
          //         child: Text(
          //           widget.content.feedback?.incorrect?.text ??
          //               'फेरि प्रयास गर्नुहोस्',
          //           style: AppStyles.text16PxMedium.copyWith(
          //             color: AppColors.kWhite,
          //             fontFamily: AppConstants.kMuktaFont,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
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

    // Define positions for different animals in the park scene
    final positions = _getTargetPositions(screenWidth, screenHeight, isMobile);
    final position = positions[index % positions.length];

    final targetSize = _getTargetSizeForAnimal(target.id ?? '', isMobile);

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      left: position['left'],
      top: position['top'],
      child: GestureDetector(
        onTap: () => _onTargetTap(target),
        child:
            shouldShowHint
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
                : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform: Matrix4.identity()..scale(isSelected ? 1.1 : 1.0),
                  child: _buildTargetImage(target, targetSize, isSelected),
                ),
      ),
    );
  }

  Widget _buildTargetImage(
    TapTarget target,
    double targetSize,
    bool isSelected,
  ) {
    return Container(
      width: targetSize,
      height: targetSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border:
            isSelected
                ? Border.all(color: AppColors.kSecondaryColor, width: 3)
                : null,
        boxShadow:
            isSelected
                ? [
                  BoxShadow(
                    color: AppColors.kSecondaryColor.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
                : null,
      ),
      child: SvgHelper.fromSource(
        path: target.image ?? '',
        fit: BoxFit.contain,
        type: SvgSourceType.network,
      ),
    );
  }

  List<Map<String, double>> _getTargetPositions(
    double screenWidth,
    double screenHeight,
    bool isMobile,
  ) {
    // Define relative positions for animals in the park scene
    // These positions are designed to work with a typical park background
    // Adjust these positions to match your specific park background layout

    final double usableWidth = screenWidth * 0.9; // Leave some margin
    final double usableHeight =
        screenHeight * 0.5; // Use middle portion of screen
    final double startX = screenWidth * 0.05; // Start with 5% margin
    final double startY = screenHeight * 0.15; // Start from 15% down

    return [
      // Rabbit position (bottom right, on grass)
      {'left': startX + usableWidth * 0.9, 'top': startY + usableHeight * 0.9},

      // Dog position (left side, on grass)
      {
        'left': startX + usableWidth * 0.17,
        'top': startY + usableHeight * 0.76,
      },

      // Cat position (center-left, near trees)
      {'left': startX + usableWidth * 0.69, 'top': startY + usableHeight * 0.5},

      // Fish position (in water area - bottom center)
      {
        'left': startX + usableWidth * 0.18,
        'top': startY + usableHeight * 1.22,
      },

      // Bird position (on tree branch - top area)
      {
        'left': startX + usableWidth * 0.8,
        'top': startY + usableHeight * 0.015 - 40,
      },

      // Tortoise position (center-right, on grass)
      {
        'left': startX + usableWidth * 0.55,
        'top': startY + usableHeight * 1.15,
      },

      // Additional positions for more animals
      {'left': startX + usableWidth * 0.45, 'top': startY + usableHeight * 0.3},

      {'left': startX + usableWidth * 0.6, 'top': startY + usableHeight * 0.6},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: _buildParkScene(),
    );
  }
}
