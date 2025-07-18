import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ImagePickerHelper {
  ImagePickerHelper._();

  factory ImagePickerHelper() => ImagePickerHelper._();

  final ImagePicker _picker = ImagePicker();

  Future<XFile?> openPicker(BuildContext context) {
    return showModalBottomSheet<XFile?>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: GlobalText(
                'Upload from',
                textStyle: textStyle14.copyWith(
                  color: AppColors.mediumGreyColor,
                ),
              ),
            ),
            10.h.verticalSpace,
            _buildPickerOptionTile(
              name: 'Gallery',
              iconPath: CupertinoIcons.photo,
              onTap: () async {
                context.pop(await openGallery());
              },
            ),
            20.w.horizontalSpace,
            _buildPickerOptionTile(
              name: 'Camera',
              iconPath: CupertinoIcons.camera,
              onTap: () async {
                context.pop(await openCamera());
              },
            ),
            10.h.verticalSpace,
          ],
        );
      },
    );
  }

  Future<XFile?> openGallery() async {
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 40,
      maxWidth: 700,
      maxHeight: 700,
    );
    return file;
  }

  Future<XFile?> openCamera() async {
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 40,
      maxWidth: 700,
      maxHeight: 700,
    );
    return file;
  }

  _buildPickerOptionTile(
      {required String name, required IconData iconPath, required onTap}) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      onTap: onTap,
      leading: Container(
        height: 50.r,
        width: 50.r,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.whiteColor,
            boxShadow: [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: AppColors.mediumGreyColor)
            ]),
        child: Icon(iconPath),
      ),
      title: GlobalText(name, textStyle: textStyle16SemiBold),
    );
  }
}
