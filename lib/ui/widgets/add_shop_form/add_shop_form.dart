import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/image_picker_helper.dart';
import 'package:shopease_app_flutter/ui/widgets/image_sheet.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddShopFormWidget extends StatelessWidget {
  const AddShopFormWidget({super.key, required this.onSubmit, this.shop});

  final Function(Map<String, dynamic>) onSubmit;
  final Shop? shop;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddShopFormProvider(),
      builder: (context, _) => AddShopForm(
        onSubmit: onSubmit,
        shop: shop,
      ),
    );
  }
}

class AddShopForm extends StatefulWidget {
  const AddShopForm({
    super.key,
    required this.onSubmit,
    required this.shop,
  });

  final Function(Map<String, dynamic>) onSubmit;
  final Shop? shop;

  @override
  State<AddShopForm> createState() => _AddShopFormState();
}

class _AddShopFormState extends State<AddShopForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _fileFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setFormFields();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("_fileFieldController.text ---> ${_fileFieldController.text}");
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Form(
        key: _formKey,
        child: Consumer<AddShopFormProvider>(builder: (context, provider, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GlobalText(widget.shop != null ? "Edit Shop" : 'Create New Shop',
                  textStyle: textStyle18SemiBold),
              30.h.verticalSpace,
              AppTextField(
                name: 'name',
                labelText: 'Shop name',
                isRequired: true,
                controller: _nameController,
                maxLength: 10,
              ),
              20.h.verticalSpace,
              AppTextField(
                name: 'location',
                controller: _locationController,
                labelText: 'Location',
                maxLength: 10,
              ),
              20.h.verticalSpace,
              GlobalText(
                'Upload Photo',
                textStyle: textStyle16,
                textAlign: TextAlign.start,
              ),
              9.verticalSpace,
              Row(
                children: [
                  GestureDetector(
                    onTap: _fileFieldController.text.isEmpty
                        ? onSelectFileTap
                        : () {},
                    child: Container(
                      height: 80,
                      width: 80,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.blackColor),
                        image: _fileFieldController.text.isEmpty
                            ? null
                            : provider.selectedFile != null
                                ? DecorationImage(
                                    image: FileImage(
                                      File(_fileFieldController.text),
                                    ),
                                  )
                                : DecorationImage(
                                    image:
                                        NetworkImage(_fileFieldController.text),
                                  ),
                      ),
                      child: SvgPicture.asset(
                        provider.selectedFile == null
                            ? AppAssets.addInvoice
                            : AppAssets.zoomIcon,
                      ),
                    ),
                  ),
                  if (_fileFieldController.text.isNotEmpty)
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
              // AppTextField(
              //   name: 'shopImg',
              //   controller: _fileFieldController,
              //   maxLines: 1,
              //   readOnly: true,
              //   labelText: 'Upload shop image',
              //   hintText: 'Select a photo',
              //   bottomText: 'Max File Size:5MB',
              //   onTap: onSelectFileTap,
              //   suffixIcon: _fileFieldController.text.isEmpty
              //       ? IconButton(
              //           onPressed: onSelectFileTap,
              //           icon: SvgIcon(
              //             AppAssets.upload,
              //             color: AppColors.blackColor,
              //             size: 18.sp,
              //           ),
              //         )
              //       : IconButton(
              //           onPressed: () {
              //             _fileFieldController.clear();
              //             provider.clearFile();
              //           },
              //           icon: const Icon(Icons.clear),
              //         ),
              // ),
              60.h.verticalSpace,
              Consumer2<AddShopFormProvider, ChecklistProvider>(
                  builder: (context, provider, checklistProvider, _) {
                return AppButton(
                  isLoading: checklistProvider.isLoading,
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      final Map<String, dynamic> data = {
                        'shop_name': _nameController.text,
                        'shop_location': _locationController.text,
                      };
                      if (widget.shop == null &&
                          _fileFieldController.text.isNotEmpty) {
                        data.addAll(
                          {'shop_image': provider.selectedFile!.path},
                        );
                      }

                      if (widget.shop != null) {
                        data.clear();
                        data.addAll(widget.shop!
                            .copyWith(
                              shopName: _nameController.text,
                              shopLocation: _locationController.text,
                              itemImage: provider.selectedFile?.path,
                            )
                            .toJson());
                      }

                      widget.onSubmit(data);
                      provider.setFile(null);
                    }
                  },
                  text: widget.shop == null ? 'Create' : 'Save',
                  colorType: _nameController.text.isNotEmpty
                      ? AppButtonColorType.primary
                      : AppButtonColorType.greyed,
                );
              }),
              20.h.verticalSpace,
              AppButton(
                onPressed: context.pop,
                text: 'Cancel',
                colorType: AppButtonColorType.secondary,
              ),
            ],
          );
        }),
      ),
    );
  }

  showZoomedImg() {
    showImageSheet(
      context: context,
      imgUrl: _fileFieldController.text,
      onDelete: () {
        _fileFieldController.clear();
        context.read<AddShopFormProvider>().clearFile();
        context.pop();
      },
    );
  }

  onSelectFileTap() async {
    final name = await context.read<AddShopFormProvider>().setFile(
          await ImagePickerhelper().openPicker(context),
        );
    log('file name => $name', name: 'onSelectFileTap');
    if (name != null) {
      _fileFieldController.text = name;
    }
  }

  setFormFields() {
    if (widget.shop == null) return;

    _nameController.text = widget.shop!.shopName;
    _locationController.text = widget.shop!.shopLocation ?? '';
    _fileFieldController.text = widget.shop!.itemImage ?? '';
    setState(() {});
  }
}

class AddShopFormProvider extends ChangeNotifier {
  XFile? _selectedFile;

  XFile? get selectedFile => _selectedFile;

  Future<String?> setFile(XFile? newFile) async {
    log('not sure');
    if (newFile == null) return null;
    log('not returned - notifying');
    _selectedFile = newFile;
    notifyListeners();

    return newFile.path;
  }

  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  }
}
