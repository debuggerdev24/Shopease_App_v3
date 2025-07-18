import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

import '../../../utils/routes/routes.dart';

class CongaratulationsScreen extends StatefulWidget {
  const CongaratulationsScreen({super.key});

  @override
  State<CongaratulationsScreen> createState() => _CongaratulationsScreenState();
}

class _CongaratulationsScreenState extends State<CongaratulationsScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ElasticInRight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(AppAssets.addInventory)),
                ),
              ),
              30.verticalSpace,
              Text(
                'Congratulations!',
                style: textStyle20SemiBold.copyWith(
                    fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
              5.h.verticalSpace,
              Text(
                'You have successfully logged in.',
                style: textStyle16.copyWith(
                    color: AppColors.mediumGreyColor, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      )),
    );
  }

  startTimer() {
    var duration = const Duration(milliseconds: 1500);
    return Future.delayed(duration, () {
      context.goNamed(AppRoute.home.name);
    });
  }
}
