import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/scan_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class SaveInvoiceScreen extends StatefulWidget {
  const SaveInvoiceScreen({
    super.key,
    required this.shop,
    required this.total,
  });
  final String shop;
  final int total;
  @override
  State<SaveInvoiceScreen> createState() => _SaveInvoiceScreenState();
}

class _SaveInvoiceScreenState extends State<SaveInvoiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log('shop:${widget.shop}:::total:${widget.total}');
    return Consumer2<ScannerProvider, ChecklistProvider>(
      builder: (context, scannerProvider, checklistProvider, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
            title: GlobalText(
              "Scan & Add Invoice",
              textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalText(
                    'Invoice',
                    textStyle: textStyle16,
                  ),
                  9.verticalSpace,
                  Container(
                      height: 80.sp,
                      width: 80.sp,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.invoice)),
                      )),
                  30.verticalSpace,
                  GlobalText(
                    ' Enter Amount',
                    textStyle: textStyle16.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  10.h.verticalSpace,
                  AppTextField(
                    enabled: false,
                    controller: _nameController,
                    name: "Enter product name",
                    hintText: '\$ ${widget.total}',
                    hintStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    // labelText: "  Product name",
                    labelStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                  ),
                  12.h.verticalSpace,
                  GlobalText(
                    'Shop Name',
                    textStyle: textStyle16.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  10.h.verticalSpace,
                  AppTextField(
                    enabled: false,

                    controller: _nameController,

                    name: "Shop Name",
                    hintText: widget.shop,
                    hintStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    // labelText: "  Product name",
                    labelStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                  ),
                  20.verticalSpace,
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AppButton(
                onPressed: () {
                  Map<String, dynamic> newData = {
                    'shop': widget.shop,
                    'total': widget.total,
                    'img': AppAssets.invoice,
                    'products': 4,
                    'isInvoice': true
                  };

                  log("history $newData");
                  checklistProvider.addToHistory(newData);
                  CustomToast.showSuccess(context, 'Invoice added');

                  context.goNamed(AppRoute.checkList.name);
                },
                text: "Save",
              )),
        );
      },
    );
  }
}
