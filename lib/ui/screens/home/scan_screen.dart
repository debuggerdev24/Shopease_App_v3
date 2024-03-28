import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import '../../../providers/scanner_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen(
      {super.key, required this.isReplace, required this.isInvoice});
  final bool isReplace;
  final bool isInvoice;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AiBarcodeScanner(
        appBar: AppBar(
          title: widget.isInvoice
              ? Text(
                  "Scan & Add Invoice",
                  style: textStyle20SemiBold.copyWith(fontSize: 24),
                )
              : widget.isReplace
                  ? Text(
                      "Scan & Replace",
                      style: textStyle20SemiBold.copyWith(fontSize: 24),
                    )
                  : Text(
                      "Scan & Add",
                      style: textStyle20SemiBold.copyWith(fontSize: 24),
                    ),
        ),
        controller: context.read<ScannerProvider>().mobileScanController,
        onScan: (String value) {},
        canPop: false,
        hapticFeedback: true,
        cutOutBottomOffset: 0,
        bottomBar: const Padding(
          padding: EdgeInsets.all(8.0),
          child: AppButton(
            onPressed: null,
            colorType: AppButtonColorType.secondary,
            text: "Scanning....",
          ),
        ),
        onDispose: () {
          context.read<ScannerProvider>().disposeScan();
        },
        onDetect: (captureData) {
          context.read<ScannerProvider>().captureImage(captureData,
              onSuccess: () {
            log('Capture barcode successfully');
            widget.isInvoice
                ? context.goNamed(AppRoute.saveInvoice.name)
                : widget.isReplace
                    ? context.goNamed(AppRoute.checkList.name)
                    : context.goNamed(AppRoute.home.name);
          }, onError: () {
            log('Not Capture barcode successfully');
            context.goNamed(AppRoute.notifications.name);
          });
        },
        errorColor: AppColors.whiteColor,
        // placeholderBuilder: (context, _) {
        //   return Container(
        //     height: double.infinity,
        //     width: double.infinity,
        //     color: Colors.white,
        //   );
        // },
      ),
    );
  }
}
