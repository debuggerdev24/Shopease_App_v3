import 'package:intl/intl.dart';

extension DateTimeToString on DateTime {
  String get toDDMonthYYYY {
    final formatter = DateFormat('dd MMM yyyy', 'en_US');
    return formatter.format(this);
  }

  String get toDDMMYY {
    final formatter = DateFormat('dd/MM/yyyy', 'en_US');
    return formatter.format(this);
  }

  String get toMonthDD {
    final formatter = DateFormat('MMM dd', 'en_US');
    return formatter.format(this);
  }
}
