// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
//
// class InvoiceScannerService {
//   static final InvoiceScannerService _instance = InvoiceScannerService._internal();
//   factory InvoiceScannerService() => _instance;
//   InvoiceScannerService._internal();
//
//   String scannedText = '';
//   String totalAmount = '';
//   List<Map<String, dynamic>> scannedItem = [];
//
//   //todo --------------------> get total amount.
//   String? extractInvoiceTotalAmount(String scannedText) {
//     final lines = scannedText.split('\n');
//
//     // Total-related keywords to include
//     final totalKeywords = [
//       'total:',
//       'grand total',
//       'total',
//       'amount due',
//       'net total',
//       'final total',
//       'balance',
//       'amount',
//       'sum',
//       'due',
//     ];
//
//     // Exclude lines that are subtotal
//     final excludeKeywords = ['sub total', 'subtotal', 'tax', 'discount'];
//
//     for (final line in lines.reversed) {
//       final lowerLine = line.toLowerCase();
//
//       // Skip if it contains excluded keywords like 'sub total'
//       if (excludeKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         continue;
//       }
//
//       // Proceed only if it has a valid total keyword
//       if (totalKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         final match = RegExp(r'(\$|₹|€|£|¥)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
//             .allMatches(line)
//             .toList();
//
//         if (match.isNotEmpty) {
//           return match.last.group(0);
//         }
//       }
//     }
//
//     // Fallback: Find the largest amount in the text (likely the total)
//     final allAmounts = RegExp(r'(\$|₹|€|£|¥)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
//         .allMatches(scannedText)
//         .map((match) => match.group(0)!)
//         .toList();
//
//     if (allAmounts.isNotEmpty) {
//       // Convert to double for comparison, handle currency symbols
//       double maxAmount = 0;
//       String maxAmountString = '';
//
//       for (String amount in allAmounts) {
//         final numericString = amount.replaceAll(RegExp(r'[^\d.]'), '');
//         final numericValue = double.tryParse(numericString) ?? 0;
//         if (numericValue > maxAmount) {
//           maxAmount = numericValue;
//           maxAmountString = amount;
//         }
//       }
//
//       return maxAmountString.isNotEmpty ? maxAmountString : null;
//     }
//
//     return null; // Not found
//   }
//
//   // NEW: Find the index where items section ends and footer begins
//   int _findItemsSectionEndIndex(List<String> lines) {
//     for (int i = 0; i < lines.length; i++) {
//       final line = lines[i].toLowerCase().trim();
//
//       // Strong indicators of footer/summary section
//       if (line.contains('sub total') ||
//           line.contains('subtotal') ||
//           line.contains('tax') ||
//           line.contains('discount') ||
//           line.contains('total:') ||
//           line.contains('grand total') ||
//           line.contains('net total') ||
//           line.contains('amount due') ||
//           line.contains('payment') ||
//           line.contains('thank you') ||
//           line.contains('visit us') ||
//           line.contains('customer service') ||
//           line.contains('return policy') ||
//           line.contains('exchange policy') ||
//           line.contains('terms and conditions') ||
//           line.contains('account number') ||
//           line.contains('card number') ||
//           line.contains('transaction id') ||
//           line.contains('receipt number') ||
//           line.contains('invoice number') ||
//           line.contains('cashier') ||
//           line.contains('signature') ||
//           line.contains('balance') ||
//           line.contains('change') ||
//           line.contains('tendered') ||
//           line.startsWith('www.') ||
//           line.contains('http') ||
//           line.contains('.com') ||
//           line.contains('.net') ||
//           line.contains('.org') ||
//           RegExp(r'^\d{4,}$').hasMatch(line.trim()) || // Long numeric codes
//           RegExp(r'^[a-z0-9]+@[a-z0-9]+\.[a-z]{2,}$').hasMatch(line.trim()) // Email
//       ) {
//         return i;
//       }
//     }
//     return lines.length; // If no footer found, process all lines
//   }
//
//   // NEW: Enhanced validation for actual item lines
//   bool _isValidItemLine(String line, int lineIndex, List<String> allLines) {
//     final lowerLine = line.toLowerCase().trim();
//
//     // Skip empty lines
//     if (lowerLine.isEmpty) return false;
//
//     // IMPORTANT: Skip total-related lines first
//     if (_isTotalLine(line)) {
//       return false;
//     }
//
//     // Skip header lines
//     if (lowerLine.contains('item') && lowerLine.contains('qty') && lowerLine.contains('price')) {
//       return false;
//     }
//
//     // Skip lines that are clearly not items
//     if (lowerLine.contains('description') ||
//         lowerLine.contains('quantity') ||
//         lowerLine.contains('unit price') ||
//         lowerLine.contains('total price') ||
//         lowerLine.contains('sl no') ||
//         lowerLine.contains('s.no') ||
//         lowerLine.contains('sr no') ||
//         lowerLine.startsWith('---') ||
//         lowerLine.startsWith('===') ||
//         lowerLine.startsWith('___')) {
//       return false;
//     }
//
//     // Must have at least one price pattern
//     final priceMatches = RegExp(r'(\$|₹|€|£|¥)?\d+(?:\.\d{2})?').allMatches(line);
//     if (priceMatches.isEmpty) return false;
//
//     // Must have some text that could be a product name
//     String textWithoutPrices = line;
//     for (final match in priceMatches) {
//       textWithoutPrices = textWithoutPrices.replaceAll(match.group(0)!, '');
//     }
//
//     final cleanText = textWithoutPrices.replaceAll(RegExp(r'\d+'), '').trim();
//     if (cleanText.length < 2) return false;
//
//     // Additional validation: check if this line has the structure of an item
//     final words = cleanText.split(RegExp(r'\s+'));
//     if (words.length < 1) return false;
//
//     return true;
//   }
//
//   //todo --------------------> Enhanced flexible item extraction
//   List<Map<String, dynamic>> extractFlexibleInvoiceItems(String scannedText) {
//     final lines = scannedText.split('\n');
//     final List<Map<String, dynamic>> extractedItems = [];
//
//     // Find where items section ends
//     final itemsEndIndex = _findItemsSectionEndIndex(lines);
//     final itemsLines = lines.sublist(0, itemsEndIndex);
//
//     // Try structured extraction first
//     final structuredItems = _extractStructuredItems(itemsLines);
//     if (structuredItems.isNotEmpty) {
//       return structuredItems;
//     }
//
//     // Fallback to unstructured extraction
//     return _extractUnstructuredItems(itemsLines);
//   }
//
//   // Updated structured extraction method
//   List<Map<String, dynamic>> _extractStructuredItems(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//     bool startedItems = false;
//
//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i].trim();
//
//       // Skip empty lines
//       if (line.isEmpty) continue;
//
//       // Start when we suspect items section is beginning
//       if (!startedItems &&
//           (line.toLowerCase().contains("sl") ||
//               line.toLowerCase().contains("item") ||
//               line.toLowerCase().contains("description") ||
//               line.toLowerCase().contains("product") ||
//               RegExp(r"(\$|₹|€|£|¥)\d+").hasMatch(line))) {
//         startedItems = true;
//         continue;
//       }
//
//       if (startedItems) {
//         // Use the enhanced validation
//         if (!_isValidItemLine(line, i, lines)) {
//           continue;
//         }
//
//         final priceMatches =
//         RegExp(r"(\$|₹|€|£|¥)?\d+(?:\.\d{2})?").allMatches(line).toList();
//         final numberMatches = RegExp(r"\b\d+\b").allMatches(line).toList();
//
//         if (priceMatches.isNotEmpty && numberMatches.isNotEmpty) {
//           final totalPrice = priceMatches.last.group(0)!;
//           final unitPrice =
//           priceMatches.length > 1 ? priceMatches.first.group(0)! : totalPrice;
//
//           String qty = "1";
//           if (numberMatches.length > 1) {
//             qty = numberMatches[1].group(0)!;
//           } else if (numberMatches.length == 1) {
//             qty = numberMatches[0].group(0)!;
//           }
//
//           // Try to extract SL (only if more than one number)
//           final sl = numberMatches.length > 1 ? numberMatches[0].group(0)! : "";
//
//           // Remove known values to estimate description
//           String description = line
//               .replaceAll(unitPrice, '')
//               .replaceAll(totalPrice, '')
//               .replaceAll(qty, '')
//               .replaceAll(sl, '')
//               .replaceAll(RegExp(r"\s+"), ' ')
//               .trim();
//
//           // Additional validation for description
//           if (description.length < 2) {
//             continue;
//           }
//
//           extractedItems.add({
//             'sl': sl,
//             'product_name': description.isEmpty ? "Product Description" : description,
//             "brand": "Brand Name",
//             "is_in_checklist": false,
//             'price': unitPrice,
//             "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//             'in_stock_quantity':
//             (qty == "0" || qty.isEmpty || qty == "00") ? "1" : qty,
//             'total': totalPrice,
//             "item_category": "Other"
//           });
//         }
//       }
//     }
//
//     return extractedItems;
//   }
//
//   // Updated unstructured extraction method
//   List<Map<String, dynamic>> _extractUnstructuredItems(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//     final Set<String> processedLines = {}; // To avoid duplicates
//
//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i].trim();
//
//       // Skip empty lines or already processed lines
//       if (line.isEmpty || processedLines.contains(line)) continue;
//
//       // Use enhanced validation
//       if (!_isValidItemLine(line, i, lines)) continue;
//
//       // Look for lines that might contain product information
//       final item = _extractItemFromLine(line, i, lines);
//       if (item != null) {
//         extractedItems.add(item);
//         processedLines.add(line);
//       }
//     }
//
//     // If still no items found, try aggressive extraction
//     if (extractedItems.isEmpty) {
//       return _aggressiveItemExtraction(lines);
//     }
//
//     return extractedItems;
//   }
//
//   // Updated check for non-item lines
//   bool _isNonItemLine(String line) {
//     final lowerLine = line.toLowerCase();
//
//     // First check if it's a total line
//     if (_isTotalLine(line)) {
//       return true;
//     }
//
//     final skipKeywords = [
//       'thank you',
//       'receipt',
//       'invoice',
//       'bill',
//       'date',
//       'time',
//       'cashier',
//       'customer',
//       'phone',
//       'email',
//       'address',
//       'store',
//       'shop',
//       'card',
//       'account',
//       'terms',
//       'conditions',
//       'return',
//       'exchange',
//       'policy',
//       'www.',
//       'http',
//       '.com',
//       '.net',
//       '.org',
//       'visit',
//       'follow',
//       'like',
//       'signature',
//       'transaction',
//       'receipt no',
//       'invoice no',
//       'bill no',
//       'order no',
//       'ref no',
//       'transaction id',
//       'gstin',
//       'gst',
//       'vat',
//       'service tax',
//       'customer service',
//       'helpline',
//       'support',
//       'approval code',
//       'bank card',
//       'card number',
//       'account number',
//     ];
//
//     return skipKeywords.any((keyword) => lowerLine.contains(keyword)) ||
//         lowerLine.length < 3 ||
//         RegExp(r'^\d{1,2}[:/]\d{1,2}[:/]\d{2,4}$').hasMatch(line) || // Date
//         RegExp(r'^\d{1,2}:\d{2}(:\d{2})?\s*(AM|PM)?$').hasMatch(lowerLine) || // Time
//         RegExp(r'^\d{4,}$').hasMatch(line.trim()) || // Long numeric codes
//         RegExp(r'^[a-z0-9]+@[a-z0-9]+\.[a-z]{2,}$').hasMatch(lowerLine); // Email
//   }
//
//   // Extract item from a single line
//   Map<String, dynamic>? _extractItemFromLine(String line, int index, List<String> allLines) {
//     // Skip if this is a total line
//     if (_isTotalLine(line)) {
//       return null;
//     }
//
//     // Look for price patterns
//     final priceMatches = RegExp(r'(\$|₹|€|£|¥)?\d+(?:\.\d{2})?').allMatches(line).toList();
//
//     if (priceMatches.isEmpty) return null;
//
//     // Get numbers (potential quantities)
//     final numberMatches = RegExp(r'\b\d+\b').allMatches(line).toList();
//
//     String productName = line;
//     String price = priceMatches.last.group(0)!;
//     String quantity = "1";
//     String total = price;
//
//     // Try to determine quantity
//     if (numberMatches.length >= 2) {
//       // If we have multiple numbers, try to identify quantity
//       final numbers = numberMatches.map((m) => m.group(0)!).toList();
//
//       // Remove price numbers from consideration
//       final priceNumbers = priceMatches.map((m) => m.group(0)!.replaceAll(RegExp(r'[^\d.]'), '')).toList();
//       final potentialQuantities = numbers.where((num) => !priceNumbers.contains(num)).toList();
//
//       if (potentialQuantities.isNotEmpty) {
//         final qtyValue = int.tryParse(potentialQuantities.first) ?? 1;
//         // Reasonable quantity check
//         if (qtyValue > 0 && qtyValue < 1000) {
//           quantity = potentialQuantities.first;
//         }
//       }
//     }
//
//     // Clean product name by removing prices and quantities
//     productName = line;
//     for (final match in priceMatches) {
//       productName = productName.replaceAll(match.group(0)!, '');
//     }
//
//     // Remove quantity if it's clearly separate
//     if (quantity != "1" && productName.contains(quantity)) {
//       productName = productName.replaceAll(quantity, '');
//     }
//
//     // Clean up product name
//     productName = productName
//         .replaceAll(RegExp(r'[x×]\s*\d+'), '') // Remove "x2", "×3" patterns
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//
//     // Skip if product name is too short or only contains numbers/symbols
//     if (productName.length < 2 || RegExp(r'^[\d\s\-\*\+\=\.\,\$₹€£¥]+$').hasMatch(productName)) {
//       return null;
//     }
//
//     // Additional validation: product name should have at least one letter
//     if (!RegExp(r'[a-zA-Z]').hasMatch(productName)) {
//       return null;
//     }
//
//     // Additional check: if the cleaned product name contains total-related words, skip it
//     if (_isTotalLine(productName)) {
//       return null;
//     }
//
//     // Calculate total if we have quantity and unit price
//     if (priceMatches.length > 1) {
//       final unitPrice = priceMatches.first.group(0)!;
//       price = unitPrice;
//       total = priceMatches.last.group(0)!;
//     } else {
//       // Try to calculate total
//       final numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
//       final numericQuantity = double.tryParse(quantity) ?? 1;
//       final calculatedTotal = numericPrice * numericQuantity;
//
//       if (calculatedTotal != numericPrice) {
//         total = price.replaceAll(RegExp(r'\d+(\.\d{2})?'), calculatedTotal.toStringAsFixed(2));
//       }
//     }
//
//     return {
//       'sl': '',
//       'product_name': _capitalizeWords(productName),
//       "brand": "Brand Name",
//       "is_in_checklist": false,
//       'price': price,
//       "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//       'in_stock_quantity': quantity,
//       'total': total,
//       "item_category": _guessCategory(productName)
//     };
//   }
//
//   // Updated aggressive extraction as last resort
//   List<Map<String, dynamic>> _aggressiveItemExtraction(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//
//     for (final line in lines) {
//       if (line.trim().isEmpty || _isNonItemLine(line)) continue;
//
//       // Look for any line with a price
//       final priceMatches = RegExp(r'(\$|₹|€|£|¥)?\d+(?:\.\d{2})?').allMatches(line).toList();
//
//       if (priceMatches.isNotEmpty) {
//         String productName = line;
//         final price = priceMatches.last.group(0)!;
//
//         // Clean product name
//         for (final match in priceMatches) {
//           productName = productName.replaceAll(match.group(0)!, '');
//         }
//
//         productName = productName
//             .replaceAll(RegExp(r'\d+'), '') // Remove all numbers
//             .replaceAll(RegExp(r'[^\w\s]'), ' ') // Replace special chars with spaces
//             .replaceAll(RegExp(r'\s+'), ' ')
//             .trim();
//
//         // Enhanced validation
//         if (productName.length > 2 && RegExp(r'[a-zA-Z]').hasMatch(productName)) {
//           extractedItems.add({
//             'sl': '',
//             'product_name': _capitalizeWords(productName),
//             "brand": "Brand Name",
//             "is_in_checklist": false,
//             'price': price,
//             "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//             'in_stock_quantity': "1",
//             'total': price,
//             "item_category": _guessCategory(productName)
//           });
//         }
//       }
//     }
//
//     return extractedItems;
//   }
//
//   // Helper function to capitalize words
//   String _capitalizeWords(String text) {
//     return text.split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
//
//   // Helper function to guess category based on product name
//   String _guessCategory(String productName) {
//     final lowerName = productName.toLowerCase();
//
//     if (lowerName.contains(RegExp(r'(milk|cheese|butter|yogurt|cream)'))) {
//       return "Dairy";
//     } else if (lowerName.contains(RegExp(r'(apple|banana|orange|grape|mango|fruit)'))) {
//       return "Fruits";
//     } else if (lowerName.contains(RegExp(r'(carrot|potato|onion|tomato|vegetable|veggie)'))) {
//       return "Vegetables";
//     } else if (lowerName.contains(RegExp(r'(bread|rice|pasta|cereal|grain)'))) {
//       return "Grains";
//     } else if (lowerName.contains(RegExp(r'(chicken|beef|fish|meat|pork)'))) {
//       return "Meat";
//     } else if (lowerName.contains(RegExp(r'(soap|shampoo|detergent|cleaning|wash)'))) {
//       return "Household";
//     } else if (lowerName.contains(RegExp(r'(medicine|tablet|capsule|syrup|health)'))) {
//       return "Health";
//     } else {
//       return "Other";
//     }
//   }
//
//   //todo -------------------> Enhanced image scanning check
//   bool isImageScannable(RecognizedText recognizedText) {
//     final allLines = recognizedText.blocks.expand((b) => b.lines).toList();
//     final text = recognizedText.text.toLowerCase();
//
//     bool hasText = recognizedText.text.trim().isNotEmpty;
//     bool hasEnoughLines = allLines.length >= 2; // Reduced threshold
//     bool hasInvoiceKeywords = text.contains('invoice') ||
//         text.contains('receipt') ||
//         text.contains('bill') ||
//         recognizedText.text.contains('\$') ||
//         recognizedText.text.contains('₹') ||
//         recognizedText.text.contains('€') ||
//         recognizedText.text.contains('£') ||
//         text.contains('total') ||
//         text.contains('amount') ||
//         text.contains('price');
//
//     bool hasNumbers = RegExp(r'\d+').hasMatch(recognizedText.text);
//
//     return hasText && hasNumbers && (hasEnoughLines || hasInvoiceKeywords);
//   }
//
//   // todo --------------------------------------> Enhanced invoice processing
//   Future<void> getDetailsFromInvoice(String filePath, BuildContext context) async {
//     final inputImage = InputImage.fromFilePath(filePath);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//     await textRecognizer.processImage(inputImage);
//     scannedText = recognizedText.text;
//     log("Raw scanned text: $scannedText");
//
//     if (!isImageScannable(recognizedText)) {
//       log("-------> Image is not scannable!");
//       return;
//     }
//
//     // Enhanced text processing with better spatial awareness
//     List<Map<String, dynamic>> elements = [];
//
//     for (final block in recognizedText.blocks) {
//       for (final line in block.lines) {
//         for (final element in line.elements) {
//           elements.add({
//             'text': element.text,
//             'left': element.boundingBox.left,
//             'top': element.boundingBox.top,
//             'bottom': element.boundingBox.bottom,
//             'right': element.boundingBox.right,
//             'centerY': (element.boundingBox.top + element.boundingBox.bottom) / 2,
//             'width': element.boundingBox.right - element.boundingBox.left,
//             'height': element.boundingBox.bottom - element.boundingBox.top,
//           });
//         }
//       }
//     }
//
//     // Adaptive vertical tolerance based on text size
//     double avgHeight = elements.isNotEmpty
//         ? elements.map((e) => e['height'] as double).reduce((a, b) => a + b) / elements.length
//         : 12.0;
//     double verticalTolerance = avgHeight * 0.7; // 70% of average height
//
//     Map<int, List<Map<String, dynamic>>> groupedRows = {};
//
//     for (var element in elements) {
//       int key = (element['centerY'] / verticalTolerance).round();
//       groupedRows.putIfAbsent(key, () => []).add(element);
//     }
//
//     // Sort rows by vertical Y value and elements within row by X
//     List<int> sortedRowKeys = groupedRows.keys.toList()..sort();
//     String formattedText = '';
//
//     for (int rowKey in sortedRowKeys) {
//       List<Map<String, dynamic>> row = groupedRows[rowKey]!;
//
//       // Sort by horizontal position
//       row.sort((a, b) => a['left'].compareTo(b['left']));
//
//       // Add appropriate spacing between elements
//       String line = '';
//       for (int i = 0; i < row.length; i++) {
//         if (i > 0) {
//           double gap = row[i]['left'] - row[i-1]['right'];
//           if (gap > 20) { // Significant gap
//             line += '  '; // Add extra space
//           } else {
//             line += ' '; // Normal space
//           }
//         }
//         line += row[i]['text'];
//       }
//
//       formattedText += '$line\n';
//     }
//
//     scannedText = formattedText.trim();
//     totalAmount = extractInvoiceTotalAmount(scannedText) ?? '';
//     log("Formatted text (line-wise):\n$scannedText");
//     log("Extracted total amount: $totalAmount");
//
//     await textRecognizer.close();
//
//     scannedItem = extractFlexibleInvoiceItems(scannedText);
//     log("Extracted ${scannedItem.length} items:");
//     for (final item in scannedItem) {
//       log("Item: ${item['product_name']}, Qty: ${item['in_stock_quantity']}, Price: ${item['price']}, Total: ${item['total']}");
//     }
//   }
//
//   // Main method to get all data
//   Future<List<Map<String, dynamic>>> scanInvoiceAndGetData(String filePath, BuildContext context) async {
//     // Reset previous data
//     scannedText = '';
//     totalAmount = '';
//     scannedItem = [];
//
//     await getDetailsFromInvoice(filePath, context);
//
//     // If no items found, show appropriate message
//     if (scannedItem.isEmpty) {
//       log("No items could be extracted from the invoice/receipt");
//     }
//     return scannedItem;
//   }
//
//   bool _isTotalLine(String line) {
//     final lowerLine = line.toLowerCase().trim();
//
//     // Comprehensive list of total-related keywords
//     final totalKeywords = [
//       'total',
//       'grand total',
//       'net total',
//       'sub total',
//       'subtotal',
//       'final total',
//       'amount due',
//       'balance',
//       'due',
//       'sum',
//       'amount',
//       'tax',
//       'discount',
//       'cash',
//       'change',
//       'payment',
//       'paid',
//       'tendered',
//       'refund',
//       'balance due',
//       'amount paid',
//       'total amount',
//       'bill total',
//       'invoice total',
//       'receipt total',
//       'gross total',
//       'net amount',
//       'payable',
//       'total payable',
//       'amount payable',
//       'total due',
//       'outstanding',
//       'balance',
//     ];
//
//     // Check if the line starts with or contains total keywords
//     return totalKeywords.any((keyword) =>
//
//     lowerLine.contains(keyword) ||
//         lowerLine.startsWith(keyword) ||
//         lowerLine.endsWith(keyword)
//     );
//   }
// }

//todo 1st code
// class InvoiceScannerService {
//   static final InvoiceScannerService _instance = InvoiceScannerService._internal();
//   factory InvoiceScannerService() => _instance;
//   InvoiceScannerService._internal();
//
//   String scannedText = '';
//   String totalAmount = '';
//   List<Map<String, dynamic>> scannedItem = [];
//
//   //todo --------------------> get total amount.
//   String? extractInvoiceTotalAmount(String scannedText) {
//     final lines = scannedText.split('\n');
//
//     // Total-related keywords to include
//     final totalKeywords = [
//       'total:',
//       'grand total',
//       'total',
//       'amount due',
//       'net total',
//       'final total',
//       'balance',
//       'amount',
//       'sum',
//       'due',
//     ];
//
//     // Exclude lines that are subtotal
//     final excludeKeywords = ['sub total', 'subtotal', 'tax', 'discount'];
//
//     for (final line in lines.reversed) {
//       final lowerLine = line.toLowerCase();
//
//       // Skip if it contains excluded keywords like 'sub total'
//       if (excludeKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         continue;
//       }
//
//       // Proceed only if it has a valid total keyword
//       if (totalKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         final match = RegExp(r'(\$|₹|€|£|¥)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
//             .allMatches(line)
//             .toList();
//
//         if (match.isNotEmpty) {
//           return match.last.group(0);
//         }
//       }
//     }
//
//     // Fallback: Find the largest amount in the text (likely the total)
//     final allAmounts = RegExp(r'(\$|₹|€|£|¥)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
//         .allMatches(scannedText)
//         .map((match) => match.group(0)!)
//         .toList();
//
//     if (allAmounts.isNotEmpty) {
//       // Convert to double for comparison, handle currency symbols
//       double maxAmount = 0;
//       String maxAmountString = '';
//
//       for (String amount in allAmounts) {
//         final numericString = amount.replaceAll(RegExp(r'[^\d.]'), '');
//         final numericValue = double.tryParse(numericString) ?? 0;
//         if (numericValue > maxAmount) {
//           maxAmount = numericValue;
//           maxAmountString = amount;
//         }
//       }
//
//       return maxAmountString.isNotEmpty ? maxAmountString : null;
//     }
//
//     return null; // Not found
//   }
//
//   //todo --------------------> Enhanced flexible item extraction
//   List<Map<String, dynamic>> extractFlexibleInvoiceItems(String scannedText) {
//     final lines = scannedText.split('\n');
//     final List<Map<String, dynamic>> extractedItems = [];
//
//     // Try structured extraction first
//     final structuredItems = _extractStructuredItems(lines);
//     if (structuredItems.isNotEmpty) {
//       return structuredItems;
//     }
//
//     // Fallback to unstructured extraction
//     return _extractUnstructuredItems(lines);
//   }
//
//   // Original structured extraction method
//   List<Map<String, dynamic>> _extractStructuredItems(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//     bool startedItems = false;
//
//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i].trim();
//
//       // Skip empty lines
//       if (line.isEmpty) continue;
//
//       // Start when we suspect items section is beginning
//       if (!startedItems &&
//           (line.toLowerCase().contains("sl") ||
//               line.toLowerCase().contains("item") ||
//               line.toLowerCase().contains("description") ||
//               line.toLowerCase().contains("product") ||
//               RegExp(r"(\$|₹|€|£|¥)\d+").hasMatch(line))) {
//         startedItems = true;
//         continue;
//       }
//
//       if (startedItems) {
//         // Stop when footer or total section starts
//         if (line.toLowerCase().contains("thank you") ||
//             line.toLowerCase().contains("sub total") ||
//             line.toLowerCase().contains("total:") ||
//             line.toLowerCase().contains("payment") ||
//             line.toLowerCase().contains("account") ||
//             line.toLowerCase().contains("tax") ||
//             line.toLowerCase().contains("discount")) {
//           break;
//         }
//
//         final priceMatches =
//         RegExp(r"(\$|₹|€|£|¥)?\d+(?:\.\d{2})?").allMatches(line).toList();
//         final numberMatches = RegExp(r"\b\d+\b").allMatches(line).toList();
//
//         if (priceMatches.isNotEmpty && numberMatches.isNotEmpty) {
//           final totalPrice = priceMatches.last.group(0)!;
//           final unitPrice =
//           priceMatches.length > 1 ? priceMatches.first.group(0)! : totalPrice;
//
//           String qty = "1";
//           if (numberMatches.length > 1) {
//             qty = numberMatches[1].group(0)!;
//           } else if (numberMatches.length == 1) {
//             qty = numberMatches[0].group(0)!;
//           }
//
//           // Try to extract SL (only if more than one number)
//           final sl = numberMatches.length > 1 ? numberMatches[0].group(0)! : "";
//
//           // Remove known values to estimate description
//           String description = line
//               .replaceAll(unitPrice, '')
//               .replaceAll(totalPrice, '')
//               .replaceAll(qty, '')
//               .replaceAll(sl, '')
//               .replaceAll(RegExp(r"\s+"), ' ')
//               .trim();
//
//           extractedItems.add({
//             'sl': sl,
//             'product_name': description.isEmpty ? "Product Description" : description,
//             "brand": "Brand Name",
//             "is_in_checklist": false,
//             'price': unitPrice,
//             "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//             'in_stock_quantity':
//             (qty == "0" || qty.isEmpty || qty == "00") ? "1" : qty,
//             'total': totalPrice,
//             "item_category": "Other"
//           });
//         }
//       }
//     }
//
//     return extractedItems;
//   }
//
//   // New unstructured extraction method
//   List<Map<String, dynamic>> _extractUnstructuredItems(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//     final Set<String> processedLines = {}; // To avoid duplicates
//
//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i].trim();
//
//       // Skip empty lines or already processed lines
//       if (line.isEmpty || processedLines.contains(line)) continue;
//
//       // Skip obvious non-item lines
//       if (_isNonItemLine(line)) continue;
//
//       // Look for lines that might contain product information
//       final item = _extractItemFromLine(line, i, lines);
//       if (item != null) {
//         extractedItems.add(item);
//         processedLines.add(line);
//       }
//     }
//
//     // If still no items found, try aggressive extraction
//     if (extractedItems.isEmpty) {
//       return _aggressiveItemExtraction(lines);
//     }
//
//     return extractedItems;
//   }
//
//   // Check if line is likely not an item
//   bool _isNonItemLine(String line) {
//     final lowerLine = line.toLowerCase();
//
//     final skipKeywords = [
//       'thank you',
//       'receipt',
//       'invoice',
//       'bill',
//       'date',
//       'time',
//       'cashier',
//       'customer',
//       'phone',
//       'email',
//       'address',
//       'store',
//       'shop',
//       'tax',
//       'discount',
//       'subtotal',
//       'total',
//       'payment',
//       'card',
//       'cash',
//       'change',
//       'balance',
//       'account',
//       'terms',
//       'conditions',
//       'return',
//       'exchange',
//       'policy',
//       'www.',
//       'http',
//       '.com',
//       '.net',
//       '.org',
//       'visit',
//       'follow',
//       'like',
//     ];
//
//     return skipKeywords.any((keyword) => lowerLine.contains(keyword)) ||
//         lowerLine.length < 3 ||
//         RegExp(r'^\d{1,2}[:/]\d{1,2}[:/]\d{2,4}$').hasMatch(line) || // Date
//         RegExp(r'^\d{1,2}:\d{2}(:\d{2})?\s*(AM|PM)?$').hasMatch(lowerLine); // Time
//   }
//
//   // Extract item from a single line
//   Map<String, dynamic>? _extractItemFromLine(String line, int index, List<String> allLines) {
//     // Look for price patterns
//     final priceMatches = RegExp(r'(\$|₹|€|£|¥)?\d+(?:\.\d{2})?').allMatches(line).toList();
//
//     if (priceMatches.isEmpty) return null;
//
//     // Get numbers (potential quantities)
//     final numberMatches = RegExp(r'\b\d+\b').allMatches(line).toList();
//
//     String productName = line;
//     String price = priceMatches.last.group(0)!;
//     String quantity = "1";
//     String total = price;
//
//     // Try to determine quantity
//     if (numberMatches.length >= 2) {
//       // If we have multiple numbers, try to identify quantity
//       final numbers = numberMatches.map((m) => m.group(0)!).toList();
//
//       // Remove price numbers from consideration
//       final priceNumbers = priceMatches.map((m) => m.group(0)!.replaceAll(RegExp(r'[^\d.]'), '')).toList();
//       final potentialQuantities = numbers.where((num) => !priceNumbers.contains(num)).toList();
//
//       if (potentialQuantities.isNotEmpty) {
//         quantity = potentialQuantities.first;
//       }
//     }
//
//     // Clean product name by removing prices and quantities
//     productName = line;
//     for (final match in priceMatches) {
//       productName = productName.replaceAll(match.group(0)!, '');
//     }
//
//     // Remove quantity if it's clearly separate
//     if (quantity != "1" && productName.contains(quantity)) {
//       productName = productName.replaceAll(quantity, '');
//     }
//
//     // Clean up product name
//     productName = productName
//         .replaceAll(RegExp(r'[x×]\s*\d+'), '') // Remove "x2", "×3" patterns
//         .replaceAll(RegExp(r'\s+'), ' ')
//         .trim();
//
//     // Skip if product name is too short or only contains numbers/symbols
//     if (productName.length < 2 || RegExp(r'^[\d\s\-\*\+\=\.\,\$₹€£¥]+$').hasMatch(productName)) {
//       return null;
//     }
//
//     // Calculate total if we have quantity and unit price
//     if (priceMatches.length > 1) {
//       final unitPrice = priceMatches.first.group(0)!;
//       price = unitPrice;
//       total = priceMatches.last.group(0)!;
//     } else {
//       // Try to calculate total
//       final numericPrice = double.tryParse(price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
//       final numericQuantity = double.tryParse(quantity) ?? 1;
//       final calculatedTotal = numericPrice * numericQuantity;
//
//       if (calculatedTotal != numericPrice) {
//         total = price.replaceAll(RegExp(r'\d+(\.\d{2})?'), calculatedTotal.toStringAsFixed(2));
//       }
//     }
//
//     return {
//       'sl': '',
//       'product_name': _capitalizeWords(productName),
//       "brand": "Brand Name",
//       "is_in_checklist": false,
//       'price': price,
//       "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//       'in_stock_quantity': quantity,
//       'total': total,
//       "item_category": _guessCategory(productName)
//     };
//   }
//
//   // Aggressive extraction as last resort
//   List<Map<String, dynamic>> _aggressiveItemExtraction(List<String> lines) {
//     final List<Map<String, dynamic>> extractedItems = [];
//
//     for (final line in lines) {
//       if (line.trim().isEmpty || _isNonItemLine(line)) continue;
//
//       // Look for any line with a price
//       final priceMatches = RegExp(r'(\$|₹|€|£|¥)?\d+(?:\.\d{2})?').allMatches(line).toList();
//
//       if (priceMatches.isNotEmpty) {
//         String productName = line;
//         final price = priceMatches.last.group(0)!;
//
//         // Clean product name
//         for (final match in priceMatches) {
//           productName = productName.replaceAll(match.group(0)!, '');
//         }
//
//         productName = productName
//             .replaceAll(RegExp(r'\d+'), '') // Remove all numbers
//             .replaceAll(RegExp(r'[^\w\s]'), ' ') // Replace special chars with spaces
//             .replaceAll(RegExp(r'\s+'), ' ')
//             .trim();
//
//         if (productName.length > 2) {
//           extractedItems.add({
//             'sl': '',
//             'product_name': _capitalizeWords(productName),
//             "brand": "Brand Name",
//             "is_in_checklist": false,
//             'price': price,
//             "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//             'in_stock_quantity': "1",
//             'total': price,
//             "item_category": _guessCategory(productName)
//           });
//         }
//       }
//     }
//
//     return extractedItems;
//   }
//
//   // Helper function to capitalize words
//   String _capitalizeWords(String text) {
//     return text.split(' ').map((word) {
//       if (word.isEmpty) return word;
//       return word[0].toUpperCase() + word.substring(1).toLowerCase();
//     }).join(' ');
//   }
//
//   // Helper function to guess category based on product name
//   String _guessCategory(String productName) {
//     final lowerName = productName.toLowerCase();
//
//     if (lowerName.contains(RegExp(r'(milk|cheese|butter|yogurt|cream)'))) {
//       return "Dairy";
//     } else if (lowerName.contains(RegExp(r'(apple|banana|orange|grape|mango|fruit)'))) {
//       return "Fruits";
//     } else if (lowerName.contains(RegExp(r'(carrot|potato|onion|tomato|vegetable|veggie)'))) {
//       return "Vegetables";
//     } else if (lowerName.contains(RegExp(r'(bread|rice|pasta|cereal|grain)'))) {
//       return "Grains";
//     } else if (lowerName.contains(RegExp(r'(chicken|beef|fish|meat|pork)'))) {
//       return "Meat";
//     } else if (lowerName.contains(RegExp(r'(soap|shampoo|detergent|cleaning|wash)'))) {
//       return "Household";
//     } else if (lowerName.contains(RegExp(r'(medicine|tablet|capsule|syrup|health)'))) {
//       return "Health";
//     } else {
//       return "Other";
//     }
//   }
//
//   //todo -------------------> Enhanced image scanning check
//   bool isImageScannable(RecognizedText recognizedText) {
//     final allLines = recognizedText.blocks.expand((b) => b.lines).toList();
//     final text = recognizedText.text.toLowerCase();
//
//     bool hasText = recognizedText.text.trim().isNotEmpty;
//     bool hasEnoughLines = allLines.length >= 2; // Reduced threshold
//     bool hasInvoiceKeywords = text.contains('invoice') ||
//         text.contains('receipt') ||
//         text.contains('bill') ||
//         recognizedText.text.contains('\$') ||
//         recognizedText.text.contains('₹') ||
//         recognizedText.text.contains('€') ||
//         recognizedText.text.contains('£') ||
//         text.contains('total') ||
//         text.contains('amount') ||
//         text.contains('price');
//
//     bool hasNumbers = RegExp(r'\d+').hasMatch(recognizedText.text);
//
//     return hasText && hasNumbers && (hasEnoughLines || hasInvoiceKeywords);
//   }
//
//   // todo --------------------------------------> Enhanced invoice processing
//   Future<void> getDetailsFromInvoice(String filePath, BuildContext context) async {
//     final inputImage = InputImage.fromFilePath(filePath);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//     await textRecognizer.processImage(inputImage);
//     scannedText = recognizedText.text;
//     log("Raw scanned text: $scannedText");
//
//     if (!isImageScannable(recognizedText)) {
//       log("-------> Image is not scannable!");
//       return;
//     }
//
//     // Enhanced text processing with better spatial awareness
//     List<Map<String, dynamic>> elements = [];
//
//     for (final block in recognizedText.blocks) {
//       for (final line in block.lines) {
//         for (final element in line.elements) {
//           elements.add({
//             'text': element.text,
//             'left': element.boundingBox.left,
//             'top': element.boundingBox.top,
//             'bottom': element.boundingBox.bottom,
//             'right': element.boundingBox.right,
//             'centerY': (element.boundingBox.top + element.boundingBox.bottom) / 2,
//             'width': element.boundingBox.right - element.boundingBox.left,
//             'height': element.boundingBox.bottom - element.boundingBox.top,
//           });
//         }
//       }
//     }
//
//     // Adaptive vertical tolerance based on text size
//     double avgHeight = elements.isNotEmpty
//         ? elements.map((e) => e['height'] as double).reduce((a, b) => a + b) / elements.length
//         : 12.0;
//     double verticalTolerance = avgHeight * 0.7; // 70% of average height
//
//     Map<int, List<Map<String, dynamic>>> groupedRows = {};
//
//     for (var element in elements) {
//       int key = (element['centerY'] / verticalTolerance).round();
//       groupedRows.putIfAbsent(key, () => []).add(element);
//     }
//
//     // Sort rows by vertical Y value and elements within row by X
//     List<int> sortedRowKeys = groupedRows.keys.toList()..sort();
//     String formattedText = '';
//
//     for (int rowKey in sortedRowKeys) {
//       List<Map<String, dynamic>> row = groupedRows[rowKey]!;
//
//       // Sort by horizontal position
//       row.sort((a, b) => a['left'].compareTo(b['left']));
//
//       // Add appropriate spacing between elements
//       String line = '';
//       for (int i = 0; i < row.length; i++) {
//         if (i > 0) {
//           double gap = row[i]['left'] - row[i-1]['right'];
//           if (gap > 20) { // Significant gap
//             line += '  '; // Add extra space
//           } else {
//             line += ' '; // Normal space
//           }
//         }
//         line += row[i]['text'];
//       }
//
//       formattedText += '$line\n';
//     }
//
//     scannedText = formattedText.trim();
//     totalAmount = extractInvoiceTotalAmount(scannedText) ?? '';
//     log("Formatted text (line-wise):\n$scannedText");
//     log("Extracted total amount: $totalAmount");
//
//     await textRecognizer.close();
//
//     scannedItem = extractFlexibleInvoiceItems(scannedText);
//     log("Extracted ${scannedItem.length} items:");
//     for (final item in scannedItem) {
//       log("Item: ${item['product_name']}, Qty: ${item['in_stock_quantity']}, Price: ${item['price']}, Total: ${item['total']}");
//     }
//   }
//
//   // Main method to get all data
//   Future<List<Map<String, dynamic>>> scanInvoiceAndGetData(String filePath, BuildContext context) async {
//     // Reset previous data
//     scannedText = '';
//     totalAmount = '';
//     scannedItem = [];
//
//     await getDetailsFromInvoice(filePath, context);
//
//     // If no items found, show appropriate message
//     if (scannedItem.isEmpty) {
//       log("No items could be extracted from the invoice/receipt");
//     }
//     return scannedItem;
//   }
// }

//
//
// class InvoiceScannerService {
//   static final InvoiceScannerService _instance = InvoiceScannerService._internal();
//   factory InvoiceScannerService() => _instance;
//   InvoiceScannerService._internal();
//
//   String scannedText = '';
//   String totalAmount = '';
//   List<Map<String, dynamic>> scannedItem = [];
//
//   //todo --------------------> get total amount.
//   String? extractInvoiceTotalAmount(String scannedText) {
//     final lines = scannedText.split('\n');
//
//     // Total-related keywords to include
//     final totalKeywords = [
//       'total:',
//       'grand total',
//       'total',
//       'amount due',
//     ];
//
//     // Exclude lines that are subtotal
//     final excludeKeywords = ['sub total', 'subtotal'];
//
//     for (final line in lines.reversed) {
//       final lowerLine = line.toLowerCase();
//
//       // Skip if it contains excluded keywords like 'sub total'
//       if (excludeKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         continue;
//       }
//
//       // Proceed only if it has a valid total keyword
//       if (totalKeywords.any((keyword) => lowerLine.contains(keyword))) {
//         final match = RegExp(r'(\$)?\d{1,3}(?:,\d{3})*(?:\.\d{2})?')
//             .allMatches(line)
//             .toList();
//
//         if (match.isNotEmpty) {
//           return match.last.group(0);
//         }
//       }
//     }
//
//     return null; // Not found
//   }
//
//   //todo --------------------> get all item details.
//   List<Map<String, dynamic>> extractFlexibleInvoiceItems(String scannedText) {
//     final lines = scannedText.split('\n');
//
//     final List<Map<String, dynamic>> extractedItems = [];
//
//     bool startedItems = false;
//
//     for (var i = 0; i < lines.length; i++) {
//       final line = lines[i].trim();
//
//       // Skip empty lines
//       if (line.isEmpty) continue;
//
//       // Start when we suspect items section is beginning
//       if (!startedItems &&
//           (line.toLowerCase().contains("sl") ||
//               line.toLowerCase().contains("item") ||
//               line.toLowerCase().contains("description") ||
//               RegExp(r"\$\d+").hasMatch(line))) {
//         startedItems = true;
//         continue;
//       }
//
//       if (startedItems) {
//         // Stop when footer or total section starts
//         if (line.toLowerCase().contains("thank you") ||
//             line.toLowerCase().contains("sub total") ||
//             line.toLowerCase().contains("total:") ||
//             line.toLowerCase().contains("payment") ||
//             line.toLowerCase().contains("account")) {
//           break;
//         }
//
//         final priceMatches =
//             RegExp(r"\$\d+(?:\.\d{2})?").allMatches(line).toList();
//         final numberMatches = RegExp(r"\b\d+\b").allMatches(line).toList();
//
//         if (priceMatches.isNotEmpty && numberMatches.isNotEmpty) {
//           final totalPrice = priceMatches.last.group(0)!;
//           final unitPrice =
//               priceMatches.length > 1 ? priceMatches.first.group(0)! : "";
//
//           String qty = "1";
//           if (numberMatches.length > 1) {
//             qty = numberMatches[1].group(0)!;
//           } else if (numberMatches.length == 1) {
//             qty = numberMatches[0].group(0)!;
//           }
//
//           // Try to extract SL (only if more than one number)
//           final sl = numberMatches.length > 1 ? numberMatches[0].group(0)! : "";
//
//           // Remove known values to estimate description
//           String description = line
//               .replaceAll(unitPrice, '')
//               .replaceAll(totalPrice, '')
//               .replaceAll(qty, '')
//               .replaceAll(sl, '')
//               .replaceAll(RegExp(r"\s+"), ' ')
//               .trim();
//
//           extractedItems.add({
//             'sl': sl,
//             'product_name': description.isEmpty ? "Product Description" : description,
//             "brand": "Brand Name",
//             "is_in_checklist": false,
//             'price': unitPrice,
//             "expiry_date": DateTime.now().add(Duration(days: 30)).toIso8601String(),
//             'in_stock_quantity':
//                 (qty == "0" || qty.isEmpty || qty == "00") ? "1" : qty,
//             'total': totalPrice,
//             "item_category": "Other"
//           });
//         }
//       }
//     }
//
//     return extractedItems;
//
//   }
//
//   //todo -------------------> check image is scannable or not.
//   bool isImageScannable(RecognizedText recognizedText) {
//     final allLines = recognizedText.blocks.expand((b) => b.lines).toList();
//     final allElements = allLines.expand((l) => l.elements).toList();
//
//     bool hasText = recognizedText.text.trim().isNotEmpty;
//     bool hasEnoughLines = allLines.length >= 3;
//     bool hasInvoiceKeywords =
//         recognizedText.text.toLowerCase().contains('invoice') ||
//             recognizedText.text.contains('\$') ||
//             recognizedText.text.toLowerCase().contains('total');
//
//     return hasText && (hasEnoughLines || hasInvoiceKeywords);
//   }
//
//   // todo --------------------------------------> get details from the invoice
//   Future<void> getDetailsFromInvoice(String filePath,BuildContext context) async {
//     final inputImage = InputImage.fromFilePath(filePath);
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(inputImage);
//     scannedText = recognizedText.text;
//     log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;$scannedText");
//
//     if (!isImageScannable(recognizedText)) {
//       // CustomToast.showError(context,
//       //     "Image is not Scannable!");
//       log("-------> Image is not Scannable!");
//       return;
//     }
//     List<Map<String, dynamic>> elements = [];
//
//     for (final block in recognizedText.blocks) {
//       log(block.text);
//       for (final line in block.lines) {
//         for (final element in line.elements) {
//           elements.add({
//             'text': element.text,
//             'left': element.boundingBox.left,
//             'top': element.boundingBox.top,
//             'bottom': element.boundingBox.bottom,
//             'right': element.boundingBox.right,
//             'centerY':
//                 (element.boundingBox.top + element.boundingBox.bottom) / 2,
//           });
//         }
//       }
//     }
//
//     /// Group elements into rows based on Y center alignment
//     const double verticalTolerance = 12.0; // adjust this based on font size
//     Map<int, List<Map<String, dynamic>>> groupedRows = {};
//
//     for (var element in elements) {
//       int key = (element['centerY'] / verticalTolerance).round();
//
//       groupedRows.putIfAbsent(key, () => []).add(element);
//     }
//
//     /// Sort rows by vertical Y value and elements within row by X
//     List<int> sortedRowKeys = groupedRows.keys.toList()..sort();
//     String formattedText = '';
//
//     for (int rowKey in sortedRowKeys) {
//       List<Map<String, dynamic>> row = groupedRows[rowKey]!;
//
//       // Sort by horizontal position
//       row.sort((a, b) => a['left'].compareTo(b['left']));
//
//       String line = row.map((e) => e['text']).join(' ');
//       formattedText += '$line\n';
//     }
//
//     scannedText = formattedText.trim();
//     totalAmount = extractInvoiceTotalAmount(scannedText) ?? '';
//     log("Formatted text (line-wise):\n$scannedText");
//
//     await textRecognizer.close();
//
//     scannedItem = extractFlexibleInvoiceItems(scannedText);
//     for (final item in scannedItem) {
//       log("Item: ${item['product_name']}, Qty: ${item['in_stock_quantity']}, Price: ${item['price']}, Total: ${item['total']}");
//     }
//   }
//
//   // Main method to get all data as a list of maps
//   Future<List<Map<String, dynamic>>> scanInvoiceAndGetData(String filePath,BuildContext context) async {
//     await getDetailsFromInvoice(filePath,context);
//
//     return scannedItem;
//
//   }
// }
