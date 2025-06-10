import 'package:flutter/material.dart';
import 'package:onepali/src/src.dart';

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
  bool dropped = false;
  @override
  Widget build(BuildContext context) {
    // Example: Drag a button to a target
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (!dropped)
          Draggable<int>(
            data: 1,
            feedback: Material(color: Colors.transparent, child: _dragButton()),
            childWhenDragging: Opacity(opacity: 0.3, child: _dragButton()),
            child: _dragButton(),
          ),
        Gaps.verticalGapOf(32),
        DragTarget<int>(
          onAcceptWithDetails: (data) => setState(() => dropped = true),
          builder:
              (context, candidate, rejected) => Container(
                height: 80,
                width: 200,
                decoration: BoxDecoration(
                  color: dropped ? Colors.green[100] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                alignment: Alignment.center,
                child:
                    dropped
                        ? const Icon(Icons.check, color: Colors.green, size: 40)
                        : const Text(
                          'Drop here',
                          style: TextStyle(fontSize: 20),
                        ),
              ),
        ),
      ],
    );
  }

  Widget _dragButton() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(24),
    ),
    child: const Text(
      'Drag Me',
      style: TextStyle(color: Colors.white, fontSize: 20),
    ),
  );
}

// Normal UI
class _NormalContent extends StatelessWidget {
  final Content content;
  const _NormalContent({required this.content});
  @override
  Widget build(BuildContext context) {
    final conversation =
        content.conversation.isNotEmpty ? content.conversation.first : null;
    // Check if messageEn contains ':' and extract icon and message
    String? iconPath;
    String messageNp = conversation?.messageNp ?? '';
    if (conversation != null && conversation.messageEn.contains(':')) {
      iconPath = conversation.icon;
    }
    return Stack(
      children: [
        // Background image (full screen)
        if (content.image.isNotEmpty)
          Positioned.fill(
            child: CustomImage(
              content.image,
              imageType: CustomImageType.network,
            ),
          ),
        // Top center sound icon
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Center(
            child: SvgHelper.fromSource(path: Assets.sound, height: 40),
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
            child: SvgHelper.fromSource(path: Assets.leftArrow, height: 48),
          ),
        ),
        // Right arrow (center vertically)
        Positioned(
          right: 16,
          top: 0,
          bottom: 0,
          child: Center(
            child: SvgHelper.fromSource(path: Assets.rightArrow, height: 48),
          ),
        ),
        // Bottom white background with text
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (iconPath != null && iconPath.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: SvgHelper.fromSource(
                        path: iconPath,
                        height: 28,
                        width: 28,
                        type: SvgSourceType.network,
                      ),
                    ),
                  Gaps.horizontalGapOf(12),
                  Text(
                    messageNp,
                    textAlign: TextAlign.center,
                    style: AppStyles.text20PxMedium.copyWith(
                      fontFamily: 'Mukta',
                    ),
                  ),
                ],
              ),
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
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 120,
          width: double.infinity,
          color: Colors.green[100],
        ),
        Positioned(
          left: _position,
          child: GestureDetector(
            onHorizontalDragUpdate: (details) {
              setState(() {
                _position += details.delta.dx;
                _position = _position.clamp(
                  0.0,
                  MediaQuery.of(context).size.width - 100,
                );
              });
            },
            child: Image.asset(widget.content.image, height: 100),
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
  @override
  Widget build(BuildContext context) {
    final options = widget.content.conversation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.content.image.isNotEmpty)
          Image.asset(widget.content.image, height: 120),
        Gaps.verticalGapOf(24),
        Wrap(
          spacing: 16,
          children: List.generate(options.length, (i) {
            final opt = options[i];
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedIdx == i
                        ? (isCorrect == true ? Colors.green : Colors.red)
                        : Colors.grey[200],
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  selectedIdx = i;
                  isCorrect = opt.id == 'right';
                });
              },
              child: Text(opt.messageNp, style: const TextStyle(fontSize: 18)),
            );
          }),
        ),
        if (isCorrect == false)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Try again!',
              style: TextStyle(color: Colors.red[700], fontSize: 18),
            ),
          ),
        if (isCorrect == true)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              'Correct!',
              style: TextStyle(color: Colors.green[700], fontSize: 18),
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
          Positioned(
            top: 40,
            child: Icon(Icons.celebration, color: Colors.pink[300], size: 80),
          ),
      ],
    );
  }
}
