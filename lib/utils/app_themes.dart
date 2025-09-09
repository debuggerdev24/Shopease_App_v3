// Delete this file if your app dosen't provide a functionality for changing
// themes.

import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppThemes {
  static final lightTheme = ThemeData(
    fontFamily: 'Figtree',
    primaryColor: AppColors.orangeColor,
    // backgroundColor: AppColors.whiteColor,
    dialogBackgroundColor: AppColors.whiteColor,
    appBarTheme: const AppBarTheme(color: AppColors.whiteColor),
    dialogTheme: const DialogThemeData(
      backgroundColor: AppColors.whiteColor,
    ),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
  );

  ///DARKTHEME

  static final darkTheme = ThemeData(
    fontFamily: 'Figtree',
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(),
    primaryColor: AppColors.orangeColor,
    appBarTheme: const AppBarTheme(color: AppColors.whiteColor),
    dialogTheme:
        const DialogThemeData(backgroundColor: AppColors.blackGreyColor),
    progressIndicatorTheme:
        const ProgressIndicatorThemeData(color: AppColors.primaryColor),
  );
}
