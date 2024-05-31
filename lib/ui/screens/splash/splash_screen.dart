import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/shared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).textTheme.headlineMedium?.color
            : Colors.black,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Container(
          color: AppColors.whiteColor,
          child: Center(
            child: Container(
              height: 50.h,
              width: 250.h,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppAssets.appLogo))),
              // child: Image.asset(AppAssets.appLogo)
            ),
          ),
        ),
        floatingActionButton: const Text(
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontFamily: 'OpenSansRegular',
            ),
            "Ver 1.0"),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  startTimer() {
    var duration = const Duration(milliseconds: 2000);

    return Future.delayed(
      duration,
      () {
        // context.goNamed(AppRoute.createPostScreen.name, extra: PostType.blog);
        if (SharedPrefs().idToken == null) {
          context.goNamed(AppRoute.onBoardScreen.name);
        } else {
          context.goNamed(AppRoute.home.name);
        }
      },
    );
  }
}
