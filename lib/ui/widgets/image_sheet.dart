import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:go_router/go_router.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/extensions/context_ext.dart';

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
                            await _saveNetworkImage(imgUrl, context);
                            // if (await canLaunchUrlString(imgUrl)) {
                            //   bool isDone = await launchUrlString(imgUrl);
                            //   if (isDone && context.mounted) {
                            //     context.showSuccessMessage("Downloaded");
                            //   }
                            // }
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

_saveNetworkImage(String url, BuildContext context) async {
  try {
    var response = await Dio().get(
      url,
      options: Options(responseType: ResponseType.bytes),
    );

    // final result = await GallerySaver.saveImage(
    //   Uint8List.fromList(response.data),
    //   quality: 60,
    //   name: '${DateTime.now().millisecondsSinceEpoch}',
    // );
    // log(result);

    final dir = await getTemporaryDirectory();
    // Create an image name
    var filename = '${dir.path}/image.png';
    // Save to filesystem
    final file = File(filename);
    await file.writeAsBytes(response.data);

    await GallerySaver.saveImage(file.path, albumName: 'Shopease')
        .then((bool? success) {
      log('success => $success');
      if (success == true) {
        context.showSuccessMessage('Downloaded successfully.');
      } else {
        context.showErrorMessage('Something went wrong.');
      }
    });
  } catch (e) {
    log('error while downloading => $e');
  }
}
