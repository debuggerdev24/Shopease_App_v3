import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/checklist_tile.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class UploadInvoiceScreen extends StatefulWidget {
  const UploadInvoiceScreen({super.key});

  @override
  State<UploadInvoiceScreen> createState() => _UploadInvoiceScreenState();
}

class _UploadInvoiceScreenState extends State<UploadInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChecklistProvider>(builder: (context, provider, _) {
      return Scaffold(
          backgroundColor: AppColors.whiteColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
            title: GlobalText(
              "Upload Invoice",
              textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
            ),
          ),
          body: Column(
            children: [
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                  child: GlobalText(
                      color: AppColors.orangeColor,
                      '${provider.shops[provider.selectedShopIndex]['title'].toString()}',
                      textStyle: textStyle14.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.orangeColor,
                        color: AppColors.orangeColor,
                      )),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: provider.checklist
                        .map(
                          (e) => ChecklistTile(
                            product: e,
                            onDelete: () {
                              provider.deleteProduct(e['title']);
                            },
                            isUpload: true,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              AppButton(
                  onPressed: () {
                    context
                        .pushReplacementNamed(AppRoute.addInvoice.name, extra: {
                      'shop': provider.shops[provider.selectedShopIndex]
                              ['title']
                          .toString(),
                      'total': 300
                    });
                  },
                  text: 'Upload Invoice'),
              20.h.verticalSpace,
              AppButton(
                onPressed: () {
                  context.pop();
                },
                text: 'Do it Later',
                colorType: AppButtonColorType.secondary,
              ),
              20.h.verticalSpace,
            ],
          ));
    });
  }
}
