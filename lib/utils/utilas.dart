import 'dart:convert';
import 'dart:io';

class Utils {
  static String getBse64String(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return base64Encode(bytes);
  }
}
