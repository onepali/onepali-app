import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';
import 'package:provider/provider.dart';

class StoryContentCard extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  const StoryContentCard({
    super.key,
    required this.content,
    this.onConfetti,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    switch (content.type) {
      case 'drag_drop':
        return _DragDropContent(content: content);
      case 'normal':
        return _NormalContent(content: content);
      case 'slide':
        return _SlideContent(content: content);
      case 'button_tap':
        return _ButtonTapContent(content: content);
      case 'normal_confetti':
        return _NormalConfettiContent(
          content: content,
          onConfetti: onConfetti,
          isLast: isLast,
        );
      default:
        return const SizedBox();
    }
  }
}

// Drag & Drop UI
class _DragDropContent extends StatefulWidget {
  final Content content;
  const _DragDropContent({required this.content});
  @override
  State<_DragDropContent> createState() => _DragDropContentState();
}

class _DragDropContentState extends State<_DragDropContent> {
  late List<bool> dropped;
  late List<bool> correct;
  late List<int?> droppedOn;
  bool finished = false;
  int? tryAgainIdx;

  @override
  void initState() {
    super.initState();
    final n = widget.content.conversation.length;
    dropped = List.generate(n, (_) => false);
    correct = List.generate(n, (_) => false);
    droppedOn = List.generate(n, (_) => null);
    tryAgainIdx = null;
  }

  @override
  Widget build(BuildContext context) {
    final conv = widget.content.conversation;
    final charList = widget.content.characters ?? [];
    final char1 = charList.isNotEmpty ? charList[0] : null;
    final char2 = charList.length > 1 ? charList[1] : null;
    final bgColor = const Color(0xFFB3F1FF);

    if (finished) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thank You! 🎉',
                style: AppStyles.text35PxSemiBold.copyWith(
                  color: AppColors.kSecondaryColor,
                  fontFamily: 'Mukta',
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(16),
              Text(
                'You have completed the story. Great job!',
                style: AppStyles.text16PxRegular.copyWith(
                  color: AppColors.kGrey,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.verticalGapOf(40),
              CustomMaterialButton(
                label: 'Back to Home',
                backgroundColor: AppColors.kButtonGreen,

                radius: 32,
                width: 220,
                elevation: 0,
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icons.home,
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: bgColor,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Characters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (char1 != null)
                SvgHelper.fromSource(
                  path: char1,
                  height: 70,
                  width: 70,
                  type: SvgSourceType.network,
                ),
              if (char2 != null)
                SvgHelper.fromSource(
                  path: char2,
                  height: 70,
                  width: 70,
                  type: SvgSourceType.network,
                ),
            ],
          ),
          Gaps.verticalGapOf(32),
          // Drop targets (messageEn)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(conv.length, (i) {
              return DragTarget<int>(
                onWillAcceptWithDetails: (data) => !correct[i],
                onAcceptWithDetails: (details) {
                  final isCorrect = conv[details.data].id == conv[i].id;
                  setState(() {
                    if (isCorrect) {
                      dropped[details.data] = true;
                      droppedOn[details.data] = i;
                      correct[i] = true;
                      tryAgainIdx = null;
                      if (correct.every((c) => c)) finished = true;
                    } else {
                      tryAgainIdx = details.data;
                      // Optionally, show a SnackBar or similar feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Try Again!')),
                      );
                    }
                  });
                },
                builder: (context, candidate, rejected) {
                  final isMatched = droppedOn.contains(i) && correct[i];
                  return Container(
                    width: 200,
                    height: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(
                        color: Colors.white,
                        width: 6,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child:
                          isMatched
                              ? const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 40,
                              )
                              : Text(
                                conv[i].messageEn,
                                style: AppStyles.text20PxSemiBold.copyWith(
                                  color: AppColors.kGrey,
                                ),
                              ),
                    ),
                  );
                },
              );
            }),
          ),
          Gaps.verticalGapOf(32),
          // Draggable buttons (messageNp)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(conv.length, (i) {
              final showTryAgain = tryAgainIdx == i;
              return Opacity(
                opacity: dropped[i] ? 0.5 : 1.0,
                child: Column(
                  children: [
                    Draggable<int>(
                      data: i,
                      feedback: _dragButton(
                        conv[i].messageNp,
                        i,
                        dropped[i],
                        context,
                        showTryAgain: showTryAgain,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: _dragButton(conv[i].messageNp, i, true, context),
                      ),
                      onDragCompleted: () {},
                      maxSimultaneousDrags: dropped[i] ? 0 : 1,
                      child: _dragButton(
                        conv[i].messageNp,
                        i,
                        dropped[i],
                        context,
                        showTryAgain: showTryAgain,
                      ),
                    ),
                    if (showTryAgain)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Try Again',
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _dragButton(
    String label,
    int i,
    bool isDropped,
    BuildContext context, {
    bool showTryAgain = false,
  }) {
    final colors = [const Color(0xFFFFAEBB), const Color(0xFF2DD4BF)];
    return Container(
      width: 220,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: colors[i % colors.length],
        borderRadius: BorderRadius.circular(48),
        boxShadow: [
          if (!isDropped)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
        border: showTryAgain ? Border.all(color: Colors.red, width: 2) : null,
      ),
      child: Center(
        child: Text(
          label,
          style: AppStyles.text20PxSemiBold.copyWith(
            color: AppColors.kBlack,
            fontFamily: 'Mukta',
          ),
        ),
      ),
    );
  }
}

// Normal UI
class _NormalContent extends StatelessWidget {
  final Content content;
  const _NormalContent({required this.content});
  @override
  Widget build(BuildContext context) {
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    Widget arrowButton({required bool isLeft, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.kWhite,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.kBlack.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: SvgHelper.fromSource(
            path: isLeft ? Assets.leftArrow : Assets.rightArrow,
            height: 35,
            width: 35,
          ),
        ),
      );
    }

    // Prepare all conversation rows
    List<Widget> messageWidgets = [];
    for (final conversation in content.conversation) {
      String? iconPath;
      String messageNp = conversation.messageNp;
      // Remove prefix before and including ':' if present
      final colonIdx = messageNp.indexOf(':');
      if (colonIdx != -1) {
        iconPath = conversation.icon;
        messageNp = messageNp.substring(colonIdx + 1).trimLeft();
      }
      // Split on \n for multi-line
      final lines = messageNp.split('\n');
      for (var i = 0; i < lines.length; i++) {
        messageWidgets.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconPath != null && iconPath.isNotEmpty && i == 0)
                SvgHelper.fromSource(
                  path: iconPath,
                  height: 26,
                  width: 26,
                  type: SvgSourceType.network,
                ),
              if (iconPath != null && iconPath.isNotEmpty && i == 0)
                Gaps.horizontalGapOf(12.0),
              Text(
                lines[i],
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.text20PxMedium.copyWith(fontFamily: 'Mukta'),
              ),
            ],
          ),
        );
      }
    }
    return Stack(
      children: [
        // Background image (full screen)
        if (content.image.isNotEmpty)
          Positioned.fill(
            bottom: 60,
            child: CustomImage(
              content.image,
              imageType: CustomImageType.network,
              boxFit: BoxFit.cover,
            ),
          ),
        // Top center sound icon
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => storyProvider.playAudio(content.audio),
              child: SvgHelper.fromSource(path: Assets.sound, height: 40),
            ),
          ),
        ),
        // Top right wrong icon
        Positioned(
          top: 24,
          right: 24,
          child: SvgHelper.fromSource(path: Assets.wrong, height: 36),
        ),
        // Left arrow (center vertically)
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: arrowButton(
              isLeft: true,
              onTap: () => storyProvider.previousContent(),
            ),
          ),
        ),
        // Right arrow (center vertically)
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: arrowButton(
              isLeft: false,
              onTap: () => storyProvider.nextContent(),
            ),
          ),
        ),
        // Bottom white background with text
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: messageWidgets,
            ),
          ),
        ),
      ],
    );
  }
}

// Slide UI
class _SlideContent extends StatefulWidget {
  final Content content;
  const _SlideContent({required this.content});
  @override
  State<_SlideContent> createState() => _SlideContentState();
}

class _SlideContentState extends State<_SlideContent> {
  double _position = 0.0;
  bool _completed = false;

  @override
  Widget build(BuildContext context) {
    // Prepare all conversation rows
    List<Widget> messageWidgets = [];
    for (final conversation in widget.content.conversation) {
      String? iconPath;
      String messageNp = conversation.messageNp;
      final colonIdx = messageNp.indexOf(':');
      if (colonIdx != -1) {
        iconPath = conversation.icon;
        messageNp = messageNp.substring(colonIdx + 1).trimLeft();
      }
      final lines = messageNp.split('\n');
      for (var i = 0; i < lines.length; i++) {
        messageWidgets.add(
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (iconPath != null && iconPath.isNotEmpty && i == 0)
                SvgHelper.fromSource(
                  path: iconPath,
                  height: 28,
                  width: 28,
                  type: SvgSourceType.network,
                ),
              if (iconPath != null && iconPath.isNotEmpty && i == 0)
                Gaps.horizontalGapOf(12.0),
              Text(
                lines[i],
                textAlign: TextAlign.center,
                style: AppStyles.text20PxMedium.copyWith(fontFamily: 'Mukta'),
              ),
            ],
          ),
        );
      }
    }
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;
    final char1Width = 120.0;
    final char2Width = 120.0;
    final charPadding = 24.0;
    final sliderPadding = 32.0;
    final sliderWidth = screenWidth - sliderPadding * 2;
    final maxPosition = sliderWidth - char1Width - char2Width - charPadding;
    // Images: content.image = background, content.characters = [char1, char2]
    final bgImage = widget.content.image;
    final charList = widget.content.characters ?? [];
    final char1 = charList.isNotEmpty ? charList[0] : widget.content.image;
    final char2 = charList.length > 1 ? charList[1] : widget.content.image;

    void handleDrag(double dx) async {
      if (_completed) return;
      setState(() {
        _position += dx;
        if (_position < 0) _position = 0;
        if (_position > maxPosition) _position = maxPosition;
      });
      if (_position >= maxPosition && !_completed) {
        setState(() => _completed = true);
        await Future.delayed(const Duration(milliseconds: 600));
        if (mounted) storyProvider.nextContent();
      }
    }

    return Stack(
      children: [
        // Scrollable background
        Positioned.fill(
          child: CustomImage(
            bgImage,
            imageType: CustomImageType.network,
            boxFit: BoxFit.cover,
          ),
        ),
        // Character 2 (static, right side)
        Positioned(
          left: maxPosition + char1Width,
          bottom: 55,
          child: SvgHelper.fromSource(
            path: char2,
            height: 100,
            width: char2Width,
            type: SvgSourceType.network,
          ),
        ),
        // Character 1 (draggable)
        Positioned(
          left: sliderPadding + _position,
          bottom: 55,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              handleDrag(details.delta.dx);
            },
            child: SvgHelper.fromSource(
              path: char1,
              height: 100,
              width: char1Width,
              type: SvgSourceType.network,
            ),
          ),
        ),
        // Top center sound icon
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => storyProvider.playAudio(widget.content.audio),
              child: SvgHelper.fromSource(path: Assets.sound, height: 40),
            ),
          ),
        ),
        // Top right wrong icon
        Positioned(
          top: 24,
          right: 24,
          child: SvgHelper.fromSource(path: Assets.wrong, height: 36),
        ),
        // Left arrow (center vertically)
        Positioned(
          left: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => storyProvider.previousContent(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kBlack.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SvgHelper.fromSource(
                  path: Assets.leftArrow,
                  height: 35,
                  width: 35,
                ),
              ),
            ),
          ),
        ),
        // Right arrow (center vertically)
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => storyProvider.nextContent(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.kBlack.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: SvgHelper.fromSource(
                  path: Assets.rightArrow,
                  height: 35,
                  width: 35,
                ),
              ),
            ),
          ),
        ),
        // Bottom white background with text
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: messageWidgets,
            ),
          ),
        ),
      ],
    );
  }
}

// Button Tap UI
class _ButtonTapContent extends StatefulWidget {
  final Content content;
  const _ButtonTapContent({required this.content});
  @override
  State<_ButtonTapContent> createState() => _ButtonTapContentState();
}

class _ButtonTapContentState extends State<_ButtonTapContent> {
  int? selectedIdx;
  bool? isCorrect;
  bool showTryAgain = false;

  void _handleTap(int i, StoryProvider storyProvider) async {
    final opt = widget.content.conversation[i];
    final correct = opt.correct == true;
    setState(() {
      selectedIdx = i;
      isCorrect = correct;
      showTryAgain = !correct;
    });
    if (correct) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        storyProvider.nextContent();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.content.conversation;
    final storyProvider = Provider.of<StoryProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.content.image.isNotEmpty)
          Expanded(
            child: CustomImage(
              widget.content.image,
              imageType: CustomImageType.network,
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: const BoxDecoration(color: Colors.white),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: List.generate(options.length, (i) {
              final opt = options[i];
              final correct = opt.correct == true;
              final isSelected = selectedIdx == i;
              Color bgColor = AppColors.kButtonGrey;
              String label = opt.messageEn;
              dynamic icon;
              Color textColor = isSelected ? Colors.white : Colors.black;
              TextStyle? textStyle = AppStyles.text16PxBold.copyWith(
                color: textColor,
              );
              if (isSelected) {
                if (isCorrect == true && correct) {
                  bgColor = AppColors.kButtonGreen;
                  icon = Icons.check;
                  label = '';
                  textColor = Colors.white;
                  textStyle = AppStyles.text16PxBold.copyWith(
                    color: Colors.white,
                  );
                } else if (isCorrect == false && !correct) {
                  bgColor = AppColors.kRed;
                  label = 'Try Again';
                  textColor = Colors.white;
                  textStyle = AppStyles.text16PxBold.copyWith(
                    color: Colors.white,
                  );
                }
              }
              return CustomMaterialButton(
                backgroundColor: bgColor,
                showBorder: true,
                elevation: 0,
                radius: 60,
                textStyle: textStyle,
                width: 120,
                onTap: () {
                  if (isCorrect == true && correct) {
                    return;
                  }
                  _handleTap(i, storyProvider);
                },
                label: label,
                icon: icon,
                fillButton: isSelected,
              );
            }),
          ),
        ),
      ],
    );
  }
}

// Normal Confetti UI
class _NormalConfettiContent extends StatelessWidget {
  final Content content;
  final VoidCallback? onConfetti;
  final bool isLast;
  const _NormalConfettiContent({
    required this.content,
    this.onConfetti,
    required this.isLast,
  });
  @override
  Widget build(BuildContext context) {
    // For demo, just show a confetti icon if isLast or confetti is not empty
    final showConfetti = isLast || (content.confetti.isNotEmpty);
    return Stack(
      alignment: Alignment.center,
      children: [
        _NormalContent(content: content),
        if (showConfetti)
          LottieHelper.fromSource(
            path: content.confetti,
            repeat: true,
            type: LottieSourceType.network,
          ),
      ],
    );
  }
}
