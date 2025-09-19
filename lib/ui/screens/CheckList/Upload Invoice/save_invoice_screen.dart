import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/image_sheet.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class SaveInvoiceScreen extends StatefulWidget {
  const SaveInvoiceScreen({
    super.key,
    this.shop,
    this.totalAmount,
    this.histId,
    required this.edit,
  });

  final String? shop;
  final String? histId;
  final String? totalAmount;
  final bool edit;

  @override
  @override
  State<SaveInvoiceScreen> createState() => _SaveInvoiceScreenState();
}

class _SaveInvoiceScreenState extends State<SaveInvoiceScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text = widget.shop ??
          context.read<ChecklistProvider>().selectedShop?.shopName ??
          '';
    });
  }

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log('shop:${widget.shop}:::total:${widget.totalAmount}:::histId:${widget.histId}');
    final provider = context.watch<HistoryProvider>();
    // final scannedData = provider.scannedText.split("\n");

    // for (int i = 0; i < scannedData.length; i++) {
    //   if (scannedData[i].toLowerCase().contains("amount") ||
    //       scannedData[i].toLowerCase().contains("total")) {
    //     _priceController.text = scannedData[i].split(" ")[1] ?? "";
    //   }
    // }

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
              child: Form(
                key: formKey,
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
                              showImageSheet(
                                context: context,
                                imgUrl: provider.selectedFile!.path,
                              );
                            } else {
                              provider.selectFileFromGallery(
                                  onSuccess: () {}, context: context);
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
                            onPressed: () {
                              _priceController.clear();
                              provider.clearFile();
                            },
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: _priceController,
                      validator: (value) {
                        if (value!.toString().isEmpty) {
                          return "Please enter the Amount";
                        }
                        return null;
                      },
                      // prefixText: '\$',
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
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: AppButton(
                text: "Save",
                isLoading: provider.isLoading,
                onPressed: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }
                  print("DateTime.now().toUtc() ==> ${DateTime.now().toUtc()}");
                  Map<String, dynamic> newData = {
                    'hist_id': widget.histId ??
                        context.read<ChecklistProvider>().currentHistId,
                    'shop_name': _nameController.text,
                    'total_price': _priceController.text,
                    'updated_date': DateTime.now().toUtc().toString(),
                    'item_image': provider.selectedFile?.path,
                    // 'item_count': context
                    //     .read<Chec>klistProvider>()
                    //     .selectedChecklists
                    //     .length,
                  };
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
                      // context.read<InventoryProvider>().putInventoryItem(
                      //       data: provider.scannedItem,
                      //       isEdit: false,
                      //       onError: (msg) =>
                      //           CustomToast.showError(context, msg),
                      //       onSuccess: () {
                      //         // if (!widget.isEdit) {
                      //         CustomToast.showSuccess(
                      //             context, 'Product added successfully!');
                      //         // }
                      //         context
                      //             .read<InventoryProvider>()
                      //             .getInventoryItems();
                      //         context.goNamed(AppRoute.home.name);
                      //       },
                      //     );
                    },
                    onError: (msg) {
                      CustomToast.showError(context, msg);
                    },
                  );

                  // log(provider.scannedItem.toString());
                },
              )),
        );
      },
    );
  }
}
