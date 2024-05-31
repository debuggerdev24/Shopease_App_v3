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
    appBarTheme: AppBarTheme(color: AppColors.whiteColor),
    dialogTheme: DialogTheme(
      backgroundColor: AppColors.whiteColor,
    ),
  );

  ///DARKTHEME

  static final darkTheme = ThemeData(
    fontFamily: 'Figtree',
    primaryColor: AppColors.orangeColor,
    appBarTheme: AppBarTheme(color: AppColors.whiteColor),
    dialogTheme: DialogTheme(backgroundColor: AppColors.blackGreyColor),
  );
}
