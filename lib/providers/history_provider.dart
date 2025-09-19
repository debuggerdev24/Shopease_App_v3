import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/history_item_detail_model.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/services/history_service.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HistoryProvider extends ChangeNotifier {
  final BaseHistoryService service;

  HistoryProvider(this.service);

  bool _isLoading = false;

  final List<History> _histories = [];
  final List<History> _filteredHistories = [];
  final List<int> _selectedFilterMonth = [];
  List<HistoryItemDetail> _historyItemDetails = [];
  final List<HistoryItemDetail> _selectedHistoryItemDetails = [];
  int _selectedValue = -1;
  XFile? _selectedFile;
  DateTime? _fromDate;
  bool _selecthistory = false;
  DateTime _toDate = DateTime.now();

  final List<String> _selectedShopFilter = [];

  bool get isLoading => _isLoading;

  List<History> get histories => _histories;

  List<History> get filteredHistories => _filteredHistories;

  List<int> get selectedFilterMonth => _selectedFilterMonth;

  List<HistoryItemDetail> get historyItemDetails => _historyItemDetails;

  List<HistoryItemDetail> get selectedHistoryItemDetails =>
      _selectedHistoryItemDetails;

  int get selectedValueIndex => _selectedValue;

  XFile? get selectedFile => _selectedFile;

  DateTime? get fromDate => _fromDate;

  DateTime? get toDate => _toDate;

  bool get selecthistory => _selecthistory;

  List<String> get selectedShopFilter => _selectedShopFilter;
  String scannedText = "", totalAmount = "";
  // List<Map<String, dynamic>> scannedItem = [];

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void clearFile() {
    _selectedFile = null;
    scannedText = "";
    totalAmount = "";
    notifyListeners();
  }

  void changeSelectedValue(int newIndex) {
    _selectedValue = newIndex;
    notifyListeners();
  }

  void changeShopFilter(String newFilter) {
    if (_selectedShopFilter.contains(newFilter)) {
      _selectedShopFilter.remove(newFilter);
    } else {
      _selectedShopFilter.add(newFilter);
    }

    notifyListeners();
  }

  void changeHistoryFilter(int month) {
    if (_selectedFilterMonth.contains(month)) {
      _selectedFilterMonth.remove(month);
    } else {
      _selectedFilterMonth.add(month);
    }
    notifyListeners();
  }

  void clearHistoryFilters() {
    _selectedFilterMonth.clear();
    notifyListeners();
  }

  void changeSelectedHistoryItemDetails(
      bool? value, HistoryItemDetail itemDetail) {
    if (value == true) {
      _selectedHistoryItemDetails.add(itemDetail);
    } else {
      _selectedHistoryItemDetails.remove(itemDetail);
    }
    notifyListeners();
  }

  void clearSelectedHistoryItemDetails() {
    _selectedHistoryItemDetails.clear();
    notifyListeners();
  }

  void filterHistories() {
    _filteredHistories.clear();
    _selecthistory = false;
    if (_fromDate == null || _toDate == DateTime.now()) {
      _filteredHistories.addAll(_histories);
    } else {
      _filteredHistories.addAll(
        _histories.where(
          (element) {
            final evaluateDateFiler =
                (element.updatedDate?.isAfter(_fromDate!) ?? false) &&
                    ((element.updatedDate?.isBefore(_toDate) ?? false) ||
                        (element.updatedDate?.day ?? 0) <= _toDate.day);
            if (_selectedShopFilter.isEmpty) {
              return evaluateDateFiler;
            }

            final evaluateShopFilter =
                _selectedShopFilter.contains(element.shopName);
            return evaluateShopFilter && evaluateDateFiler;
          },
        ),
      );
      _selecthistory = true;
    }

    notifyListeners();
  }

  void setFromDate(DateTime? newDate) {
    if (newDate == null) return;
    _fromDate = newDate;
    notifyListeners();
  }

  void resetToData() {
    _toDate = DateTime.now();
    notifyListeners();
  }

  void setToDate(DateTime? newDate, {Function(String)? onError}) {
    if (newDate == null) return;
    bool isAcceptable = (_fromDate?.isBefore(newDate) ?? false) ||
        (_fromDate?.day ?? 0) <= newDate.day;
    if (isAcceptable) {
      _toDate = newDate;

      notifyListeners();
    } else {
      onError?.call('Make sure To date is not before the From date');
    }
  }

  //todo --------------------> change selected file.
  Future<void> changeSelectedFile(XFile? file, BuildContext context) async {
    _selectedFile = file;
    // scannedItem = await InvoiceScannerService().scanInvoiceAndGetData(file!.path, context);//getDetailsFromInvoice(file!.path);
    notifyListeners();
  }

  //todo --------------------> get total amount.
  // String? extractInvoiceTotalAmount(String scannedText) {
  //   final lines = scannedText.split('\n');
  //
  //   // Total-related keywords to include
  //   final totalKeywords = [
  //     'total:',
  //     'grand total',
  //     'total',
  //     'amount due',
  //   ];
  //
  //   // Exclude lines that are subtotal
  //   final excludeKeywords = ['sub total', 'subtotal'];
  //
  //   for (final line in lines.reversed) {
  //     final lowerLine = line.toLowerCase();
  //
  //     // Skip if it contains excluded keywords like 'sub total'
  //     if (excludeKeywords.any((keyword) => lowerLine.contains(keyword))) {
  //       continue;
  //     }
  //
  //     // Proceed only if it has a valid total keyword
  //     if (totalKeywords.any((keyword) => lowerLine.contains(keyword))) {
  //       final match = RegExp(r'(\$)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
  //           .allMatches(line)
  //           .toList();
  //
  //       if (match.isNotEmpty) {
  //         return match.last.group(0);
  //       }
  //     }
  //   }
  //
  //   return null; // Not found
  // }

  // List<Map<String, dynamic>> extractFlexibleInvoiceItems(String scannedText) {
  //   final lines = scannedText.split('\n');
  //
  //   final List<Map<String, dynamic>> extractedItems = [];
  //
  //   bool startedItems = false;
  //
  //   for (var i = 0; i < lines.length; i++) {
  //     final line = lines[i].trim();
  //
  //     // Skip empty lines
  //     if (line.isEmpty) continue;
  //
  //     // Start when we suspect items section is beginning
  //     if (!startedItems &&
  //         (line.toLowerCase().contains("sl") ||
  //             line.toLowerCase().contains("item") ||
  //             line.toLowerCase().contains("description") ||
  //             RegExp(r"\$\d+").hasMatch(line))) {
  //       startedItems = true;
  //       continue;
  //     }
  //
  //     if (startedItems) {
  //       // Stop when footer or total section starts
  //       if (line.toLowerCase().contains("thank you") ||
  //           line.toLowerCase().contains("sub total") ||
  //           line.toLowerCase().contains("total:") ||
  //           line.toLowerCase().contains("payment") ||
  //           line.toLowerCase().contains("account")) {
  //         break;
  //       }
  //
  //       final priceMatches =
  //           RegExp(r"\$\d+(?:\.\d{2})?").allMatches(line).toList();
  //       final numberMatches = RegExp(r"\b\d+\b").allMatches(line).toList();
  //
  //       if (priceMatches.isNotEmpty && numberMatches.isNotEmpty) {
  //         final totalPrice = priceMatches.last.group(0)!;
  //         final unitPrice =
  //             priceMatches.length > 1 ? priceMatches.first.group(0)! : "";
  //
  //         String qty = "1";
  //         if (numberMatches.length > 1) {
  //           qty = numberMatches[1].group(0)!;
  //         } else if (numberMatches.length == 1) {
  //           qty = numberMatches[0].group(0)!;
  //         }
  //
  //         // Try to extract SL (only if more than one number)
  //         final sl = numberMatches.length > 1 ? numberMatches[0].group(0)! : "";
  //
  //         // Remove known values to estimate description
  //         String description = line
  //             .replaceAll(unitPrice, '')
  //             .replaceAll(totalPrice, '')
  //             .replaceAll(qty, '')
  //             .replaceAll(sl, '')
  //             .replaceAll(RegExp(r"\s+"), ' ')
  //             .trim();
  //
  //         extractedItems.add({
  //           'sl': sl,
  //           'product_name': description,
  //           "brand": "Brand Name",
  //           "is_in_checklist": false,
  //           'price': unitPrice,
  //           "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
  //           'in_stock_quantity':
  //               (qty == "0" || qty.isEmpty || qty == "00") ? "1" : qty,
  //           'total': totalPrice,
  //           "item_category": "Other"
  //         });
  //       }
  //     }
  //   }
  //
  //   return extractedItems;
  // }

  //todo -------------------> check image is scannable or not.
  // bool isImageScannable(RecognizedText recognizedText) {
  //   final allLines = recognizedText.blocks.expand((b) => b.lines).toList();
  //   final allElements = allLines.expand((l) => l.elements).toList();
  //
  //   bool hasText = recognizedText.text.trim().isNotEmpty;
  //   bool hasEnoughLines = allLines.length >= 3;
  //   bool hasInvoiceKeywords =
  //       recognizedText.text.toLowerCase().contains('invoice') ||
  //           recognizedText.text.contains('\$') ||
  //           recognizedText.text.toLowerCase().contains('total');
  //
  //   return hasText && (hasEnoughLines || hasInvoiceKeywords);
  // }

  // todo --------------------------------------> get details from the invoice
  // Future<void> getDetailsFromInvoice(String filePath) async {
  //   final inputImage = InputImage.fromFilePath(filePath);
  //   final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  //   final RecognizedText recognizedText =
  //       await textRecognizer.processImage(inputImage);
  //   scannedText = recognizedText.text;
  //   log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;$scannedText");
  //   notifyListeners();
  //
  //   if (!isImageScannable(recognizedText)) {
  //     log("Image is not Scannable!");
  //     return;
  //   }
  //   List<Map<String, dynamic>> elements = [];
  //
  //   for (final block in recognizedText.blocks) {
  //     for (final line in block.lines) {
  //       for (final element in line.elements) {
  //         elements.add({
  //           'text': element.text,
  //           'left': element.boundingBox.left,
  //           'top': element.boundingBox.top,
  //           'bottom': element.boundingBox.bottom,
  //           'right': element.boundingBox.right,
  //           'centerY':
  //               (element.boundingBox.top + element.boundingBox.bottom) / 2,
  //         });
  //       }
  //     }
  //   }
  //
  //   /// Group elements into rows based on Y center alignment
  //   const double verticalTolerance = 12.0; // adjust this based on font size
  //   Map<int, List<Map<String, dynamic>>> groupedRows = {};
  //
  //   for (var element in elements) {
  //     int key = (element['centerY'] / verticalTolerance).round();
  //     groupedRows.putIfAbsent(key, () => []).add(element);
  //   }
  //
  //   /// Sort rows by vertical Y value and elements within row by X
  //   List<int> sortedRowKeys = groupedRows.keys.toList()..sort();
  //   String formattedText = '';
  //
  //   for (int rowKey in sortedRowKeys) {
  //     List<Map<String, dynamic>> row = groupedRows[rowKey]!;
  //
  //     // Sort by horizontal position
  //     row.sort((a, b) => a['left'].compareTo(b['left']));
  //
  //     String line = row.map((e) => e['text']).join(' ');
  //     formattedText += '$line\n';
  //   }
  //
  //   scannedText = formattedText.trim();
  //   totalAmount = extractInvoiceTotalAmount(scannedText)!;
  //   log("Formatted text (line-wise):\n$scannedText");
  //
  //   await textRecognizer.close();
  //
  //   scannedItem = extractFlexibleInvoiceItems(scannedText);
  //   notifyListeners();
  //   for (final item in scannedItem) {
  //     log("Item: ${item['description']}, Qty: ${item['in_stock_quantity']}, Price: ${item['price']}, Total: ${item['total']}");
  //   }
  // }

  Future<void> selectFileFromGallery(
      {VoidCallback? onSuccess, required BuildContext context}) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    _selectedFile = file;
    changeSelectedFile(file, context);
    notifyListeners();
    onSuccess?.call();
  }

  Future<void> selectFileFromCamera({VoidCallback? onSuccess}) async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return;
    _selectedFile = file;
    notifyListeners();
    onSuccess?.call();
  }

  Future<void> getHistoryItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getHistoryItems();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _histories.clear();
        _histories.addAll((res.data as List).map((e) => History.fromJson(e)));
        _histories.sort(
          (a, b) =>
              b.updatedDate?.compareTo(a.updatedDate ?? DateTime(0)) ?? -1,
        );
        filterHistories();
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getHistoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> getHistoryItemDetails({
    required List<String> histIds,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getHistoryItemDetails(histIds: histIds);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _historyItemDetails = (res.data as List)
            .map((e) => HistoryItemDetail.fromJson(e))
            .toList();
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getHistoryItemDetails: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> puthistoryItems({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putHistoryItems(data: data, isEdit: isEdit);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while puthistoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putChecklistFromHistory({
    required List<Map<String, dynamic>> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putChecklistFromHistory(histDetails: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while putChecklistFromHistory: $e");
    } finally {
      setLoading(false);
    }
  }

  final List<Map<String, String>> valueList = [
    {
      'name': 'Value 1',
    },
    {
      'name': 'Value 2',
    },
    {
      'name': 'Value 3',
    },
  ];
}
