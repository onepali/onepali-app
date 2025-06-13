import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../src.dart';

// Slide UI
class SlideContent extends StatefulWidget {
  final Content content;
  const SlideContent({super.key, required this.content});
  @override
  State<SlideContent> createState() => SlideContentState();
}

class SlideContentState extends State<SlideContent> {
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
        if (!context.mounted) return;
        if (mounted) storyProvider.nextContent(context);
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
              onTap: () => storyProvider.nextContent(context),
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
        // Slide action bar (background and arrow)
        Positioned(
          left: 32,
          right: 32,
          bottom: 70,
          child: IgnorePointer(
            child: AnimatedOpacity(
              opacity: _completed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  Positioned(
                    left: 12 + _position,
                    child: SvgHelper.fromSource(
                      path: Assets.scrollRightArrow,
                      height: 44,
                      width: 44,
                      type: SvgSourceType.asset,
                    ),
                  ),
                ],
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
