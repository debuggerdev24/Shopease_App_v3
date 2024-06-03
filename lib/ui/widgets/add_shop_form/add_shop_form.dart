import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/checklist_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/app_txt_field.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/image_picker_helper.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class AddShopFormWidget extends StatelessWidget {
  const AddShopFormWidget({
    super.key,
    required this.onSubmit,
  });

  final Function(Map<String, dynamic>) onSubmit;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddShopFormProvider(),
      builder: (context, _) => AddShopForm(onSubmit: onSubmit),
    );
  }
}

class AddShopForm extends StatefulWidget {
  const AddShopForm({
    super.key,
    required this.onSubmit,
  });

  final Function(Map<String, dynamic>) onSubmit;

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
    _nameController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 15.h),
      child: Form(
        key: _formKey,
        child: Consumer<AddShopFormProvider>(builder: (context, provider, _) {
          return Column(
            children: [
              GlobalText('Create New Shop', textStyle: textStyle18SemiBold),
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
              AppTextField(
                name: 'shopImg',
                controller: _fileFieldController,
                maxLines: 1,
                readOnly: true,
                labelText: 'Upload shop image',
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
              60.h.verticalSpace,
              Consumer2<AddShopFormProvider, ChecklistProvider>(
                  builder: (context, provider, checklistProvider, _) {
                return AppButton(
                  isLoading: checklistProvider.isLoading,
                  onPressed: () {
                    if (_formKey.currentState?.validate() == true) {
                      final data = {
                        'shop_name': _nameController.text,
                        'shop_location': _locationController.text,
                      };
                      if (_fileFieldController.text.isNotEmpty) {
                        data.addAll(
                            {'item_image': provider.selectedFile!.path});
                      }
                      widget.onSubmit(data);
                    }
                  },
                  text: 'Create',
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

  onSelectFileTap() async {
    final name = await context.read<AddShopFormProvider>().setFile(
          await ImagePickerhelper().openPicker(context),
        );
    if (name != null) {
      _fileFieldController.text = name;
    }
  }
}

class AddShopFormProvider extends ChangeNotifier {
  XFile? _selectedFile;

  XFile? get selectedFile => _selectedFile;

  Future<String?> setFile(XFile? newFile) async {
    if (newFile == null) return null;
    _selectedFile = newFile;
    notifyListeners();
    return newFile.name;
  }

  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  }
}
