import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseInventoryService {
  Future<Response<dynamic>> getInventoryItems();
  Future<Response<dynamic>> putInventoryItems(List<Map<String, dynamic>> data);
  Future<Response<dynamic>> deleteInventoryItems(
      {required List<String> itemIds});
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
  Future<Response> putInventoryItems(List<Map<String, dynamic>> data) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      if (record.containsKey('item_image')) {
        record['item_image'] = getBse64String(record['item_image']);
      }
      // recordMap['item_details'] = record;
      (formData['records'] as List).add({'item_details': record});
    }

    log('form data: ${formData.toString()}', name: 'putInventoryItems-service');

    return await _api.post(
      ApiUrl.putInventoryItems,
      data: FormData.fromMap(formData),
    );
  }

  String getBse64String(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return base64Encode(bytes);
  }

  @override
  Future<Response<dynamic>> deleteInventoryItems(
      {required List<String> itemIds}) async {
    return await _api.post(ApiUrl.deletInventoryItems, data: {
      'records': itemIds.map((e) => {'item_id': e})
    });
  }
}
