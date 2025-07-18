import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:toastification/toastification.dart';

class CustomToast {
  static void showWarning(BuildContext context, String message) {
    toastification.show(
      backgroundColor: AppColors.lightYellowColor,
      context: context,
      icon: SvgPicture.asset(AppAssets.errorToast),
      closeButtonShowType: CloseButtonShowType.always,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      showProgressBar: false,
      title: Text(
        message,
        style: textStyle14,
      ),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }

  static void showError(BuildContext context, String message) {
    toastification.show(
        backgroundColor: AppColors.redColor,
        context: context,
        icon: SvgPicture.asset(
          AppAssets.errorToast,
          color: AppColors.whiteColor,
        ),
        closeButtonShowType: CloseButtonShowType.always,
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
        showProgressBar: false,
        title: Text(
          message,
          style: textStyle14.copyWith(color: AppColors.whiteColor),
        ),
        autoCloseDuration: const Duration(seconds: 4),
        primaryColor: Colors.white);
  }

  static void showSuccess(BuildContext context, String message) {
    toastification.show(
      backgroundColor: AppColors.lightGreenColor,
      icon: SvgIcon(
        AppAssets.toastCheck,
        color: AppColors.greenColor,
        size: 25.sp,
      ),
      closeButtonShowType: CloseButtonShowType.always,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      margin: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
      showProgressBar: false,
      context: context,
      title: Text(
        message,
        style: textStyle14,
      ),
      autoCloseDuration: const Duration(seconds: 4),
    );
  }
}
