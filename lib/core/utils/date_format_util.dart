import 'package:intl/intl.dart';

abstract class DateFormatUtil {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy').format(date);
  }
}
