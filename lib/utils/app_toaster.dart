// To show the tost messages

import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/extensions/context_ext.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppToaster {
  AppToaster._();

  static final AppToaster _instance = AppToaster._();

  factory AppToaster() => _instance;

  noInternetToast(BuildContext context) {
    Fluttertoast.showToast(
        msg: "No internet connection.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  showToast(
    String message, {
    Color? backgroundColor,
  }) {
    Fluttertoast.showToast(
        msg: message.toString(),
        backgroundColor: backgroundColor ?? AppColors.orangeColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: AppColors.whiteColor,
        fontSize: 16.0);
  }

  showThemedToast(
    BuildContext context,
    String message, {
    Color? backgroundColor,
  }) {
    Fluttertoast.showToast(
        msg: message.toString(),
        backgroundColor:
            context.isDark ? AppColors.whiteColor : AppColors.orangeColor,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor:
            !context.isDark ? AppColors.whiteColor : AppColors.orangeColor,
        fontSize: 16.0);
  }
}
