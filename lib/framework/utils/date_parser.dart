import 'package:intl/intl.dart';


class DateParser {
  static DateTime fromReadableFormat(String dateStr) {
    return DateFormat('MMMM d, yyyy').parse(dateStr);
  }
}