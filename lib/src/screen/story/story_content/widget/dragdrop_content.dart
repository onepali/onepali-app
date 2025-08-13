// Drag & Drop UI
import 'package:flutter/material.dart';
import '../../../../src.dart';

class DragDropContent extends StatefulWidget {
  final Content content;
  final bool playAudio;
  const DragDropContent({
    super.key,
    required this.content,
    this.playAudio = true,
  });
  @override
  State<DragDropContent> createState() => DragDropContentState();
}

class DragDropContentState extends State<DragDropContent> {
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
                onTap: () async {
                  bool isGuest = GuestUtil.isGuestUser();
                  if (isGuest) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.dashboardScreen,
                      (route) => false,
                    );
                  }
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
                  height: 30.h(context),
                  width: 80.w(context),
                  type: SvgSourceType.network,
                ),
              if (char2 != null)
                SvgHelper.fromSource(
                  path: char2,
                  height: 30.h(context),
                  width: 80.w(context),
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
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(content: Text('Try Again!')),
                      // );
                    }
                  });
                },
                builder: (context, candidate, rejected) {
                  final isMatched = droppedOn.contains(i) && correct[i];
                  return Container(
                    width: 160,
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color:
                          isMatched ? AppColors.kButtonGreen : Colors.grey[300],
                      borderRadius: BorderRadius.circular(48),
                      border: Border.all(
                        color: AppColors.kWhite,
                        width: 6,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Center(
                      child:
                          isMatched
                              ? const Icon(
                                Icons.check,
                                color: AppColors.kWhite,
                                size: 40,
                              )
                              : Text(
                                conv[i].messageEn,
                                style: AppStyles.text16PxSemiBold.copyWith(
                                  // Larger text
                                  color: AppColors.kGrey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                    ),
                  );
                },
              );
            }),
          ),
          Gaps.verticalGapOf(15),
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
      width: 160,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: showTryAgain ? AppColors.kButtonRed : colors[i % colors.length],
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
          showTryAgain ? 'Try Again!' : label,
          style: AppStyles.text18PxSemiBold.copyWith(
            color: AppColors.kBlack,
            fontFamily: 'Mukta',
          ),
        ),
      ),
    );
  }
}
