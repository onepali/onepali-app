import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

const double kWordPopupMobileFontSize = 56.0;
const double kWordPopupTabletFontSize = 72.0;

class LabelDisplay extends StatefulWidget {
  final String nameNp;
  final String nameEn;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final Alignment scaleAlignment;

  const LabelDisplay({
    super.key,
    required this.nameNp,
    required this.nameEn,
    this.mobileFontSize,
    this.tabletFontSize,
    this.scaleAlignment = Alignment.center,
  });

  const LabelDisplay.wordPopup({
    super.key,
    required this.nameNp,
    required this.nameEn,
  }) : mobileFontSize = kWordPopupMobileFontSize,
       tabletFontSize = kWordPopupTabletFontSize,
       scaleAlignment = Alignment.topCenter;

  @override
  State<LabelDisplay> createState() => _LabelDisplayState();
}

class _LabelDisplayState extends State<LabelDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    if (widget.nameNp.isEmpty) return const SizedBox.shrink();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Center(
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              alignment: widget.scaleAlignment,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16 : 32,
                  vertical: isMobile ? 6 : 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.kSecondaryColor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  widget.nameNp,
                  style: TextStyle(
                    fontSize: isMobile
                        ? widget.mobileFontSize ?? 32
                        : widget.tabletFontSize ?? 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: AppConstants.kMuktaFont,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
