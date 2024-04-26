import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseScannerService {
  Future<Response<dynamic>> scanItem(String barcode);
}

class ScannerService implements BaseScannerService {
  final _api = BaseRepository().dio;
  ScannerService._();
  static final ScannerService _instance = ScannerService._();
  factory ScannerService() => _instance;

  @override
  Future<Response<dynamic>> scanItem(String barcode) async {
    // String apiKey = "taro7zm1s49u1hej0a146zj2tdy6tw";
    return await _api.get(ApiUrl.scanItem, data: {'barcode': barcode});
  }
}
