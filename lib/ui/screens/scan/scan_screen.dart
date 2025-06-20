import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shopease_app_flutter/ui/widgets/app_button.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import '../../../providers/scan_provider.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({
    super.key,
    this.isReplace = false,
    // this.isInvoice = false,
    this.isFromChecklist = false,
    this.oldChecklistItemId,
  });
  final bool isReplace;
  // final bool isInvoice;
  final bool isFromChecklist;
  final String? oldChecklistItemId;

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ScannerProvider>(builder: (context, provider, _) {
        return provider.mobileScanController == null || provider.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : AiBarcodeScanner(
                appBar: AppBar(
                    title: Text(
                  /*widget.isInvoice
                      ? "Scan & Add Invoice"
                      :*/
                  widget.isReplace ? "Scan & Replace" : "Scan & Add",
                  style: textStyle20SemiBold.copyWith(fontSize: 24),
                )),
                controller: provider.mobileScanController,
                onScan: (String value) {
                  log('scanned data : $value');
                },
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
                  provider.disposeScan();
                },
                onDetect: (captureData) async {
                  if (provider.mobileScanController == null) return;
                  provider.mobileScanController!.dispose();
                  await provider.captureImage(
                    captureData,
                    onSuccess: () {
                      log('Capture barcode successfully');
                      /*widget.isInvoice
                          ? context.goNamed(AppRoute.saveInvoice.name)
                          :*/
                      /*widget.isReplace
                          ? context.goNamed(AppRoute.checkList.name)
                          :*/
                      widget.isFromChecklist
                          ? context
                              .goNamed(AppRoute.addChecklistForm.name, extra: {
                              'isEdit': false,
                              'isFromScan': true,
                              'isReplace': widget.isReplace,
                              'details': provider.scannedProduct,
                              'oldId': widget.oldChecklistItemId,
                            })
                          : context
                              .goNamed(AppRoute.addInventoryForm.name, extra: {
                              'isEdit': false,
                              'isFromScan': true,
                              'details': provider.scannedProduct,
                            });
                    },
                    onError: (msg) {
                      context.pushReplacementNamed(
                        AppRoute.scanNotFoundScreen.name,
                        extra: {
                          'isReplace': widget.isReplace,
                          'oldId': widget.oldChecklistItemId,
                          'isFromChecklist': widget.isFromChecklist,
                        },
                      );
                    },
                  );
                },
                errorColor: AppColors.whiteColor,
              );
      }),
    );
  }
}
