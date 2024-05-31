import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/ui/widgets/add_inventory_form/add_item_form_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/back_button.dart';
import 'package:shopease_app_flutter/ui/widgets/card_drop_down.dart';
import 'package:shopease_app_flutter/ui/widgets/image_picker_helper.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddItemFormWidget extends StatelessWidget {
  const AddItemFormWidget({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.isEdit = false,
    this.isFromScan = false,
    this.title,
    this.product,
  });

  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final Product? product;
  final bool isFromScan;
  final bool isEdit;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddItemFormProvider(InventoryService()),
      child: AddItemForm(
        onSubmit: onSubmit,
        isLoading: isLoading,
        isFromScan: isFromScan,
        isEdit: isEdit,
        product: product,
        title: title,
      ),
    );
  }
}

class AddItemForm extends StatefulWidget {
  const AddItemForm({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.isEdit = false,
    this.isFromScan = false,
    this.product,
    this.title,
  });

  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final Product? product;
  final bool isEdit;
  final bool isFromScan;
  final String? title;

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState<T> extends State<AddItemForm> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _descController = TextEditingController();

  final TextEditingController _brandController = TextEditingController();

  final TextEditingController _storageController = TextEditingController();

  final TextEditingController _fileFieldController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AddItemFormProvider>().getCategories(
            onSuccess: setFromFields,
            onError: (msg) {
              setFromFields();
            },
          );
      if (widget.product == null || !widget.isEdit) {
        context.read<AddItemFormProvider>().changeSelectedCategory(null);
        context.read<AddItemFormProvider>().changeSelectedInvType(null);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        leading: KBackButton(
          onBackClick: () {
            if (widget.isFromScan) {
              CustomToast.showWarning(context, 'Your item will be discardd');
            }
          },
        ),
        titleSpacing: 0,
        title: Text(
          widget.title ?? "Add `Manually`",
          style: textStyle20SemiBold.copyWith(fontSize: 24),
        ),
      ),
      body: Consumer<AddItemFormProvider>(builder: (context, provider, _) {
        return provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
                        name: 'inventoryLevelDropDown',
                        labelText: 'Inventory Level',
                        hintText: 'Select a inventory level',
                        value: provider.selectedInvType,
                        dropDownList: inventoryDropdownList(),
                        onChanged: (value) {
                          provider.changeSelectedInvType(value);
                        },
                      ),
                      12.h.verticalSpace,
                      CardDropDownField(
                        name: 'categoryDropDown',
                        isRequired: true,
                        labelText: 'Category',
                        hintText: 'Select a category',
                        value: provider.selectedCategoryId,
                        dropDownList: categoryList(),
                        trailing: SvgPicture.asset(AppAssets.dropDown),
                        onChanged: (value) {
                          provider.changeSelectedCategory(value);
                        },
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
                        maxLines: 1,
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
                                  provider.clearFile();
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
                        colorType: (_nameController.text.isNotEmpty &&
                                provider.selectedCategoryId != null)
                            ? AppButtonColorType.primary
                            : AppButtonColorType.greyed,
                        isLoading: widget.isLoading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            final Map<String, dynamic> data = {
                              'product_name': _nameController.text,
                              'product_description': _descController.text,
                              'brand': _brandController.text,
                              'item_level': provider.selectedInvType,
                              'item_category': provider.categories
                                  .firstWhere((element) =>
                                      element.categoryId ==
                                      provider.selectedCategoryId)
                                  .categoryName,
                              'item_storage': _storageController.text,
                              'is_in_checklist': false,
                            };

                            if (!widget.isEdit &&
                                _fileFieldController.text.isNotEmpty) {
                              data.addAll({
                                'item_image': provider.selectedFile?.path ??
                                    widget.product?.itemImage
                              });
                            }

                            if (widget.isEdit && widget.product != null) {
                              data.clear();
                              data.addAll(widget.product!
                                  .copyWith(
                                    productName: _nameController.text,
                                    productDescription: _descController.text,
                                    brand: _brandController.text,
                                    itemLevel: provider.selectedInvType,
                                    itemCategory: provider.categories
                                        .firstWhere((element) =>
                                            element.categoryId ==
                                            provider.selectedCategoryId)
                                        .categoryName,
                                    itemImage: provider.selectedFile?.path,
                                    itemStorage: _storageController.text,
                                  )
                                  .toJson());
                            }

                            log('data: ${data.toString()}', name: 'onsubmit');

                            widget.onSubmit(data);
                          }
                        },
                        text: 'Save',
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  setFromFields() {
    if (widget.product == null) return;

    _nameController.text = widget.product!.productName ?? '';
    _descController.text = widget.product!.productDescription ?? '';
    _brandController.text = widget.product!.brand ?? '';
    context
        .read<AddItemFormProvider>()
        .changeSelectedInvType(widget.product!.itemLevel);
    _fileFieldController.text = widget.product!.itemImage ?? '';
    _storageController.text = widget.product!.itemStorage ?? '';
    context.read<AddItemFormProvider>().changeSelectedCategory(
          context
              .read<AddItemFormProvider>()
              .categories
              .firstWhere(
                (element) =>
                    element.categoryName == widget.product!.itemCategory,
              )
              .categoryId,
        );
  }

  onSelectFileTap() async {
    final name = await context.read<AddItemFormProvider>().setFile(
          await ImagePickerhelper().openPicker(context),
        );
    log('file name => $name', name: 'onSelectFileTap');
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

  List<DropdownMenuItem<dynamic>> categoryList() => context
      .read<AddItemFormProvider>()
      .categories
      .map(
        (category) => DropdownMenuItem(
          value: category.categoryId,
          child: Row(
            children: [
              10.h.horizontalSpace,
              Text(category.categoryName, style: textStyle16),
            ],
          ),
        ),
      )
      .toList();
}
