import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _detailFormat = DateFormat('MM-dd-yyyy HH:mm');

  static String formatDetail(DateTime dateTime) =>
      _detailFormat.format(dateTime);

  static String formatCompact(DateTime dateTime) =>
      DateFormat.yMMMd().add_Hm().format(dateTime);
}
