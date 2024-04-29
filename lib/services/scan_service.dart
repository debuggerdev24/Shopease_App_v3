import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseScannerService {
  Future<Response<dynamic>?> scanItem(String barcode);
}

class ScannerService implements BaseScannerService {
  ScannerService._();
  static final ScannerService _instance = ScannerService._();
  factory ScannerService() => _instance;

  @override
  Future<Response<dynamic>?> scanItem(String barcode) async {
    return await BaseRepository()
        .post(ApiUrl.scanItem, data: {'barcode': barcode});
  }
}
