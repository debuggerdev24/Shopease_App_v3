import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ReceiptScanProvider extends ChangeNotifier {
  XFile? _selectedFile;
  // final scanner = InvoiceScannerService();
  XFile? get selectedFile => _selectedFile;
  bool isLoading = false;
  List<Map<String, dynamic>> scannedItem = [];

  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  } //

  //todo --------------------> change selected file.
  Future<void> changeSelectedFile(XFile? file, VoidCallback onSuccess,
      VoidCallback onFailed, BuildContext context) async {
    scannedItem.clear();
    isLoading = true;
    notifyListeners();

    _selectedFile = file;
    final data = []; //await scanner.scanInvoiceAndGetData(file!.path, context);
    // onSuccess.call();
    isLoading = false;
    notifyListeners();
    // if (data.isEmpty) {
    //   onFailed.call();
    //   return;
    // }
    // if (data.isNotEmpty) {
    //   log("----receipt scan provider--------> ${data.toString()}");
    //   scannedItem = data;
    //   scannedItem.removeLast();
    //   // getDetailsFromInvoice(file!.path);
    //   onSuccess.call();
    //   isLoading = false;
    //   notifyListeners();
    // }
  }
}
