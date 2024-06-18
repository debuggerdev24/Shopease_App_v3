import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
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
    this.shop,
    this.total,
    this.histId,
    required this.edit,
  });

  final String? shop;
  final String? histId;
  final int? total;
  final bool edit;

  @override
  State<SaveInvoiceScreen> createState() => _SaveInvoiceScreenState();
}

class _SaveInvoiceScreenState extends State<SaveInvoiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.total.toString();
    _nameController.text = widget.shop ??
        context.read<ChecklistProvider>().selectedShop?.shopName ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    log('shop:${widget.shop}:::total:${widget.histId}');
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
            title: widget.edit
                ? GlobalText(
                    "Scan & Edit Invoice",
                    textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
                  )
                : GlobalText(
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
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (provider.selectedFile != null) {
                            _showImgSheet();
                          } else {
                            provider.selectFileFromGallery();
                          }
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.blackColor),
                            image: provider.selectedFile != null
                                ? DecorationImage(
                                    image: FileImage(
                                      File(provider.selectedFile!.path),
                                    ),
                                  )
                                : null,
                          ),
                          child: SvgPicture.asset(
                            provider.selectedFile == null
                                ? AppAssets.addInvoice
                                : AppAssets.zoomIcon,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: provider.clearFile,
                          icon: const Icon(
                            Icons.delete,
                            color: AppColors.redColor,
                          ))
                    ],
                  ),
                  30.verticalSpace,
                  AppTextField(
                    name: "invoicePrice",
                    labelText: 'Enter Amount',
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    prefixText: '\$',
                    hintText: 'Enter invoice price',
                    hintStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                    labelStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                  ),
                  10.h.verticalSpace,
                  if (!widget.edit)
                    AppTextField(
                      name: "Shop Name",
                      enabled: false,
                      controller: _nameController,
                      labelText: 'Shop Name',
                      hintText: 'Enter shop name',
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
                text: "Save",
                isLoading: provider.isLoading,
                onPressed: () async {
                  /// Add History
                  Map<String, dynamic> newData = {
                    'hist_id': widget.histId ??
                        context.read<ChecklistProvider>().currentHistId,
                    'shop_name': _nameController.text,
                    'total_price': _priceController.text,
                    'updated_date': DateTime.now().toIso8601String(),
                    'item_image': provider.selectedFile?.path,
                    // 'item_count': context
                    //     .read<Chec>klistProvider>()
                    //     .selectedChecklists
                    //     .length,
                  };
                  log("history $newData");
                  await provider.puthistoryItems(
                    data: [newData],
                    isEdit: false,
                    onSuccess: () {
                      widget.edit
                          ? CustomToast.showSuccess(context, 'Invoice edited.')
                          : CustomToast.showSuccess(context, 'Invoice added.');
                      context.goNamed(AppRoute.checkList.name);
                      context.read<ChecklistProvider>().clearSelectedProducts();
                      provider.getHistoryItems();
                    },
                    onError: (msg) {
                      CustomToast.showError(context, msg);
                    },
                  );
                },
              )),
        );
      },
    );
  }

  Future<void> _showImgSheet() async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(10.h),
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: AppColors.blackColor,
              image: DecorationImage(
                image: FileImage(
                  File(
                    context.read<HistoryProvider>().selectedFile!.path,
                  ),
                ),
              ),
            ),
            child: IconButton.filled(
              onPressed: context.pop,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.lightGreyColor,
              ),
              icon: const Icon(Icons.clear),
            ),
          );
        });
  }
}
