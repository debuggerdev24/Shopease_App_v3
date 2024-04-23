import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/back_button.dart';
import 'package:shopease_app_flutter/ui/widgets/card_dropdown.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddItemManuallyForm extends StatefulWidget {
  const AddItemManuallyForm({
    super.key,
    required this.onSubmit,
    required this.categoties,
    required this.onCategoryChange,
    required this.onInventoryLevelChanged,
    required this.onFilePicked,
    required this.onFileClear,
  });

  final VoidCallback onSubmit;
  final List<dynamic> categoties;
  final Function(dynamic) onCategoryChange;
  final Function(dynamic) onInventoryLevelChanged;
  final Future<String?> Function() onFilePicked;
  final Function() onFileClear;

  @override
  State<AddItemManuallyForm> createState() => _AddItemManuallyFormState();
}

class _AddItemManuallyFormState extends State<AddItemManuallyForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _brandController = TextEditingController();

  final TextEditingController _storageController = TextEditingController();

  final TextEditingController _fileFieldController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: const KBackButton(),
        titleSpacing: 0,
        title: Text(
          "Add Manually",
          style: textStyle20SemiBold.copyWith(fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    AppTextField(
                      controller: _nameController,
                      name: "name",
                      labelText: "Name",
                      hintText: "Enter product name",
                      isRequired: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a valid name!';
                        }
                        return null;
                      },
                    ),
                    12.h.verticalSpace,
                    AppTextField(
                      name: "description",
                      controller: _descController,
                      labelText: "Description",
                      hintText: "Enter Description",
                      maxLines: 3,
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
                      name: "brand",
                      controller: _brandController,
                      labelText: "Brand",
                      hintText: "Enter brand name",
                    ),
                    12.h.verticalSpace,
                    CardDropDownField(
                      labelText: 'Inventory Level',
                      hintText: 'Select a inventory level',
                      dropDownList: inventoryDropdownList(),
                      onChanged: widget.onInventoryLevelChanged,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select an inventory level';
                        }
                        return null;
                      },
                    ),
                    12.h.verticalSpace,
                    CardDropDownField(
                      isRequired: true,
                      labelText: 'Category',
                      hintText: 'Select a category',
                      dropDownList: categoryList(),
                      trailing: SvgPicture.asset(AppAssets.dropDown),
                      onChanged: widget.onCategoryChange,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a Category';
                        }
                        return null;
                      },
                    ),
                    12.h.verticalSpace,
                    AppTextField(
                      name: 'productImg',
                      controller: _fileFieldController,
                      readOnly: true,
                      labelText: 'Upload Photo',
                      hintText: 'Select a photo',
                      bottomText: 'Max File Size:5MB',
                      onTap: onSelectFileTap,
                      suffixIcon: _fileFieldController.text.isEmpty
                          ? IconButton(
                              onPressed: onSelectFileTap,
                              icon: SvgIcon(
                                AppAssets.upload,
                                color: AppColors.blackColor,
                                size: 18.sp,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                _fileFieldController.clear();
                                widget.onFileClear();
                              },
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                    AppTextField(
                      controller: _storageController,
                      hintText: "Enter storage detail",
                      name: "Storage Details",
                      labelText: "Storage Details",
                    ),
                    30.h.verticalSpace,

                    AppButton(
                      colorType: _formKey.currentState?.validate() == true
                          ? AppButtonColorType.primary
                          : AppButtonColorType.greyed,
                      onPressed: () {
                        if (_formKey.currentState?.validate() == true) {
                          widget.onSubmit();
                        }
                      },
                      text: 'Save',
                    ),
                    //   // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSelectFileTap() async {
    final name = await widget.onFilePicked();
    if (name != null) {
      _fileFieldController.text = name;
    }
  }

  List<DropdownMenuItem<String>> inventoryDropdownList() =>
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
        return const SvgIcon(AppAssets.inventoryLow, color: Colors.red);
      case 1:
        return const SvgIcon(AppAssets.inventoryMid, color: Colors.yellow);
      case 2:
        return const SvgIcon(AppAssets.inventoryHigh, color: Colors.green);
      default:
        return const SizedBox.shrink();
    }
  }

  List<DropdownMenuItem<dynamic>> categoryList() => widget.categoties
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
