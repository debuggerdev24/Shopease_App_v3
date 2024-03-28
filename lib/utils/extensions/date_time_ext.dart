import 'package:intl/intl.dart';

extension DateTimeToString on DateTime {
  String get toDDMonthYYYY {
    final formatter = DateFormat('dd MMM yyyy', 'en_US');
    return formatter.format(this);
  }
}
