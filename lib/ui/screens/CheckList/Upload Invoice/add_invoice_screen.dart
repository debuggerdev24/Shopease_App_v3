import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/providers/history_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/image_picker_helper.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddInvoiceScreen extends StatefulWidget {
  const AddInvoiceScreen({
    super.key,
    this.shop,
    this.histId,
    /*required this.total*/
  });
  final String? shop;
  final String? histId;
  // final int total;
  @override
  State<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends State<AddInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    // log("shop:${widget.shop}:::::total${widget.total}");
    return Consumer<HistoryProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
          title: GlobalText(
            "Add Invoice",
            textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 20.sp),
          child: Column(
            children: [
              10.verticalSpace,
              GlobalText(
                'Effortlessly manage your receipts by capturing photos. Quickly track your budget and easily locate your purchases',
                textStyle: textStyle14.copyWith(fontSize: 16),
              ),
              const Spacer(),
              AppButton(
                  onPressed: () async {
                    await provider
                        .changeSelectedFile(
                            await ImagePickerhelper().openPicker(context))
                        .then(
                          (value) => context.pushNamed(
                            AppRoute.saveInvoice.name,
                            extra: {
                              'shop': widget.shop,
                              'histId': widget.histId,
                              // 'total': 100,
                            },
                          ),
                        );
                  },
                  text: 'Add Invoice'),
              20.h.verticalSpace,
              // AppButton(
              //   onPressed: () async {
              //     await provider.selectFileFromGallery(onSuccess: () {
              //       context.pushNamed(AppRoute.saveInvoice.name, extra: {
              //         'shop': widget.shop,
              //         'histId': widget.histId,
              //         // 'total': 100,
              //       });
              //     });
              //   },
              //   text: 'Upload from Gallery',
              //   colorType: AppButtonColorType.secondary,
              // ),
              30.h.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
