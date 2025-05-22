import 'dart:developer' as developer;
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:stack_trace/stack_trace.dart';
import '../../src.dart';

class Logger {
  final bool isProd;

  // Singleton pattern for global access
  static final Logger _instance = Logger._internal(false);

  factory Logger() {
    return _instance;
  }

  Logger._internal(this.isProd);

  // Core log method
  void _log(String message, LogLevel level, {String? file, String? method}) {
    final now = DateTime.now();

    // Format log message
    final formattedMessage =
        '${level.color}${now.toIso8601String()} '
        '[${level.name}] ${file ?? 'unknown'}.${method ?? 'unknown'}: $message\x1B[0m';

    if (isProd) {
      // Log to file (for production use)
      _logToFile(formattedMessage);
    } else {
      // Log to console or developer output
      developer.log(formattedMessage);
    }
  }

  // Log to file
  void _logToFile(String message) {
    final logFile = File('app.log');
    logFile.writeAsStringSync('$message\n', mode: FileMode.append, flush: true);
  }

  // Get the caller info (file and method name) for better traceability
  Map<String, String?> _getCallerInfo() {
    final frames = Trace.current(3).frames;
    if (frames.isNotEmpty) {
      final frame = frames[0];
      return {
        'file': frame.uri.toString().split('/').last,
        'method': frame.member,
      };
    }
    return {'file': null, 'method': null};
  }

  // Public logging methods
  void d(String message) {
    final caller = _getCallerInfo();
    _log(
      message,
      LogLevel.debug,
      file: caller['file'],
      method: caller['method'],
    );
  }

  void i(String message) {
    final caller = _getCallerInfo();
    _log(
      message,
      LogLevel.info,
      file: caller['file'],
      method: caller['method'],
    );
  }

  void w(String message) {
    final caller = _getCallerInfo();
    _log(
      message,
      LogLevel.warning,
      file: caller['file'],
      method: caller['method'],
    );
  }

  void e(String message) {
    final caller = _getCallerInfo();
    _log(
      message,
      LogLevel.error,
      file: caller['file'],
      method: caller['method'],
    );
  }

  void s(String message) {
    final caller = _getCallerInfo();
    _log(
      message,
      LogLevel.success,
      file: caller['file'],
      method: caller['method'],
    );
  }
}

// Global logger instance
final logger = Logger();
