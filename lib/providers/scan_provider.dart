import "package:ai_barcode_scanner/ai_barcode_scanner.dart";
import "package:dio/dio.dart";
import "package:flutter/material.dart";
import 'package:flutter/foundation.dart';
import "package:shopease_app_flutter/Models/product_model.dart";
import 'dart:developer';
import "package:shopease_app_flutter/services/scanner_service.dart";

enum ScanningStatus { ntg, prepare, scanning, scanned }

class ScannerProvider extends ChangeNotifier {
  ScannerProvider(this.service);
// CameraController? _cameraController;
// FlutterBarcodeSdk? _flutterBarcodeSdk;

  final BaseScannerService service;

  ScanningStatus _scanningStatus = ScanningStatus.ntg;
  String barcodeResults = 'No Barcode Detected';
  ProductModel? _scannedProduct;
  ProductModel? get scannedProduct => _scannedProduct;

  Uint8List? _scannedCode;
// CameraController? get cameraController => _cameraController;
// FlutterBarcodeSdk? get flutterBarcodeSdk => _flutterBarcodeSdk;
  ScanningStatus get scanningStatus => _scanningStatus;
  Uint8List? get scannedCode => _scannedCode;

  void changeScanningStatus(ScanningStatus value) {
    _scanningStatus = value;
    log("Scanning status ${scanningStatus}");
    notifyListeners();
  }

  void setScannedCode(Uint8List? value) {
    _scannedCode = value;
    notifyListeners();
  }

  void changeProduct(ProductModel newProduct) {
    _scannedProduct = newProduct;
    notifyListeners();
  }

  MobileScannerController? _mobileScannerController;
  MobileScannerController? get mobileScanController => _mobileScannerController;
  void initMobileController() {
    _mobileScannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        returnImage: true,
        formats: [BarcodeFormat.all]
        // cameraResolution: const Size(300, 300),
        );
    notifyListeners();
  }

  void disposeScan() {
    _mobileScannerController?.dispose();
  }

  captureImage(
    BarcodeCapture captureData, {
    VoidCallback? onSuccess,
    VoidCallback? onError,
    VoidCallback? onAPISuccess,
    VoidCallback? onAPIError,
  }) async {
    if (captureData.barcodes.isEmpty) {
      // No barcode found, handle this case
      log('No barcode found in the captured image.');
      onError?.call();
      return; // Exit the function early since there's nothing more to do.
    }

    log('capturedData:: $captureData');
    barcodeResults = getBarcodeData(captureData.barcodes);

    log("Caputure data with barcode:$barcodeResults");
    await fetchBarcodeData(
      barcode: barcodeResults,
      onError: onError,
      onSuccess: onSuccess,
    );

    setScannedCode(captureData.image);
    changeScanningStatus(ScanningStatus.scanned);
    // getProductInfo(barcodeResults);
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

  // Future<ProductModel> fetchBarcodeData(
  //   String barcode,
  // ) async {
  //   ProductModel? result;
  //   String apiKey = "taro7zm1s49u1hej0a146zj2tdy6tw";

  //   try {
  //     final Uri uri = Uri.parse(
  //         'https://api.barcodelookup.com/v3/products?barcode=$barcode&formatted=y&key=$apiKey');

  //     final response =
  //         await http.get(uri, headers: {"Content-Type": "application/json"});

  //     print("Response status code: ${response.statusCode}");
  //     print("Response body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       final item = json.decode(response.body);
  //       result = ProductModel.fromJson(item);
  //       return result;

  //     } else {
  //       print("Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  Future<void>  fetchBarcodeData({
    required String barcode,
    VoidCallback? onSuccess,
    VoidCallback? onError,
  }) async {
    try {
      final response = await service.getScannedData(barcode);

      log("Response status code: ${response.statusCode}");
      log("Response body: ${response.data}");

      if (response.statusCode == 200) {
        final result = ProductModel.fromJson(response.data);
        changeProduct(result);
        onSuccess?.call();
      } else {
        log("Error: ${response.statusCode}");
        onError?.call();
      }
    } on DioException catch (e) {
      log('error while scanning code : $e');
      onError?.call();
    } catch (e) {
      log('Error while scanning code: $e');
      onError?.call();
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
