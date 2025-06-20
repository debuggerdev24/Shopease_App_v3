import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/mobile_field.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MobileLoginscreen extends StatefulWidget {
  const MobileLoginscreen({super.key, required this.isEdit, this.nickName});
  final bool isEdit;
  final String? nickName;

  @override
  State<MobileLoginscreen> createState() => _MobileLoginscreenState();
}

class _MobileLoginscreenState extends State<MobileLoginscreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("value:${widget.isEdit}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.whiteColor),
      ),
      body: Consumer<AuthProvider>(builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your mobile number to get OTP',
                style: textStyle20SemiBold.copyWith(fontSize: 24),
              ),
              30.verticalSpace,
              MobileField(
                controller: _phoneController,
                onTextChanged: (value) {
                  setState(() {});
                },
              ),
              30.verticalSpace,
              AppButton(
                onPressed: !(_phoneController.text.length ==
                        provider.selectedCountry.example.length)
                    ? () {
                        CustomToast.showWarning(
                            context, 'Please enter valid mobile number');
                      }
                    : () async {
                        final String phone =
                            '+${provider.selectedCountry.phoneCode}${_phoneController.text}';
                        await provider.signUp(
                          phone: phone,
                          tempName: widget.nickName,
                          onSuccess: () {
                            CustomToast.showSuccess(
                                context, 'OTP sent successfully.');
                            context.pushNamed(
                              AppRoute.otpScreen.name,
                              extra: {'isEdit': false, 'mobile': phone},
                            );
                          },
                          onError: (msg) => CustomToast.showError(context, msg),
                        );
                      },
                text: 'Get OTP',
                isLoading: provider.isLoading,
                colorType: !(_phoneController.text.length ==
                        provider.selectedCountry.example.length)
                    ? AppButtonColorType.greyed
                    : AppButtonColorType.primary,
                // backgroundColor: AppColors.orangeColor,
              ),
              15.verticalSpace,
              if (_phoneController.text.length ==
                  provider.selectedCountry.example.length)
                _buildTosLine(),
              // GlobalText(
              //   'By clicking, I accept the terms of service and privacy policy',
              //   textStyle: textStyle14,
              // )
            ],
          ),
        );
      }),
    );
  }

  _buildTosLine() => RichText(
        text: TextSpan(
          text: 'By clicking, I\'m accept the ',
          style: textStyle14.copyWith(color: AppColors.blackColor),
          children: [
            TextSpan(
              text: 'terms of service',
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'privacy of policy',
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
          ],
        ),
      );
}
