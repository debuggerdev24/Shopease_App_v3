import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MobileLoginscreen extends StatefulWidget {
  const MobileLoginscreen({super.key, required this.isEdit});
  final bool isEdit;

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
        iconTheme: IconThemeData(color: AppColors.whiteColor),
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
              _buildMobileField(provider),
              30.verticalSpace,
              AppButton(
                onPressed: !(_phoneController.text.length ==
                        provider.selectedCountry.example.length)
                    ? () {
                        CustomToast.showWarning(
                            context, 'Please enter valid mobile number');
                      }
                    : () {
                        context.pushNamed(AppRoute.otpScreen.name, extra: {
                          'isEdit': widget.isEdit,
                          'mobile': _phoneController.text,
                        });
                      },
                text: 'Get OTP',
                isLoading: false,
                colorType: !(_phoneController.text.length ==
                        provider.selectedCountry.example.length)
                    ? AppButtonColorType.greyed
                    : AppButtonColorType.primary,
                // backgroundColor: AppColors.orangeColor,
              ),
              15.verticalSpace,
              if (_phoneController.text.length ==
                  provider.selectedCountry.example.length)
                // _buildTosLine(),
                GlobalText(
                  'By clicking, I accept the terms of service and privacy policy',
                  textStyle: textStyle14,
                )
            ],
          ),
        );
      }),
    );
  }

  _buildMobileField(AuthProvider provider) => AppTextField(
        name: 'Mobile Number',
        labelStyle: textStyle14,
        onChanged: (value) {
          setState(() {});
        },
        controller: _phoneController,
        labelText: 'Mobile Number',
        suffix: _phoneController.text.length ==
                provider.selectedCountry.example.length
            ? const SvgIcon(
                AppAssets.tickMark,
              )
            : null,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'please enter phone number';
          }
          if (provider.selectedCountry.example.length != value.length) {
            return "please enter correct phone number";
          }
          return null;
        },
        maxLength: provider.selectedCountry.example.length,
        prefixIcon: InkWell(
          onTap: () {
            showCountryPicker(
              context: context,
              countryListTheme: const CountryListThemeData(
                bottomSheetHeight: 500,
              ),
              onSelect: provider.setSelectedCountry,
            );
          },
          child: _buildTextFieldPrefix(provider),
        ),
      );

  _buildTextFieldPrefix(AuthProvider provider) => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '+${provider.selectedCountry.phoneCode}',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
            const Icon(Icons.arrow_drop_down),
            Container(
              width: 1,
              height: 40.h,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: AppColors.greyColor,
            ),
          ],
        ),
      );

  _buildTosLine() => RichText(
        text: TextSpan(
            children: [
              TextSpan(
                  text: 'By clicking, I\'m accept the ',
                  style: TextStyle(
                      color: AppColors.blackGreyColor, fontSize: 14.sp)),
              TextSpan(
                text: 'terms of service',
                style: textStyle16Bold,
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
              const TextSpan(text: ' and '),
              TextSpan(
                text: 'privacy of policy',
                style: textStyle16Bold,
                recognizer: TapGestureRecognizer()..onTap = () {},
              ),
            ],
            style: textStyle16.copyWith(
              color: AppColors.orangeColor,
            )),
      );
}
