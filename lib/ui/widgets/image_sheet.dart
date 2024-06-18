import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';

Future<void> showImageSheet({
  required BuildContext context,
  required String imgUrl,
  VoidCallback? onDelete,
}) async {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(10.h),
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
            color: AppColors.blackColor,
            image: imgUrl.startsWith('https://')
                ? DecorationImage(image: NetworkImage(imgUrl))
                : DecorationImage(image: FileImage(File(imgUrl))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton.filled(
                onPressed: context.pop,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.lightGreyColor,
                ),
                icon: const Icon(Icons.clear),
              ),
              if (onDelete != null)
                IconButton.filled(
                  onPressed: onDelete,
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.lightGreyColor,
                  ),
                  icon: const Icon(Icons.delete, color: AppColors.redColor),
                ),
            ],
          ),
        );
      });
}
