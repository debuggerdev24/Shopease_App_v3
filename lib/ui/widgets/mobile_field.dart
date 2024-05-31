import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class MobileField extends StatefulWidget {
  const MobileField({
    super.key,
    required this.controller,
    required this.onTextChanged,
  });

  final TextEditingController controller;
  final Function(String?) onTextChanged;

  @override
  State<MobileField> createState() => _MobileFieldState();
}

class _MobileFieldState extends State<MobileField> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, provider, _) {
      return AppTextField(
        name: "Enter Mobile NUmber",
        labelText: 'Mobile Number',
        isRequired: true,
        hintText: "Enter mobile number",
        labelStyle: textStyle16.copyWith(
            color: AppColors.blackColor, fontWeight: FontWeight.w400),
        keyboardType: TextInputType.phone,
        onChanged: widget.onTextChanged,
        controller: widget.controller,
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
    });
  }

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
}
