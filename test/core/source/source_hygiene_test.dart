import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const _textFileExtensions = {
  '.dart',
  '.gradle',
  '.json',
  '.kts',
  '.md',
  '.properties',
  '.swift',
  '.yaml',
  '.yml',
};

void main() {
  test('tracked text source files do not contain NUL bytes', () {
    final gitResult = Process.runSync('git', [
      'ls-files',
    ], stdoutEncoding: utf8);

    expect(gitResult.exitCode, 0, reason: gitResult.stderr.toString());

    final files = LineSplitter.split(
      gitResult.stdout as String,
    ).where(_isTrackedTextFile).toList();
    final offenders = <String>[];

    for (final path in files) {
      if (File(path).readAsBytesSync().contains(0)) {
        offenders.add(path);
      }
    }

    expect(files, isNotEmpty);
    expect(
      offenders,
      isEmpty,
      reason: 'NUL bytes make GitHub treat source files as binary.',
    );
  });
}

bool _isTrackedTextFile(String path) {
  return _textFileExtensions.any(path.endsWith);
}
