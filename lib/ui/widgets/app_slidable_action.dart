import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AppSlidableaction extends StatelessWidget {
  const AppSlidableaction(
      {super.key,
      required this.icon,
      this.labelText,
      this.onTap,
      this.backgroundColor,
      this.forgroundColor,
      this.isRight = false,
      this.height});

  final String icon;
  final String? labelText;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? forgroundColor;
  final bool isRight;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.fromLTRB(
              isRight ? 5.w : 0, 10.h, isRight ? 0 : 5.w, 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.lightGreyColor.withAlpha(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: height,
                theme: SvgTheme(
                    currentColor: forgroundColor ?? AppColors.blackColor),
              ),
              if (labelText != null) ...[
                10.verticalSpace,
                Text(labelText!, style: textStyle16)
              ]
            ],
          ),
        ),
      ),
    );
  }
}
