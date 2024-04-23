import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class CardDropDownField extends StatelessWidget {
  const CardDropDownField({
    super.key,
    required this.dropDownList,
    this.labelText = "",
    this.hintText,
    this.leading,
    this.trailing,
    this.validator,
    this.labelStyle,
    this.value,
    this.isRequired = false,
    this.onChanged,
  });

  final String? labelText;
  final String? hintText;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? labelStyle;
  final String? Function(dynamic)? validator;
  final List<DropdownMenuItem> dropDownList;
  final dynamic value;
  final bool isRequired;
  final Function(dynamic)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      labelText?.isNotEmpty ?? false
          ? Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: labelText,
                    style: labelStyle ??
                        textStyle16.copyWith(color: AppColors.blackColor),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: textStyle16.copyWith(color: AppColors.redColor),
                    ),
                ]),
              ),
            )
          : const SizedBox.shrink(),
      DropdownButtonFormField(
        value: value,
        items: dropDownList,
        onChanged: onChanged,
        isDense: true,
        // validator: widget.validator,
        decoration: InputDecoration(
          labelStyle: labelStyle ??
              textStyle16.copyWith(
                  color: AppColors.blackColor, fontWeight: FontWeight.w400),
          suffixIconConstraints: BoxConstraints(
              maxHeight: 32.w, maxWidth: 32.w, minHeight: 30.w, minWidth: 30.w),
          filled: true,
          hintText: hintText ?? '',
          hintStyle: textStyle16.copyWith(color: Colors.black.withOpacity(0.4)),
          isDense: true,
          focusColor: AppColors.orangeColor,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: const BorderSide(
              color: AppColors.mediumGreyColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: const BorderSide(
              color: AppColors.mediumGreyColor,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.r),
            borderSide: const BorderSide(
              color: AppColors.mediumGreyColor,
            ),
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(width: 0.5.w, color: Colors.white),
              borderRadius: BorderRadius.circular(20.r)),
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        ),
      )
    ]);
  }
}
