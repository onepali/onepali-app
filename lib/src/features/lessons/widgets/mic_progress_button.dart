import 'package:flutter/material.dart';
import 'package:onepali/src/core/core.dart';

class MicProgressButton extends StatefulWidget {
  final int recordingDuration;

  final bool isActive;

  final bool isCompleted;
  final VoidCallback? onCompletedTap;

  const MicProgressButton({
    super.key,
    required this.recordingDuration,
    required this.isActive,
    required this.isCompleted,
    this.onCompletedTap,
  });

  @override
  State<MicProgressButton> createState() => _MicProgressButtonState();
}

class _MicProgressButtonState extends State<MicProgressButton>
    with TickerProviderStateMixin {
  late AnimationController _fillController;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _fillController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.recordingDuration),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isActive) _startAnimations();
  }

  void _startAnimations() {
    _fillController.forward(from: _fillController.value);
    _pulseController.repeat(reverse: true);
  }

  void _stopAnimations() {
    _fillController.stop();
    _pulseController.stop();
    _pulseController.value = 0;
  }

  @override
  void didUpdateWidget(MicProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Recording duration changed — reset controller duration.
    if (widget.recordingDuration != oldWidget.recordingDuration) {
      _fillController.duration = Duration(seconds: widget.recordingDuration);
    }

    if (widget.isActive && !oldWidget.isActive) {
      _fillController.value = 0;
      _startAnimations();
    } else if (!widget.isActive && oldWidget.isActive) {
      _stopAnimations();
    }

    if (widget.isCompleted && !oldWidget.isCompleted) {
      _fillController.value = 1.0;
      _pulseController.stop();
      _pulseController.value = 0;
    }
    if (!widget.isActive &&
        !widget.isCompleted &&
        (oldWidget.isActive || oldWidget.isCompleted)) {
      _fillController.value = 0;
    }
  }

  @override
  void dispose() {
    _fillController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return GestureDetector(
      onTap: widget.isCompleted ? widget.onCompletedTap : null,
      child: SizedBox(
        width: isMobile ? 180 : 280,
        height: isMobile ? 50 : 88,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Background pill
            Container(
              decoration: BoxDecoration(
                color: AppColors.kButtonGrey,
                borderRadius: BorderRadius.circular(50),
              ),
            ),

            // ── Smooth progress fill
            AnimatedBuilder(
              animation: _fillController,
              builder: (context, _) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: _fillController.value.clamp(0.0, 1.0),
                      child: Container(
                        height: isMobile ? 50 : 88,
                        decoration: BoxDecoration(
                          color: widget.isCompleted
                              ? AppColors.kButtonGreen
                              : AppColors.kPureSkyBlue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // ── Mic / check icon with pulse
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) => Transform.scale(
                scale: widget.isActive ? _pulseAnimation.value : 1.0,
                child: child,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  widget.isCompleted ? Icons.check_rounded : Icons.mic_rounded,
                  key: ValueKey(widget.isCompleted),
                  size: isMobile ? 40 : 65,
                  color: widget.isCompleted ? null : AppColors.kWhite,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
