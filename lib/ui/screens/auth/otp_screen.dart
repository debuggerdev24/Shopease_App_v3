import 'dart:async';
import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:time_remaining/time_remaining.dart';
import 'package:workmanager/workmanager.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.isEdit, required this.mobile});
  final bool isEdit;
  final String mobile;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  late Timer _resendOTPTimer;
  bool _showResendOTPText = false;

  @override
  void initState() {
    super.initState();
    startResendOTPTimer();
  }

  void startResendOTPTimer() {
    _resendOTPTimer =
        Timer.periodic(const Duration(seconds: 60), (Timer timer) {});
  }

  void resendOTP() {
    startResendOTPTimer();
  }

  @override
  void dispose() {
    _resendOTPTimer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("value${widget.isEdit}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the OTP sent to ${widget.mobile} ',
                style: textStyle20SemiBold.copyWith(fontSize: 24),
              ),
              25.verticalSpace,
              _buildOtpInput(),
              30.verticalSpace,
              AppButton(
                onPressed: () async {
                  if (_otpController.text.isNotEmpty) {
                    provider.confirmSignUp(
                        phone: widget.mobile,
                        otp: _otpController.text,
                        onSuccess: () {
                          widget.isEdit
                              ? context.goNamed(AppRoute.profile.name)
                              : context.pushNamed(
                                  AppRoute.congratulationsScreen.name);
                          CustomToast.showSuccess(
                            context,
                            widget.isEdit
                                ? 'Phone number changed'
                                : 'Loggeed in successfully.',
                          );
                        },
                        onError: (msg) {
                          CustomToast.showError(context, msg);
                        });
                  } else {
                    CustomToast.showWarning(context, 'Please Enter valid OTP.');
                  }
                },
                text: 'Continue',
                isLoading: provider.isLoading,
                colorType: (_otpController.text.length != 6)
                    ? AppButtonColorType.greyed
                    : AppButtonColorType.primary,
              ),
              20.verticalSpace,
              // if (provider.needToResendOTP) _buildRetryLine(context),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOtpInput() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Pinput(
          length: 6,
          onChanged: (value) {
            setState(() {});
          },
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          controller: _otpController,
          focusedPinTheme: PinTheme(
            height: 50.sp,
            width: 85.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.orangeColor))),
          ),
          defaultPinTheme: PinTheme(
            height: 50.sp,
            width: 85.sp,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.h),
                border: const Border.fromBorderSide(
                    BorderSide(color: AppColors.greyColor))),
          ),
        ),
        5.h.verticalSpace,
        // if (_otpController.text.isEmpty)
        if (!context.read<AuthProvider>().needToResendOTP)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Time Remaining: ',
                style: textStyle14,
              ),
              TimeRemaining(
                formatter: (duration) {
                  final minutes = duration.inMinutes
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');
                  final seconds = duration.inSeconds
                      .remainder(60)
                      .toString()
                      .padLeft(2, '0');
                  return '$minutes:$seconds ';

                  // Custom format
                },
                duration: const Duration(seconds: 15),
                style: textStyle12,
                onTimeOver: () {
                  context.read<AuthProvider>().setNeedToResendOTP(true);
                },
              )
            ],
          ),

        if (context.read<AuthProvider>().needToResendOTP)
          GestureDetector(
            onTap: () {
              resendOTP();
              context.read<AuthProvider>().signUp(
                  phone: widget.mobile,
                  onSuccess: () {
                    CustomToast.showSuccess(context, 'OTP sent successfully.');
                  });
            },
            child: GlobalText(
              color: AppColors.orangeColor,
              'Resend OTP',
              textStyle: textStyle14.copyWith(
                decoration: TextDecoration.underline,
                decorationColor: AppColors.orangeColor,
                color: AppColors.orangeColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRetryLine(BuildContext context) {
    return RichText(
      text: TextSpan(
          children: [
            TextSpan(
                text: 'Didn\'t recieve it? ',
                style: textStyle14.copyWith(color: AppColors.blackGreyColor)),
            TextSpan(
              text: 'Retry',
              style: textStyle16.copyWith(color: AppColors.blackGreyColor),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
          style: textStyle16.copyWith(
            color: AppColors.orangeColor,
          )),
    );
  }
}
