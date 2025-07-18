import 'package:flutter/material.dart';

Future<DateTime?> showDefultDatePicker(BuildContext context) {
  return showDatePicker(
    context: context,
    firstDate: DateTime(0),
    lastDate: DateTime.now(),
    barrierDismissible: false,
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    // builder: (context, child) {
    //   return Theme(
    //     data: AppThemes.lightTheme.copyWith(
    //         colorScheme: const ColorScheme.light(
    //           primary: AppColors.primaryColor,
    //           // onPrimary: Colors.white,
    //           // surface: AppColors.primaryColor,
    //           // onSecondary: Colors.red,
    //           // background: Colors.redAccent,
    //           // onSurface: Colors.red,
    //           // inversePrimary: Colors.white,
    //           // inverseSurface: Colors.white,
    //           // onBackground: Colors.white,
    //           // onInverseSurface: Colors.white,
    //           // onPrimaryContainer: Colors.white,
    //           // onSecondaryContainer: Colors.white,
    //           // onSurfaceVariant: Colors.white,
    //           // onTertiary: Colors.white,
    //           // onTertiaryContainer: Colors.white,
    //           // primaryContainer: Colors.white,
    //           // secondary: Colors.amber,
    //           // secondaryContainer: Colors.white,
    //           // scrim: Colors.white,
    //           // surfaceTint: Colors.white,
    //           // surfaceVariant: Colors.white,
    //           // tertiaryContainer: Colors.white,
    //           // tertiary: Colors.white,
    //         ),
    //         dialogBackgroundColor: Colors.red),
    //     child: child!,
    //   );
    // },
  );
}
