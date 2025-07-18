import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ThemeModeExt on String {
  ThemeMode get toTheme => switch (this) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        'system' => ThemeMode.system,
        _ => throw Exception('not a valid theme type: $this'),
      };

  DateTime get mmddYYYYToDate {
    final formate = DateFormat('MM/dd/yyyy', 'en_US');
    return formate.parse(this);
  }
}
