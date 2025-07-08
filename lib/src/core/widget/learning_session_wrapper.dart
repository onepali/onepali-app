import 'package:flutter/material.dart';
import '../utils/metrics_tracking_helper.dart';

class LearningSessionLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    MetricsTrackingHelper.handleAppLifecycleChange(state);
  }
}

class LearningSessionWrapper extends StatefulWidget {
  final Widget child;

  const LearningSessionWrapper({super.key, required this.child});

  @override
  State<LearningSessionWrapper> createState() => _LearningSessionWrapperState();
}

class _LearningSessionWrapperState extends State<LearningSessionWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    MetricsTrackingHelper.handleAppLifecycleChange(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
