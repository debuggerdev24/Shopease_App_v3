import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseInventoryService {
  Future<Response<dynamic>> getInventoryItems();
  Future<Response<dynamic>> putInventoryItems();
  Future<Response<dynamic>> deleteInventoryItems();
}

class InventoryService implements BaseInventoryService {
  final Dio _api = BaseRepository.instance.dio;

  InventoryService._();

  static final InventoryService _instance = InventoryService._();

  factory InventoryService() => _instance;

  @override
  Future<Response> getInventoryItems() async {
    return await _api.post(ApiUrl.getInventoryItems);
  }

  @override
  Future<Response> deleteInventoryItems() async {
    return await _api.post(ApiUrl.putInventoryItems);
  }

  @override
  Future<Response> putInventoryItems() async {
    return await _api.post(ApiUrl.deletInventoryItems);
  }
}
