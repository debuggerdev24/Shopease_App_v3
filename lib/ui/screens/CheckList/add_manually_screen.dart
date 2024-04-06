import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/auth_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/profile_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';

import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/card_dropdown.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddManuallyScreen extends StatefulWidget {
  const AddManuallyScreen({
    super.key,
  });

  @override
  State<AddManuallyScreen> createState() => _AddManuallyScreenState();
}

class _AddManuallyScreenState extends State<AddManuallyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();
  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  bool check = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InventoryProvider().clearUploadedFilePath();
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final platformFile = result.files.single;
      final fileSize = platformFile.size ?? 0; // File size in bytes

      if (fileSize <= 5 * 1024 * 1024) {
        // File size is less than or equal to 5MB
        String? filePath = platformFile.path;
        String fileName = File(filePath ?? '').path.split('/').last;
        setState(() {
          uploadedFilePath = fileName;
        });
      } else {
        Fluttertoast.showToast(
            backgroundColor: AppColors.orangeColor,
            gravity: ToastGravity.TOP,
            msg: 'Please select a file smaller than 5MB.');
      }
    } else {
      // User canceled the file picker
    }
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      log('No file selected');
      return;
    }

// Upload file with its filename as the key
    final platformFile = result.files.single;
    final path = platformFile.path!;
    final key = DateTime.now().toString() + platformFile.name;
    final file = File(path);

    setState(() {
      imagekey = key;
      imagefile = File(path);
      uploadedFilePath = key;
    });
  }

  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    var isLoading = false;
    final ValueNotifier<bool> isEnabled = ValueNotifier(false);
    late final TextEditingController _nameController;

    _nameController = TextEditingController()
      ..addListener(() {
        if (_nameController.text.isNotEmpty) {
          isEnabled.value = true;
        } else {
          isEnabled.value = false;
        }
      });

    return Consumer<InventoryProvider>(builder: (context, provider, _) {
      String? validateImage() {
        if (uploadedFilePath == null || uploadedFilePath!.isEmpty) {
          return 'Please upload a photo';
        }
        return null;
      }

      void _submit() {
        final isValid = _formKey.currentState!.validate();

        if (!isValid) {
          CustomToast.showError(context, 'Please fill all required fields.');
          return;
        }
        setState(() {
          check = true;
        });

        context.pushNamed(AppRoute.checkList.name);
      }

      return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: GestureDetector(
              onTap: () {
                context.pop();
              },
              child: const SvgIcon(
                AppAssets.arrowLeft,
                color: AppColors.blackColor,
              ),
            ),
          ),
          leadingWidth: 30.sp,
          iconTheme: IconThemeData(color: AppColors.blackColor, size: 20.sp),
          title: Text(
            "Add Manually",
            style: textStyle20SemiBold.copyWith(fontSize: 24),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 17),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a valid name!';
                          }
                          return null;
                        },
                        controller: _nameController,
                        name: "Enter product name",
                        hintText: "Enter product name",
                        // labelText: "  Product name",
                        labelStyle: textStyle16.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                      ),
                      12.h.verticalSpace,
                      12.h.verticalSpace,
                      AppTextField(
                        controller: _descController,
                        hintText: "Enter Description",
                        maxLines: 3,
                        name: "Name",
                        labelText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(
                            color: AppColors.mediumGreyColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.r),
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 162, 4, 4),
                          ),
                        ),
                      ),
                      12.h.verticalSpace,
                      AppTextField(
                        controller: _brandController,
                        hintText: "Enter brand name",
                        name: "Name",
                        labelText: "Brand",
                      ),
                      12.h.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GlobalText(
                          'Inventory Level',
                          textStyle: textStyle16.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      18.verticalSpace,
                      CardDropDownField(
                        value: InventoryType.low.name,
                        labelStyle: textStyle16.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                        // labelText: 'Inventory Level',
                        dropDownList: InventoryDropdownList(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an inventory level';
                          }
                          return null;
                        },
                      ),
                      12.h.verticalSpace,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RichText(
                          text: TextSpan(
                            text: '*',
                            style: const TextStyle(
                                color: Colors.red, fontSize: 17),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Select Category',
                                style: textStyle16.copyWith(
                                    color: AppColors.blackColor,
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      18.verticalSpace,
                      CardDropDownField(
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.toString() == 'Select Category') {
                            return 'Please select a Category';
                          }
                          return null;
                        },
                        value: 'Select Category',
                        labelStyle: textStyle16.copyWith(
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w400),
                        // labelText: 'Inventory Level',
                        dropDownList: CategoryList(),
                        trailing: SvgPicture.asset(AppAssets.dropDown),
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
                          _openFilePicker();
                          await uploadFile();
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
                                  uploadedFilePath ?? "Select a photo",
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
                      AppTextField(
                        controller: _storageController,
                        hintText: "Enter storage detail",
                        name: "Storage Details",
                        labelText: "Storage Details",
                      ),
                      30.h.verticalSpace,

                      ValueListenableBuilder<bool>(
                          valueListenable: isEnabled,
                          builder: (context, value, child) {
                            return AppButton(
                              colorType: value
                                  ? AppButtonColorType.primary
                                  : AppButtonColorType.greyed,
                              onPressed: () => _submit(),
                              text: 'Save',
                            );
                          }),
                      //   // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<DropdownMenuItem<String>> InventoryDropdownList() =>
      ['Low', 'Medium', 'High']
          .asMap()
          .entries
          .map(
            (entry) => DropdownMenuItem(
              value: entry.value.toLowerCase(),
              child: Row(
                children: [
                  _getIconForIndex(entry.key),
                  10.h.horizontalSpace,
                  Text(entry.value, style: textStyle16),
                ],
              ),
            ),
          )
          .toList();

  Widget _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return SvgIcon(AppAssets.inventoryLow, color: Colors.red);
      case 1:
        return SvgIcon(AppAssets.inventoryMid, color: Colors.yellow);
      case 2:
        return SvgIcon(AppAssets.inventoryHigh, color: Colors.green);
      default:
        return SizedBox.shrink();
    }
  }

  List<DropdownMenuItem<String>> CategoryList() =>
      ['Select Category', 'Fresh Fruits', 'Fresh Vegetables', 'Other Category']
          .asMap()
          .entries
          .map(
            (entry) => DropdownMenuItem(
              value: entry.value,
              child: Row(
                children: [
                  10.h.horizontalSpace,
                  Text(entry.value, style: textStyle16),
                ],
              ),
            ),
          )
          .toList();
}
