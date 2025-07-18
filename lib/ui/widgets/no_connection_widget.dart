import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.noConnectionBG),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 1.25,
                child: Transform.translate(
                  offset: Offset(-40.w, -20),
                  child: SvgPicture.asset(
                    AppAssets.oops,
                    fit: BoxFit.contain,
                    
                  ),
                ),
              ),
              10.h.verticalSpace,
              Text(
                'No Internet Connection!',
                style: textStyle20SemiBold.copyWith(fontSize: 30),
              ),
              10.h.verticalSpace,
              Text(
                'Something went wrong. Try refreshing the page or checking your internet connection.',
                style: textStyle16.copyWith(fontSize: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
