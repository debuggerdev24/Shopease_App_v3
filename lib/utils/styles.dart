import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

final appBarTitleStyle = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontWeight: FontWeight.bold,
  fontSize: 17.sp,
);
final textStyle16SemiBold = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontWeight: FontWeight.w800,
  fontSize: 16.sp,
);
final textStyle16Bold = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontWeight: FontWeight.bold,
  fontSize: 16.sp,
);
final textStyle16 = TextStyle(
    fontFamily: 'AbhayaLibre', fontSize: 19.sp, fontWeight: FontWeight.w800);
final textStyle14 = TextStyle(
    fontFamily: 'AbhayaLibre', fontSize: 14.sp, fontWeight: FontWeight.w800);

final textStyle14SemiBold = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontSize: 14.sp,
  fontWeight: FontWeight.w800,
);

final textStyle12 = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontSize: 15.sp,
);

final textStyle18SemiBold = TextStyle(
    fontFamily: 'AbhayaLibre', fontSize: 23.sp, fontWeight: FontWeight.w800);

final textStyle20SemiBold = TextStyle(
  fontFamily: 'AbhayaLibre',
  fontSize: 20.sp,
  fontWeight: FontWeight.w800,
);

final primaryTextButtonTheme = TextButton.styleFrom(
  backgroundColor: AppColors.orangeColor,
  foregroundColor: Colors.white,
  // fixedSize: Size(ScreenUtil().screenWidth, 48.h),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  textStyle: TextStyle(
    fontFamily: 'AbhayaLibre',
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
  ),
);
final primaryElevatedButtonTheme = ElevatedButton.styleFrom(
  // elevation: 0,
  backgroundColor: AppColors.orangeColor,
  foregroundColor: Colors.white,
  fixedSize: Size(ScreenUtil().screenWidth, 48.h),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
  textStyle: TextStyle(
    fontFamily: 'AbhayaLibre',
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  ),
);
