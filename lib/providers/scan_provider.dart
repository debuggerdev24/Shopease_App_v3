import "package:ai_barcode_scanner/ai_barcode_scanner.dart";
import "package:dio/dio.dart";
import 'package:flutter/foundation.dart';
import "package:shopease_app_flutter/models/product_model.dart";
import 'dart:developer';
import "package:shopease_app_flutter/services/scan_service.dart";
import "package:shopease_app_flutter/utils/constants.dart";

enum ScanningStatus { ntg, prepare, scanning, scanned }

class ScannerProvider extends ChangeNotifier {
  ScannerProvider(this.service);

  final BaseScannerService service;

  ScanningStatus _scanningStatus = ScanningStatus.ntg;
  String barcodeResults = 'No Barcode Detected';
  Product? _scannedProduct;
  Product? get scannedProduct => _scannedProduct;
  bool _isLoading = false;

  Uint8List? _scannedCode;
  ScanningStatus get scanningStatus => _scanningStatus;
  Uint8List? get scannedCode => _scannedCode;
  bool get isLoading => _isLoading;

  void changeScanningStatus(ScanningStatus value) {
    _scanningStatus = value;
    log("Scanning status $scanningStatus");
    notifyListeners();
  }

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void setScannedCode(Uint8List? value) {
    _scannedCode = value;
    notifyListeners();
  }

  void changeProduct(Product newProduct) {
    _scannedProduct = newProduct;
    notifyListeners();
  }

  MobileScannerController? _mobileScannerController;
  MobileScannerController? get mobileScanController => _mobileScannerController;
  void initMobileController() {
    _mobileScannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        returnImage: true,
        autoStart: true,
        formats: [BarcodeFormat.all]);
    notifyListeners();
  }

  Future<void> startScanner() async {
    if (_mobileScannerController == null) return;
    log("object ==>  _mobileScannerController.isStarting: ${_mobileScannerController!.isStarting}");

    await _mobileScannerController!.start();
  }

  void disposeScan() {
    if (_mobileScannerController == null) {
      log("object ==> _mobileScannerController == null");
      return;
    }
    _mobileScannerController!.stop();
    _mobileScannerController!.dispose();
    _mobileScannerController = null;
  }

  captureImage(
    BarcodeCapture captureData, {
    VoidCallback? onSuccess,
    Function(String)? onError,
    VoidCallback? onAPISuccess,
    VoidCallback? onAPIError,
  }) async {
    if (captureData.barcodes.isEmpty) {
      // No barcode found, handle this case
      log('No barcode found in the captured image.');
      onError?.call('Not found any product in barcode.');
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

  Future<void> fetchBarcodeData({
    required String barcode,
    VoidCallback? onSuccess,
    Function(String)? onError,
  }) async {
    try {
      setLoading(true);
      final response = await service.scanItem(barcode);

      if (response == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (response.statusCode == 200) {
        final result = Product.fromJson(
            (response.data is List) ? response.data[0] : response.data);
        changeProduct(result);
        onSuccess?.call();
      } else {
        log("Error: ${response.statusCode}");
        onError?.call(response.data['message']);
      }
    } on DioException catch (e) {
      log('error while scanning code : $e');
      onError?.call(e.message ?? Constants.commonErrMsg);
    } catch (e) {
      debugPrint('Error while scanning code: $e');
    } finally {
      setLoading(false);
    }
  }
}
