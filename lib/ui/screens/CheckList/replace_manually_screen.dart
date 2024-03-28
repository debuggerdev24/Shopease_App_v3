import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ReplaceManuallyscvreen extends StatefulWidget {
  const ReplaceManuallyscvreen({super.key});

  @override
  State<ReplaceManuallyscvreen> createState() => _ReplaceManuallyscvreenState();
}

class _ReplaceManuallyscvreenState extends State<ReplaceManuallyscvreen> {
  @override
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _brandController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.blackColor, size: 30.sp),
          title: GlobalText(
            "Replace Manually",
            textStyle: textStyle20SemiBold.copyWith(fontSize: 24),
          )),
      body: Consumer<ChecklistProvider>(
        builder: (context, provider, _) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.sp),
            padding: EdgeInsets.symmetric(horizontal: 10.sp),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  20.h.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                        text: '*',
                        style: const TextStyle(color: Colors.red, fontSize: 17),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Name',
                            style: textStyle16.copyWith(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                  9.verticalSpace,
                  AppTextField(
                    controller: _nameController,
                    name: "Enter product name",
                    hintText: "Enter product name",
                    // labelText: "  Product name",
                    labelStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                  ),
                  12.h.verticalSpace,
                  AppTextField(
                    controller: _descController,
                    hintText: "Enter Description",
                    maxLines: 3,
                    name: "Name",
                    labelText: "Description",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      borderSide: const BorderSide(
                        color: AppColors.mediumGreyColor,
                      ),
                    ),
                  ),
                  12.h.verticalSpace,
                  AppTextField(
                    controller: _descController,
                    hintText: "Enter Brand",
                    name: "Name",
                    labelText: "Brand",
                  ),
                  12.h.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GlobalText(
                      ' Upload Photo',
                      textStyle: textStyle16.copyWith(
                        color: AppColors.blackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  10.h.verticalSpace,
                  GestureDetector(
                    onTap: () async {
                      await provider.openFilePicker(context);
                      await provider.uploadFile();
                    },
                    child: Container(
                      width: 450.h,
                      padding: EdgeInsets.all(13.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(36),
                        border: Border.all(color: AppColors.darkGreyColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 5,
                            child: Text(
                              provider.uploadedFilePath ?? "Select a photo",
                              style: textStyle14.copyWith(
                                  color: AppColors.mediumGreyColor),
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: SvgIcon(
                              AppAssets.upload,
                              color: AppColors.blackColor,
                              size: 16.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  2.h.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: GlobalText(
                      ' Max File Size:5MB',
                      textStyle: textStyle12.copyWith(
                        color: AppColors.mediumGreyColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  30.h.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 40.sp),
        child: AppButton(
            onPressed: () {
              context.goNamed(AppRoute.checkList.name);
            },
            text: 'Save'),
      ),
    );
  }
}
