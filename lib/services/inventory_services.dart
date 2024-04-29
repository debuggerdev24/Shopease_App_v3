import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseInventoryService {
  Future<Response<dynamic>?> getInventoryItems();
  Future<Response<dynamic>?> putInventoryItem({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
  });
  Future<Response<dynamic>?> deleteInventoryItems(
      {required List<String> itemIds});
  // Future<Response<dynamic>?> putToChecklist(
  //     {required List<String> itemIds});
}

class InventoryService implements BaseInventoryService {
  final Dio _api = BaseRepository().dio;

  InventoryService._();

  static final InventoryService _instance = InventoryService._();

  factory InventoryService() => _instance;

  @override
  Future<Response?> getInventoryItems() async {
    return await BaseRepository().post(ApiUrl.getInventoryItems);
  }

  @override
  Future<Response?> putInventoryItem(
      {required List<Map<String, dynamic>> data, required bool isEdit}) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      if (!isEdit && record.containsKey('image_url')) {
        record['image_url'] = getBse64String(record['image_url']);
      }
      // recordMap['item_details'] = record;
      (formData['records'] as List).add({'item_details': record});
    }

    log('form data: ${formData.toString()}', name: 'putInventoryItems-service');

    if (isEdit) {
      return await BaseRepository().put(
        ApiUrl.putInventoryItems,
        data: formData,
      );
    } else {
      return await BaseRepository().post(
        ApiUrl.putInventoryItems,
        data: formData,
      );
    }
  }

  @override
  Future<Response<dynamic>?> deleteInventoryItems(
      {required List<String> itemIds}) async {
    return await BaseRepository().post(ApiUrl.deletInventoryItems, data: {
      'records': itemIds.map((e) => {"item_id": e}).toList()
    });
  }

  // @override
  // Future<Response<dynamic>?> putToChecklist(
  //     {required List<String> itemIds}) async {
  //   return await BaseRepository().post(ApiUrl.putToChecklist, data: {
  //     'records': itemIds.map((e) => {"item_id": e}).toList()
  //   });
  // }

  String getBse64String(String filePath) {
    final bytes = File(filePath).readAsBytesSync();
    return base64Encode(bytes);
  }
}
