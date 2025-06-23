import 'package:intl/intl.dart';

class DatetimeUtility {
  /// Get [Formatted] Date
  static String getFormattedDate(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) {
      return "N/A";
    }

    try {
      DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('dd MMMM, yyyy').format(dateTime);
    } catch (e) {
      return "N/A";
    }
  }
}
