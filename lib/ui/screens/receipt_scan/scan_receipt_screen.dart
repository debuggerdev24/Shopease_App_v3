import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/providers/receipt_scan_provider.dart';
import 'package:shopease_app_flutter/ui/screens/receipt_scan/upload_receipt_screen.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/ui/widgets/global_text.dart';
import 'package:shopease_app_flutter/utils/styles.dart';

class ScanReceiptScreen extends StatefulWidget {
  const ScanReceiptScreen({super.key});

  @override
  State<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends State<ScanReceiptScreen> {

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
      body: Consumer<ReceiptScanProvider>(
        builder: (context, provider, _) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                40.h.verticalSpace,
                Container(
                  width: 240.w,
                  height: 260.h,
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
                Spacer(),
                20.h.verticalSpace,
                AppButton(
                  onPressed: () {},
                  text: provider.isLoading ? "Scanning..." : "Scanned Successfully.",
                ),
                25.h.verticalSpace
              ],
            ),
          );
        },
      ),
    );
  }
}
