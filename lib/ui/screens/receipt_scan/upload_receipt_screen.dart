import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/inventory_provider.dart';
import 'package:shopease_app_flutter/providers/receipt_scan_provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class UploadReceiptScreen extends StatefulWidget {
  const UploadReceiptScreen({super.key});

  @override
  State<UploadReceiptScreen> createState() => _UploadReceiptScreenState();
}

class _UploadReceiptScreenState extends State<UploadReceiptScreen> {
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        context.read<ReceiptScanProvider>().clearFile();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GlobalText(
          "Receipt Scan",
          textStyle: appBarTitleStyle.copyWith(
              fontWeight: FontWeight.w600, fontSize: 24.sp),
        ),
      ),
      backgroundColor: const Color(0xff120202),
      body: Consumer<ReceiptScanProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Column(
              children: [
                70.h.verticalSpace,
                GestureDetector(
                  onTap: () async =>
                      await handleImageUploading(provider, ImageSource.camera),
                  // () async {
                  //   XFile? xFile = await ImagePicker().pickImage(
                  //     source: ImageSource.camera,
                  //   );
                  //   await provider.changeSelectedFile(
                  //     xFile,
                  //     () {
                  //       CustomToast.showSuccess(
                  //           context, "Items Fetched Successfully.");
                  //     },context
                  //   );
                  //   context.pushNamed(AppRoute.scanReceiptScreen.name);
                  //   context.read<InventoryProvider>().putInventoryItem(
                  //         data: provider.scannedItem,
                  //         isEdit: false,
                  //         onError: (msg) => CustomToast.showError(context, msg),
                  //         onSuccess: () {
                  //           // if (!widget.isEdit) {
                  //           CustomToast.showSuccess(
                  //               context, 'Product added successfully!');
                  //           // }
                  //           context
                  //               .read<InventoryProvider>()
                  //               .getInventoryItems();
                  //           context.goNamed(AppRoute.home.name);
                  //         },
                  //       );
                  // },
                  child: Container(
                    width: 220.w,
                    height: 220.h,
                    decoration: BoxDecoration(
                        image: provider.selectedFile != null
                            ? DecorationImage(
                                image: FileImage(
                                  File(provider.selectedFile!.path),
                                ),
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.grey.withValues(alpha: 0.4))
                        ]),
                    child: Stack(
                      children: [
                        // Top-left corner
                        Positioned(
                          top: 0,
                          left: 0,
                          child: buildCornerBracket(
                            isTopLeft: true,
                          ),
                        ),

                        // Top-right corner
                        Positioned(
                          top: 0,
                          right: 0,
                          child: buildCornerBracket(
                            isTopRight: true,
                          ),
                        ),

                        // Bottom-left corner
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: buildCornerBracket(
                            isBottomLeft: true,
                          ),
                        ),

                        // Bottom-right corner
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: buildCornerBracket(
                            isBottomRight: true,
                          ),
                        ),

                        // Center camera icon
                        if (provider.selectedFile == null)
                          Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: .3),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.grey,
                                size: 24,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                80.h.verticalSpace,
                AppButton(
                  colorType: AppButtonColorType.secondary,
                  onPressed: () async =>
                      await handleImageUploading(provider, ImageSource.gallery),
                  text: "Upload from Gallery",
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> handleImageUploading(
      ReceiptScanProvider provider, ImageSource imageSource) async {
    XFile? xFile = await ImagePicker().pickImage(
      source: imageSource,
    );
    await provider.changeSelectedFile(xFile, () {
      CustomToast.showSuccess(context, "Products Fetched Successfully.");
    },(){
      CustomToast.showError(context,
          "Image is not Scannable!");
    } ,context);
    if (provider.scannedItem.isNotEmpty) {
      context.read<InventoryProvider>().putInventoryItem(
            data: provider.scannedItem,
            isEdit: false,
            onError: (msg) => CustomToast.showError(context, msg),
            onSuccess: () {
              // if (!widget.isEdit) {
              CustomToast.showSuccess(context, 'Product added successfully!');
              // }
              context.read<InventoryProvider>().getInventoryItems();
              context.goNamed(AppRoute.home.name);
            },
          );
    }
  }
}

Widget buildCornerBracket({
  bool isTopLeft = false,
  bool isTopRight = false,
  bool isBottomLeft = false,
  bool isBottomRight = false,
}) {
  return CustomPaint(
    size: const Size(40, 40),
    painter: CornerBracketPainter(
      isTopLeft: isTopLeft,
      isTopRight: isTopRight,
      isBottomLeft: isBottomLeft,
      isBottomRight: isBottomRight,
    ),
  );
}

class CornerBracketPainter extends CustomPainter {
  final bool isTopLeft;
  final bool isTopRight;
  final bool isBottomLeft;
  final bool isBottomRight;

  CornerBracketPainter({
    this.isTopLeft = false,
    this.isTopRight = false,
    this.isBottomLeft = false,
    this.isBottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const double bracketLength = 25.0;

    if (isTopLeft) {
      // Top-left corner bracket
      path.moveTo(bracketLength, 0);
      path.lineTo(0, 0);
      path.lineTo(0, bracketLength);
    } else if (isTopRight) {
      // Top-right corner bracket
      path.moveTo(size.width - bracketLength, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, bracketLength);
    } else if (isBottomLeft) {
      // Bottom-left corner bracket
      path.moveTo(0, size.height - bracketLength);
      path.lineTo(0, size.height);
      path.lineTo(bracketLength, size.height);
    } else if (isBottomRight) {
      // Bottom-right corner bracket
      path.moveTo(size.width, size.height - bracketLength);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width - bracketLength, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
