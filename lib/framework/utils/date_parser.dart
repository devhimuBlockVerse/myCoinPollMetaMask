import 'package:intl/intl.dart';

// DateTime parseDate(String dateStr) {
//   return DateFormat('MMMM d, yyyy').parse(dateStr);
// }

class DateParser {
  static DateTime fromReadableFormat(String dateStr) {
    return DateFormat('MMMM d, yyyy').parse(dateStr);
  }
}