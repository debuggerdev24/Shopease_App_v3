import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

/// for getting theme instance
extension ThemeExtensions on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  ThemeData get theme => Theme.of(this);
}

/// to show success and error snackbar
extension SnackBarExtension on BuildContext {
  showErrorMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
          content: Text(
            message,
            style: textStyle16SemiBold.copyWith(color: Colors.white),
          ),
          backgroundColor: Colors.red[900]),
    );
  }

  showSuccessMessage(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: textStyle16SemiBold.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
