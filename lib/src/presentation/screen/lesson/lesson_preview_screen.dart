import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../src.dart';

class LessonPreviewScreen extends StatefulWidget {
  final Lesson lesson;
  const LessonPreviewScreen({super.key, required this.lesson});

  @override
  State<LessonPreviewScreen> createState() => _LessonPreviewScreenState();
}

class _LessonPreviewScreenState extends State<LessonPreviewScreen> {
  final AudioPlayer _audioPlayer1 = AudioPlayer();
  final AudioPlayer _audioPlayer2 = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer1.dispose();
    _audioPlayer2.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    setState(() {
      _isPlaying = true;
    });

    await Future.wait([
      _audioPlayer1.play(AssetSource(widget.lesson.audio)),
      _audioPlayer2.play(AssetSource(widget.lesson.wordAudio)),
    ]);

    _audioPlayer1.onPlayerComplete.listen((_) {
      if (_audioPlayer2.state != PlayerState.playing) {
        _onPlaybackComplete();
      }
    });

    _audioPlayer2.onPlayerComplete.listen((_) {
      if (_audioPlayer1.state != PlayerState.playing) {
        _onPlaybackComplete();
      }
    });
  }

  void _onPlaybackComplete() {
    setState(() {
      _isPlaying = false;
    });
    // Automatically navigate to the next item
    _navigateToNext();
  }

  void _navigateToNext() {
    // Logic to navigate to the next lesson
  }

  void _navigateToPrevious() {
    // Logic to navigate to the previous lesson
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;

    return Scaffold(
      backgroundColor: AppColors.kWhite,
      body: SafeArea(
        child: Stack(
          children: [
            // Home button top right
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                padding: const EdgeInsets.all(8),
                icon: SvgHelper.fromSource(
                  path: Assets.redo,
                  height: 50,
                  width: 50,
                ),
                color: AppColors.kSecondaryColor,
                alignment: Alignment.center,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Left card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kGreen.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: AppColors.kGreen),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Category tag
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.kGreen,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.park,
                                          size: 16,
                                          color: AppColors.kWhite,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          lesson.type ?? 'जंगली',
                                          style: TextStyle(
                                            color: AppColors.kWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Gaps.verticalGapOf(20),
                                // Image
                                Expanded(
                                  child: CustomImage(
                                    lesson.image,
                                    borderRadius: 8,
                                    imageType: CustomImageType.local,
                                    boxFit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Right card
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.kSecondaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.kSecondaryColor,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  lesson.nameNp,
                                  style: AppStyles.text32PxMedium.copyWith(
                                    color: AppColors.kSecondaryColor,
                                  ),
                                ),
                                Gaps.verticalGapOf(12),
                                Text(
                                  lesson.nameEn,
                                  style: AppStyles.text20PxMedium,
                                ),
                                Gaps.verticalGapOf(20),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.kTeal.withValues(
                                      alpha: 0.1,
                                    ),
                                    border: Border.all(color: AppColors.kTeal),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.pets_outlined,
                                        color: AppColors.kTeal,
                                      ),
                                      Gaps.horizontalGapOf(8),
                                      Text(
                                        lesson.tooltip ?? 'यो जंगली जनावर हो!',
                                        style: AppStyles.text16PxMedium
                                            .copyWith(color: AppColors.kTeal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation & Audio
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.leftArrow,
                          height: 48,
                          width: 48,
                          color:
                              _isPlaying
                                  ? AppColors.kGrey
                                  : AppColors.kSecondaryColor,
                        ),
                        onPressed: _isPlaying ? null : _navigateToPrevious,
                      ),
                      Gaps.horizontalGapOf(24),
                      IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.sound,
                          height: 60,
                          width: 60,
                          color: AppColors.kPrimaryColor,
                        ),
                        onPressed: _isPlaying ? null : _playAudio,
                      ),
                      Gaps.horizontalGapOf(24),
                      IconButton(
                        icon: SvgHelper.fromSource(
                          path: Assets.rightArrow,
                          height: 48,
                          width: 48,
                          color:
                              _isPlaying
                                  ? AppColors.kGrey
                                  : AppColors.kSecondaryColor,
                        ),
                        onPressed: _isPlaying ? null : _navigateToNext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
