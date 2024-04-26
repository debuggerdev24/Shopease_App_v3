import 'package:flutter/material.dart';


class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.onTap,
    required this.child,
    this.isPrimary = false,
    this.backgroundColor,
    this.foregroundColor,

  });

  final VoidCallback? onTap;
  final Widget child;
  final bool isPrimary;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        // foregroundColor: foregroundColor ??
        //     (colorType == AppButtonColorType.primary
        //         ? AppColors.whiteColor
        //         : AppColors.blackColor),
        // backgroundColor: backgroundColor ?? AppColors.scaffoldBG,
      ),
      icon: child,
    );
  }
}
