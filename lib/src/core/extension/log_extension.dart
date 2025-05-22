import '../../src.dart';

extension LogLevelExtension on LogLevel {
  String get name => toString().split('.').last;

  String get color {
    switch (this) {
      case LogLevel.debug:
        return AppColors.blue;
      case LogLevel.info:
        return AppColors.cyan;
      case LogLevel.warning:
        return AppColors.yellow;
      case LogLevel.error:
        return AppColors.red;
      case LogLevel.success:
        return AppColors.green;
    }
  }
}
