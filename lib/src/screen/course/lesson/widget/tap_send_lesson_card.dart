import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

class TapSendLessonCard extends StatefulWidget {
  final LessonContent content;
  final bool isPlaying;
  final VoidCallback? onPlay;
  final VoidCallback? onCorrectAnswer;
  final VoidCallback? onLessonComplete;
  final int index;
  final bool isLastItem;

  const TapSendLessonCard({
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
  State<TapSendLessonCard> createState() => _TapSendLessonCardState();
}

class _TapSendLessonCardState extends State<TapSendLessonCard> {
  String? selectedAnswer;
  bool showLeopardAnimation = false;
  List<TapSendOption> options = [];
  CustomAudioWidget? _goodFeedbackAudio;

  @override
  void initState() {
    super.initState();
    _parseOptions();
    _playWordAudio();
  }

  @override
  void didUpdateWidget(TapSendLessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      setState(() {
        selectedAnswer = null;
        showLeopardAnimation = false;
      });
      _parseOptions();
      _playWordAudio();
    }
  }

  void _parseOptions() {
    // Handle both string (comma-separated) and array formats
    final nameEn = _parseStringOrArray(widget.content.nameEn);
    final nameNp = _parseStringOrArray(widget.content.nameNp);
    final images = _parseStringOrArray(widget.content.image);
    final audios = _parseStringOrArray(widget.content.audio);

    // Parse colors if available
    List<String> colors = [];
    List<String> textColors = [];
    if (Utility.isAccessible(widget.content.color)) {
      colors = _parseStringOrArray(widget.content.color);
    }
    if (Utility.isAccessible(widget.content.textColor)) {
      textColors = _parseStringOrArray(widget.content.textColor);
      logger.d('Parsed text colors: $textColors');
    }

    options = List.generate(nameEn.length, (index) {
      return TapSendOption(
        nameEn: nameEn[index].trim(),
        nameNp: index < nameNp.length ? nameNp[index].trim() : '',
        image: index < images.length ? images[index].trim() : '',
        audio: index < audios.length ? audios[index].trim() : '',
        color: index < colors.length ? colors[index].trim() : "",
        textColor: index < textColors.length ? textColors[index].trim() : "",
      );
    });
  }

  /// Helper method to parse both string (comma-separated) and array formats
  List<String> _parseStringOrArray(dynamic value) {
    if (value == null) return [];

    if (value is List) {
      // If it's already a list, convert to List<String>
      return value.map((item) => item.toString()).toList();
    } else if (value is String) {
      // If it's a string, split by comma and space
      return value.split(', ');
    } else {
      // If it's neither, convert to string and return as single-item list
      return [value.toString()];
    }
  }

  void _playWordAudio() async {
    if (widget.content.wordAudio?.isNotEmpty == true) {
      final audioProvider = context.read<LessonAudioProvider>();
      await audioProvider.playWordAudio(widget.content.wordAudio ?? "");
    }
  }

  void _playGoodFeedbackAudio() async {
    try {
      _goodFeedbackAudio = CustomAudioWidget(
        audioPath: Assets.goodFeedback,
        audioSourceType: AudioSourceType.asset,
      );
      await _goodFeedbackAudio!.play();
    } catch (e) {
      logger.e('Error playing good feedback audio: $e');
    }
  }

  void _disposeGoodFeedbackAudio() async {
    try {
      if (_goodFeedbackAudio != null) {
        await _goodFeedbackAudio!.dispose();
        _goodFeedbackAudio = null;
      }
    } catch (e) {
      logger.e('Error disposing good feedback audio: $e');
    }
  }

  void _onOptionTap(TapSendOption option) {
    setState(() {
      selectedAnswer = option.nameEn;
    });

    // Play option audio
    if (option.audio.isNotEmpty) {
      final audioProvider = context.read<LessonAudioProvider>();
      audioProvider.playOptionAudio(option.audio);
    }
  }

  void _onConfirm() async {
    if (selectedAnswer == widget.content.correctAnswer) {
      if (widget.isLastItem) {
        setState(() {
          showLeopardAnimation = true;
        });

        // Play good feedback audio
        _playGoodFeedbackAudio();

        // Reset audio and cache
        final audioProvider = context.read<LessonAudioProvider>();
        await audioProvider.stopAudio();
        await audioProvider.clearCache();

        // Call lesson complete callback
        widget.onLessonComplete?.call();

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              showLeopardAnimation = false;
            });
            _disposeGoodFeedbackAudio();
          }
        });
      } else {
        // For non-last items, just move to next content
        widget.onCorrectAnswer?.call();
      }
    } else {
      setState(() {
        selectedAnswer = null;
      });
      showCustomToaster('Incorrect answer. Please try again.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    final isTablet = PlatformUtility.isTablet(context);
    final isLandscape = PlatformUtility.isLandscape(context);

    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Word audio button
            Gaps.verticalGapOf(80),
            // if (widget.content.wordAudio.isNotEmpty)
            //   Container(
            //     margin: const EdgeInsets.only(bottom: 20),
            //     child: CustomAvatarGlow(
            //       glowColor: AppColors.kSecondaryColor,
            //       glowShape: BoxShape.circle,
            //       visible: widget.isPlaying,
            //       glowRadiusFactor: 0.2,
            //       child: IconButton(
            //         icon: SvgHelper.fromSource(
            //           path: Assets.sound,
            //           height: AppConstants.kIconSize,
            //           width: AppConstants.kIconSize,
            //         ),
            //         onPressed: _playWordAudio,
            //       ),
            //     ),
            //   ),

            // Options grid
            _buildOptionsGrid(isMobile, isTablet, isLandscape),

            // Confirm button
            Container(
              margin: const EdgeInsets.only(top: 40),
              child: CustomMaterialButton(
                onTap: _onConfirm,
                elevation: 0,
                radius: 60,
                height: isTablet && isLandscape ? 10.h(context) : 48,
                width: isTablet && isLandscape ? 30.w(context) : 200,
                label: 'CONFIRM',

                textStyle:
                    isTablet && isLandscape
                        ? AppStyles.text24PxBold
                        : AppStyles.text16PxBold,
              ),
            ),
            Gaps.verticalGapOf(5),
          ],
        ),

        // Leopard animation from corner (only for last item)
        if (showLeopardAnimation && widget.isLastItem)
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
    );
  }

  Widget _buildOptionsGrid(bool isMobile, bool isTablet, bool isLandscape) {
    if (isMobile) {
      return _buildMobileLayout();
    } else if (isTablet) {
      return _buildTabletLayout(isLandscape);
    } else {
      return _buildWebLayout();
    }
  }

  Widget _buildMobileLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((option) {
            final isSelected = selectedAnswer == option.nameEn;
            return GestureDetector(
              onTap: () => _onOptionTap(option),
              child: Container(
                width: 25.w(context),
                height: 40.h(context),
                decoration: BoxDecoration(
                  color:
                      option.color.isNotEmpty
                          ? Utility.parseHexColors(option.color).first
                          : AppColors.learningColors[options.indexOf(option) %
                              AppColors.learningColors.length],
                  borderRadius: BorderRadius.circular(16),
                  border:
                      isSelected
                          ? Border.all(color: AppColors.kButtonGreen, width: 3)
                          : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      option.nameNp,
                      style: AppStyles.text20PxBold.copyWith(
                        color:
                            option.textColor.isNotEmpty
                                ? Utility.parseHexColors(option.textColor).first
                                : AppColors.kBlack,
                        fontFamily: AppConstants.kMuktaFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.verticalGapOf(8),
                    CustomImage(
                      option.image,
                      height: 20.h(context),
                      width: 20.w(context),
                      cover: false,
                      boxFit: BoxFit.cover,
                      circular: false,
                      imageType: CustomImageType.network,
                    ),
                    Gaps.verticalGapOf(8),
                    Text(
                      option.nameEn,
                      style: AppStyles.text12PxSemiBold.copyWith(
                        color:
                            option.textColor.isNotEmpty
                                ? Utility.parseHexColors(option.textColor).first
                                : AppColors.kBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildTabletLayout(bool isLandscape) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((option) {
            final isSelected = selectedAnswer == option.nameEn;
            return GestureDetector(
              onTap: () => _onOptionTap(option),
              child: Container(
                width: isLandscape ? 25.w(context) : 180,
                height: isLandscape ? 50.h(context) : 280,
                decoration: BoxDecoration(
                  color:
                      option.color.isNotEmpty
                          ? Utility.parseHexColors(option.color).first
                          : AppColors.learningColors[options.indexOf(option) %
                              AppColors.learningColors.length],
                  borderRadius: BorderRadius.circular(20),
                  border:
                      isSelected
                          ? Border.all(color: AppColors.kButtonGreen, width: 4)
                          : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImage(
                      option.image,
                      height: isLandscape ? 10.w(context) : 140,
                      width: isLandscape ? 30.h(context) : 140,
                      cover: false,
                      boxFit: BoxFit.cover,
                      circular: false,
                      imageType: CustomImageType.network,
                    ),
                    Gaps.verticalGapOf(30),
                    Text(
                      option.nameNp,
                      style: AppStyles.text20PxBold.copyWith(
                        color: AppColors.kSecondaryColor,
                        fontFamily: AppConstants.kMuktaFont,
                        fontWeight: FontWeight.bold,
                        fontSize: isLandscape ? 50 : 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      option.nameEn,
                      style: AppStyles.text16PxMedium.copyWith(
                        color: AppColors.kBlack,
                        fontSize: isLandscape ? 28 : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          options.map((option) {
            final isSelected = selectedAnswer == option.nameEn;
            return GestureDetector(
              onTap: () => _onOptionTap(option),
              child: Container(
                width: 220,
                height: 300,
                decoration: BoxDecoration(
                  color:
                      option.color.isNotEmpty
                          ? Utility.parseHexColors(option.color).first
                          : AppColors.learningColors[options.indexOf(option) %
                              AppColors.learningColors.length],
                  borderRadius: BorderRadius.circular(24),
                  border:
                      isSelected
                          ? Border.all(color: AppColors.kButtonGreen, width: 4)
                          : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomImage(
                      option.image,
                      height: 150,
                      width: 150,
                      cover: false,
                      boxFit: BoxFit.cover,
                      circular: false,
                      imageType: CustomImageType.network,
                    ),
                    Gaps.verticalGapOf(20),
                    Text(
                      option.nameNp,
                      style: AppStyles.text24PxBold.copyWith(
                        color: AppColors.kSecondaryColor,
                        fontFamily: AppConstants.kMuktaFont,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      option.nameEn,
                      style: AppStyles.text18PxMedium.copyWith(
                        color: AppColors.kBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
    );
  }

  @override
  void dispose() {
    _disposeGoodFeedbackAudio();
    super.dispose();
  }
}

class TapSendOption {
  final String nameEn;
  final String nameNp;
  final String image;
  final String audio;
  final String color;
  final String textColor;

  TapSendOption({
    required this.nameEn,
    required this.nameNp,
    required this.image,
    required this.audio,
    this.color = "",
    this.textColor = "",
  });
}
