import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:onepali/src/src.dart';

class AchievementCard extends StatelessWidget {
  final AchievementModel achievement;
  final String value;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = PlatformUtility.isMobile(context);
    return isMobile
        ? MobileCard(achievement: achievement, value: value)
        : TabletCard(achievement: achievement, value: value);
  }
}

/// Animates an integer value smoothly from the previous value to the new
/// one, similar to a flip-clock / odometer effect. Falls back to plain
/// text rendering when the value is not parseable as an integer.
class _AnimatedCounter extends StatelessWidget {
  final String value;
  final TextStyle? style;

  const _AnimatedCounter({required this.value, this.style});

  @override
  Widget build(BuildContext context) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      return Text(value, style: style);
    }
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: parsed),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeOutCubic,
      builder: (_, animatedValue, __) {
        return Text(
          animatedValue.toString(),
          style: style,
        ).animate(key: ValueKey('counter_$parsed')).scaleXY(
              begin: 0.85,
              end: 1.0,
              duration: 300.ms,
              curve: Curves.easeOutBack,
            );
      },
    );
  }
}

class MobileCard extends StatelessWidget {
  final AchievementModel achievement;
  final String value;
  const MobileCard({super.key, required this.achievement, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: achievement.color ?? AppColors.kButtonGreen,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color:
                achievement.color?.withValues(alpha: 0.5) ??
                AppColors.kButtonGreen.withValues(alpha: 0.5),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AnimatedCounter(value: value, style: AppStyles.text40PxMedium),
          Text(
            achievement.subtitle,
            style: AppStyles.text16PxRegular,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Expanded(
            child: Image.asset(achievement.imageUrl)
                .animate()
                .scaleXY(
                  begin: 0.6,
                  end: 1.0,
                  duration: 600.ms,
                  delay: 200.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 400.ms, delay: 200.ms),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Text(
            achievement.title,
            textAlign: TextAlign.center,
            style: AppStyles.text18PxMedium,
          ),
        ],
      ),
    );
  }
}

class TabletCard extends StatelessWidget {
  final AchievementModel achievement;
  final String value;
  const TabletCard({super.key, required this.achievement, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: achievement.color ?? AppColors.kButtonGreen,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color:
                achievement.color?.withValues(alpha: 0.5) ??
                AppColors.kButtonGreen.withValues(alpha: 0.5),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      margin: const EdgeInsets.only(right: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Count
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _AnimatedCounter(
                  value: achievement.value,
                  style: AppStyles.text40PxMedium,
                ),
                // Subtitle
                Text(
                  achievement.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyles.text24PxMedium,
                ),
                SizedBox(height: 24),
              ],
            ),
          ),
          // Emoji
          Expanded(
            flex: 3,
            child: Image.asset(achievement.imageUrl)
                .animate()
                .scaleXY(
                  begin: 0.6,
                  end: 1.0,
                  duration: 600.ms,
                  delay: 250.ms,
                  curve: Curves.easeOutBack,
                )
                .fadeIn(duration: 400.ms, delay: 250.ms),
          ),
          // Label
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(height: 24),
                // Label
                Text(
                  achievement.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppStyles.text24PxBold,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
