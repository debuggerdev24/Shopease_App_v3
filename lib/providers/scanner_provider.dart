import "dart:convert";

import "package:ai_barcode_scanner/ai_barcode_scanner.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import 'package:flutter/foundation.dart';
import 'dart:developer';

import "package:shopease_app_flutter/utils/enums/product_detail.dart";

enum ScanningStatus { ntg, prepare, scanning, scanned }

class ScannerProvider extends ChangeNotifier {
// CameraController? _cameraController;
// FlutterBarcodeSdk? _flutterBarcodeSdk;
  ScanningStatus _scanningStatus = ScanningStatus.ntg;
  String barcodeResults = 'No Barcode Detected';

  Uint8List? _scannedCode;
// CameraController? get cameraController => _cameraController;
// FlutterBarcodeSdk? get flutterBarcodeSdk => _flutterBarcodeSdk;
  ScanningStatus get scanningStatus => _scanningStatus;
  Uint8List? get scannedCode => _scannedCode;

  void changeScanningStatus(ScanningStatus value) {
    _scanningStatus = value;
    log("Scanning stayus ${scanningStatus}");
    notifyListeners();
  }

  void setScannedCode(Uint8List? value) {
    _scannedCode = value;
    notifyListeners();
  }

  MobileScannerController? _mobileScannerController;
  MobileScannerController? get mobileScanController => _mobileScannerController;
  void initMobileController() {
    _mobileScannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: true,
      // cameraResolution: const Size(300, 300),
    );
  }

  void disposeScan() {
    _mobileScannerController?.dispose();
  }

  captureImage(BarcodeCapture captureData,
      {VoidCallback? onSuccess, VoidCallback? onError}) {
    if (captureData.barcodes.isEmpty) {
      // No barcode found, handle this case
      log('No barcode found in the captured image.');
      onError?.call();
      return; // Exit the function early since there's nothing more to do.
    }

    log('capturedData:: $captureData');
    barcodeResults = getBarcodeData(captureData.barcodes);

    log("Caputure data with barcode:${barcodeResults}");
    setScannedCode(captureData.image);
    changeScanningStatus(ScanningStatus.scanned);
    // getProductInfo(barcodeResults);
    onSuccess?.call();
  }

  String getBarcodeData(List<Barcode> barcodes) {
    log('barcodes: ${barcodes.first.displayValue}');
    if (barcodes.isNotEmpty) {
      log('data-rawBytes: ${barcodes.first.rawBytes}');
      log('data-displ: ${barcodes.last.displayValue}');

      log('data-rawValue: ${barcodes.first.rawValue}');

      log('data-displayValue: ${barcodes.first.displayValue}');
      log('data-format: ${barcodes.first.format}');

      log('data-type: ${barcodes.first.type.name}');
      log('data-corners: ${barcodes.first.corners}');

      return barcodes.first.rawValue ?? 'No Barcode Detected';
    } else {
      return 'No Barcode Detected';
    }
  }

  // void getProductInfo(String barcodeValue) {
  //   // Assuming you have a mapping of barcode values to product information
  //   Map<String, Product> productMap = {
  //     '8901719101038': Product(name: 'Parle G', price: 10.99),
  //     '4007993012504	': Product(name: 'IceCream', price: 20.99),
  //     // Add more mappings as needed
  //   };

  //   // Lookup the barcode value in the product map
  //   Product? product = productMap[barcodeValue];

  //   if (product != null) {
  //     // Product found for the scanned barcode
  //     log('Product Name: ${product.name}');
  //     log('Product Price: \$${product.price}');
  //     // You can further process the product information here as needed
  //   } else {
  //     // Product information not found for the scanned barcode
  //     log('Product information not found for the scanned barcode.');
  //   }
  // }
}
