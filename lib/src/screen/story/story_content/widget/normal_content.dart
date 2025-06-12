import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../src.dart';

// Normal UI
class NormalContent extends StatelessWidget {
  final Content content;
  const NormalContent({super.key, required this.content});
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
        if (content.image.isNotEmpty)
          Positioned.fill(
            bottom: 50,
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
          child: customInkwell(
            onTap:
                () => Navigator.of(context).popUntil((route) => route.isFirst),
            child: SvgHelper.fromSource(path: Assets.wrong, height: 36),
          ),
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
              onTap: () => storyProvider.nextContent(context),
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
