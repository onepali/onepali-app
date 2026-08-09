import 'dart:async';

import 'package:flutter/widgets.dart';

mixin AutoAdvanceMixin<T extends StatefulWidget> on State<T> {
  Timer? _autoAdvanceTimer;
  bool _autoAdvanceConsumed = false;

  @protected
  void scheduleAutoAdvance(
    Duration delay,
    FutureOr<void> Function() onAdvance,
  ) {
    if (_autoAdvanceConsumed || _autoAdvanceTimer != null) return;
    _autoAdvanceTimer = Timer(delay, () {
      _autoAdvanceTimer = null;
      _autoAdvanceConsumed = true;
      if (!mounted) return;
      unawaited(Future<void>.sync(onAdvance));
    });
  }

  @protected
  void resetAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    _autoAdvanceConsumed = false;
  }

  @protected
  void cancelPendingAutoAdvance() {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    _autoAdvanceConsumed = true;
  }

  @protected
  Widget cancelAutoAdvanceOnPointerDown({
    required Widget child,
    bool enabled = true,
  }) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: enabled ? (_) => cancelPendingAutoAdvance() : null,
      child: child,
    );
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }
}
