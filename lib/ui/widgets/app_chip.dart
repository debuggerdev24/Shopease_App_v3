import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.text,
    this.backgroundColor,
    this.isSelected = false,
  });

  final String text;
  final Color? backgroundColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      stepWidth: text.isEmpty ? 100 : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (isSelected) ...[
              SvgIcon(
                AppAssets.check,
                color: AppColors.primaryColor,
                size: 10.h,
              ),
              10.horizontalSpace,
            ],
            Text(
              text,
              style: textStyle14.copyWith(
                  color: AppColors.primaryColor,
                  overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
