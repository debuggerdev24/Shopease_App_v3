import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseScannerService {
  Future<Response<dynamic>> getScannedData(String barcode);
}

class ScannerService implements BaseScannerService {
  final _api = BaseRepository.instance.dio;
  ScannerService._();
  static final ScannerService _instance = ScannerService._();
  factory ScannerService() => _instance;

  @override
  Future<Response<dynamic>> getScannedData(String barcode) async {
    String apiKey = "taro7zm1s49u1hej0a146zj2tdy6tw";
    final res = await _api.get(
        'https://api.barcodelookup.com/v3/products?barcode=$barcode&formatted=y&key=$apiKey');
    return res;
  }
}
