import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/extensions/context_ext.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
          alignment: Alignment.topRight,
          decoration: const BoxDecoration(
            color: AppColors.blackColor,
            // image: imgUrl.startsWith('https://')
            //     ? DecorationImage(image: NetworkImage(imgUrl))
            //     : DecorationImage(image: FileImage(File(imgUrl))),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: PhotoView(
                  imageProvider: imgUrl.startsWith('https://')
                      ? NetworkImage(imgUrl)
                      : FileImage(File(imgUrl)) as ImageProvider,
                  minScale: 0.1,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(10.h),
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
                          icon: const Icon(Icons.delete,
                              color: AppColors.redColor),
                        ),
                      if (imgUrl.startsWith("https://"))
                        IconButton.filled(
                          onPressed: () async {
                            debugPrint("URL: - $imgUrl");
                            if (await canLaunchUrlString(imgUrl)) {
                              bool isDone = await launchUrlString(imgUrl);
                              if (isDone && context.mounted) {
                                context.showSuccessMessage("Downloaded");
                              }
                            }
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.lightGreyColor,
                          ),
                          icon: const Icon(Icons.download),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
