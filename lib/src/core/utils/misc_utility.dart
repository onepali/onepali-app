import 'dart:async';

import 'package:flutter/material.dart';

abstract class Misc {
  /// Execute the callback when the layout is rendered.
  static void onLayoutRendered(void Function() callback) {
    WidgetsBinding.instance.addPostFrameCallback((d) => callback());
  }

  static Future<void> delayed(
    int milliseconds,
    void Function() callback,
  ) async {
    await Future.delayed(
      Duration(milliseconds: milliseconds),
      () => callback(),
    );
  }
}
