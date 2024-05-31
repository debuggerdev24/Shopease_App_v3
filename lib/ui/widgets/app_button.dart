import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

enum AppButtonWidthType { full, half }

enum AppButtonColorType { primary, secondary, greyed }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.type = AppButtonWidthType.full,
    this.colorType = AppButtonColorType.primary,
    this.isLoading = false,
    this.elevation,
    this.radius = 16,
    this.icon,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppButtonWidthType? type;
  final AppButtonColorType? colorType;
  final bool? isLoading;
  final double? radius;
  final double? elevation;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.whiteColor,
        disabledForegroundColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
          side: BorderSide(
            color: colorType == AppButtonColorType.greyed
                ? AppColors.lightGreyColor.withOpacity(0.7)
                : colorType == AppButtonColorType.secondary
                    ? AppColors.orangeColor
                    : Colors.transparent,
            width: 1.0,
          ),
        ),
        backgroundColor: backgroundColor ??
            (colorType == AppButtonColorType.primary
                ? AppColors.orangeColor
                : AppColors.whiteColor),
        foregroundColor: foregroundColor ??
            (colorType == AppButtonColorType.greyed
                ? AppColors.lightGreyColor
                : colorType == AppButtonColorType.primary
                    ? AppColors.whiteColor
                    : AppColors.orangeColor),
        fixedSize: type == AppButtonWidthType.full
            ? Size(343.w, 56.h)
            : Size(164.w, 56.h),
      ),
      icon: isLoading ?? false ? Container() : icon ?? Container(),
      label: isLoading ?? false
          ? SizedBox(
              height: 25.h,
              width: 25.w,
              child: CircularProgressIndicator(
                strokeWidth: 3.r,
                color: foregroundColor ??
                    (colorType == AppButtonColorType.greyed
                        ? AppColors.lightGreyColor
                        : colorType == AppButtonColorType.primary
                            ? AppColors.whiteColor
                            : AppColors.orangeColor),
              ),
            )
          : Text(text, style: textStyle16,),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.foregroundColor,
    this.type = AppButtonWidthType.full,
    this.colorType = AppButtonColorType.primary,
    this.isLoading = false,
    this.elevation,
    this.radius = 16,
    this.icon,
    this.textStyle,
  });

  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final AppButtonWidthType? type;
  final AppButtonColorType? colorType;
  final bool? isLoading;
  final double? radius;
  final double? elevation;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        disabledBackgroundColor: AppColors.whiteColor,
        disabledForegroundColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
          side: const BorderSide(color: AppColors.redColor, width: 1.0),
        ),
        backgroundColor: backgroundColor ??
            (colorType == AppButtonColorType.primary
                ? AppColors.orangeColor
                : AppColors.whiteColor),
        foregroundColor: foregroundColor ??
            (colorType == AppButtonColorType.greyed
                ? AppColors.lightGreyColor
                : colorType == AppButtonColorType.primary
                    ? AppColors.whiteColor
                    : AppColors.orangeColor),
        fixedSize: type == AppButtonWidthType.full
            ? Size(343.w, 56.h)
            : Size(164.w, 56.h),
      ),
      icon: isLoading ?? false ? Container() : icon ?? Container(),
      label: isLoading ?? false
          ? SizedBox(
              height: 25.h,
              width: 25.w,
              child: CircularProgressIndicator(
                strokeWidth: 3.r,
              ),
            )
          : Text(
              text,
              style: textStyle16.copyWith(fontWeight: FontWeight.w500),
            ),
    );
  }
}
