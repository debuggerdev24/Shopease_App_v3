import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/ui/widgets/add_inventory_form/add_item_form_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/back_button.dart';
import 'package:shopease_app_flutter/ui/widgets/card_drop_down.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/image_picker_helper.dart';
import 'package:shopease_app_flutter/ui/widgets/image_sheet.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/extensions/date_time_ext.dart';
import 'package:shopease_app_flutter/utils/extensions/string_extension.dart';
import 'package:shopease_app_flutter/utils/number_range_formatter.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddItemFormWidget extends StatelessWidget {
  const AddItemFormWidget({
    super.key,
    required this.onSubmit,
    this.isLoading = false,
    this.isEdit = false,
    this.isFromScan = false,
    this.isFromReplace = false,
    this.title,
    this.product,
    this.oldChecklistItemId,
    this.isForChecklist = false,
  });

  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final Product? product;
  final bool isFromScan;
  final bool isFromReplace;
  final bool isEdit;
  final String? title;
  final String? oldChecklistItemId;
  final bool isForChecklist;

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
        isFromReplace: isFromReplace,
        oldChecklistItemId: oldChecklistItemId,
        isForChecklist: isForChecklist,
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
    this.isFromReplace = false,
    this.product,
    this.title,
    this.oldChecklistItemId,
    this.isForChecklist = false,
  });

  final Function(Map<String, dynamic>) onSubmit;
  final bool isLoading;
  final Product? product;
  final bool isEdit;
  final bool isFromScan;
  final bool isFromReplace;
  final String? title;
  final String? oldChecklistItemId;
  final bool isForChecklist;

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState<T> extends State<AddItemForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _storageController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _fileFieldController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEnabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<AddItemFormProvider>().getCategories(
            onSuccess: setFormFields,
            onError: (_) => setFormFields(),
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
          widget.title ?? "Add Manually",
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      AppTextField(
                        onChanged: (p0) {
                          setState(() {});
                        },
                        controller: _nameController,
                        name: "name",
                        labelText: "Name",
                        hintText: "Enter product name",
                        isRequired: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                        // validator: (value) {
                        //   if (value!.toString().isEmpty) {
                        //     return 'Please Enter Description!';
                        //   }
                        //
                        //   return null;
                        // },
                      ),
                      12.h.verticalSpace,
                      AppTextField(
                        name: "brand",
                        controller: _brandController,
                        labelText: "Brand",
                        hintText: "Enter brand name",
                        validator: (value) {
                          // if (value.length > 10) {
                          //   return 'Brand Name cannot be more than 10 characters!';
                          // }
                          return null;
                        },
                      ),
                      12.h.verticalSpace,
                      AppTextField(
                        name: widget.isForChecklist == true
                            ? "requiredQuantity"
                            : "inStockQuantity",
                        controller: _quantityController,
                        labelText: widget.isForChecklist
                            ? "Required Quantity"
                            : "InStock Quantity",
                        hintText: "Enter from 1 to 99",
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          NumberRangeFormatter(min: 0, max: 99),
                        ],
                        validator: (value) {
                          if (value.toString().isNotEmpty &&
                              int.parse(value) < 1) {
                            return 'Please Enter Valid Quantity!';
                          }
                          return null;
                        },
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
                      AppTextField(
                        name: "expiryDate",
                        controller: _expiryDateController,
                        labelText: "Expiry Date",
                        hintText: "MM/dd/YYYY",
                        readOnly: true,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8),
                          child: SvgPicture.asset(
                            AppAssets.calender,
                            color: AppColors.blackColor,
                          ),
                        ),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 100),
                          );
                          if (date != null) {
                            _expiryDateController.text = date.toMMDDYYYY;
                          }
                        },
                        // validator: (value) {
                        //   if (value!.toString().isEmpty) {
                        //     return 'Please Enter Date!';
                        //   }
                        //   return null;
                        // },
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
                      GlobalText(
                        'Upload Photo',
                        textStyle: textStyle16,
                        textAlign: TextAlign.start,
                      ),
                      9.verticalSpace,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _fileFieldController.text.isEmpty ||
                                    _fileFieldController.text
                                        .startsWith(Constants.defaultItemImage)
                                ? onSelectFileTap
                                : onSelectFileTap,
                            // : () {},
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.blackColor),
                                    image: _fileFieldController.text.isEmpty
                                        ? null
                                        : provider.selectedFile != null &&
                                                File(_fileFieldController.text)
                                                    .existsSync()
                                            ? DecorationImage(
                                                image: FileImage(
                                                  File(_fileFieldController
                                                      .text),
                                                ),
                                              )
                                            : DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
                                                        _fileFieldController
                                                            .text),
                                              ),
                                  ),
                                  child: _fileFieldController.text.isEmpty
                                      ? SvgPicture.asset(AppAssets.addInvoice)
                                      : provider.selectedFile != null
                                          ? SvgPicture.asset(AppAssets.zoomIcon)
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          if (_fileFieldController.text.isNotEmpty ||
                              _fileFieldController.text
                                  .startsWith(Constants.defaultItemImage))
                            IconButton(
                              onPressed: () {
                                _fileFieldController.clear();
                                provider.clearFile();
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.redColor,
                              ),
                            ),
                        ],
                      ),
                      12.h.verticalSpace,
                      AppTextField(
                        controller: _storageController,
                        hintText: "Enter storage detail",
                        name: "Storage Details",
                        labelText: "Storage Details",
                        validator: (value) {
                          if (value.length > 15) {
                            return 'Name cannot be more than 15 characters!';
                          }
                          return null;
                        },
                      ),
                      30.h.verticalSpace,
                      AppButton(
                        colorType: AppButtonColorType.primary,
                        // (_nameController.text.isNotEmpty)
                        //     ? AppButtonColorType.primary
                        // : AppButtonColorType.greyed,
                        isLoading: widget.isLoading,
                        onPressed: () {
                          if (_formKey.currentState?.validate() == true) {
                            log(widget.isForChecklist.toString());
                            final Map<String, dynamic> data = {
                              'product_name': _nameController.text,
                              'product_description': _descController.text,
                              'brand': _brandController.text,
                              (widget.isForChecklist
                                      ? 'required_quantity'
                                      : 'in_stock_quantity'):
                                  _quantityController.text.trim().isEmpty
                                      ? "1"
                                      : _quantityController.text.trim(),
                              'item_level': provider.selectedInvType,
                              'expiry_date': _expiryDateController
                                      .text.isNotEmpty
                                  ? _expiryDateController.text.mmddYYYYToDate
                                      .toIso8601String()
                                  : null,
                              'item_category': provider.categories
                                  .firstWhere((element) =>
                                      element.categoryId ==
                                      provider.selectedCategoryId)
                                  .categoryName,
                              'item_storage': _storageController.text,
                              'is_in_checklist': widget.isForChecklist,
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
                                    inStockQuantity: widget.isForChecklist
                                        ? ""
                                        : _quantityController.text
                                                .trim()
                                                .isEmpty
                                            ? "1"
                                            : _quantityController.text,
                                    requiredQuantity: widget.isForChecklist
                                        ? _quantityController.text
                                                .trim()
                                                .isEmpty
                                            ? "1"
                                            : _quantityController.text
                                        : "",
                                    itemLevel: provider.selectedInvType,
                                    expiryDate: _expiryDateController.text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : _expiryDateController
                                            .text.mmddYYYYToDate,
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

                            if (widget.isFromReplace &&
                                widget.oldChecklistItemId != null) {
                              data.addAll({
                                'old_checklist_item_id':
                                    widget.oldChecklistItemId
                              });
                            }

                            log('data: ${data.toString()}', name: 'onsubmit');

                            widget.onSubmit(data);
                            provider.setFile(null);
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

  showZoomedImg() {
    showImageSheet(
      context: context,
      imgUrl: _fileFieldController.text,
      onDelete: () {
        _fileFieldController.clear();
        context.read<AddItemFormProvider>().clearFile();
        context.pop();
      },
    );
  }

  setFormFields() {
    context.read<AddItemFormProvider>().changeSelectedCategory(
          context.read<AddItemFormProvider>().categories.firstWhere(
            (element) {
              return element.categoryName == 'Other';
            },
          ).categoryId,
        );
    if (widget.product == null) return;

    _nameController.text = widget.product!.productName ?? '';
    _descController.text = widget.product!.productDescription ?? '';
    _brandController.text = widget.product!.brand ?? '';
    _quantityController.text = widget.isForChecklist
        ? widget.product!.requiredQuantity
        : widget.product!.inStockQuantity;
    context
        .read<AddItemFormProvider>()
        .changeSelectedInvType(widget.product!.itemLevel);
    _fileFieldController.text = widget.product!.itemImage ?? '';
    _storageController.text = widget.product!.itemStorage ?? '';
    _expiryDateController.text = widget.product!.expiryDate?.toMMDDYYYY ?? '';
    context.read<AddItemFormProvider>().changeSelectedCategory(
          context.read<AddItemFormProvider>().categories.firstWhere(
            (element) {
              log('element.categoryName => ${element.categoryName}');
              log('widget.product!.itemCategory => ${widget.product!.itemCategory}');
              return element.categoryName == widget.product!.itemCategory;
            },
          ).categoryId,
        );
  }

  onSelectFileTap() async {
    final name = await context.read<AddItemFormProvider>().setFile(
          await ImagePickerHelper().openPicker(context),
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
        return const SvgIcon(
          AppAssets.inventoryMid,
          color: Colors.orange,
        );

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
