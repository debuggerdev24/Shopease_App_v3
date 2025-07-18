import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

abstract class BaseChecklistService {
  /// Checklist
  Future<Response<dynamic>?> getChecklistItem();
  Future<Response<dynamic>?> putChecklistItem({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
  });

  Future<Response<dynamic>?> getShops();
  Future<Response<dynamic>?> putShops({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
  });
  Future<Response<dynamic>?> putChecklistFromInventory(
      {required List<String> itemIds});
  Future<Response<dynamic>?> putInventoryFromchecklist(
      {required List<String> itemIds, required String shopName});
  Future<Response<dynamic>?> deletChecklistItems(
      {required List<String> itemIds});
}

class ChecklistService implements BaseChecklistService {
  ChecklistService._();
  static final ChecklistService _instance = ChecklistService._();
  factory ChecklistService() => _instance;

  /// Checklist

  @override
  Future<Response<dynamic>?> getChecklistItem() async {
    return await BaseRepository().post(ApiUrl.getChecklistItems);
  }

  @override
  Future<Response?> putChecklistItem(
      {required List<Map<String, dynamic>> data, required bool isEdit}) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      if ((record['item_image'] != null) &&
          !record['item_image'].toString().startsWith('http')) {
        record['item_image'] =
            await Utils.getCompressedBse64String(record['item_image']);
      }
      if (isEdit) record.removeWhere((key, value) => value == null);
      (formData['records'] as List).add({'item_details': record});
    }

    log('form data: ${formData.toString()}', name: 'putChecklistItem-service');

    if (isEdit) {
      return await BaseRepository().put(
        ApiUrl.putChecklistItems,
        data: formData,
      );
    } else {
      return await BaseRepository().post(
        ApiUrl.putChecklistItems,
        data: formData,
      );
    }
  }

  @override
  Future<Response?> getShops() async {
    return await BaseRepository().post(ApiUrl.getShops);
  }

  @override
  Future<Response?> putShops(
      {required List<Map<String, dynamic>> data, bool isEdit = false}) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      // if (!isEdit && record.containsKey('shop_image')) {
      //   record['shop_image'] = Utils.getBse64String(record['shop_image']);
      // }
      if ((record['shop_image'] != null) &&
          !record['shop_image'].toString().startsWith('http')) {
        record['shop_image'] =
            await Utils.getCompressedBse64String(record['shop_image']);
      } else {
        record.remove('shop_image');
      }
      if (isEdit) record.removeWhere((key, value) => value == null);
      (formData['records'] as List).add({'shop_details': record});
    }

    log('form data: ${formData.toString()}', name: 'putShops-service');

    if (isEdit) {
      return await BaseRepository().put(
        ApiUrl.putShops,
        data: formData,
      );
    } else {
      return await BaseRepository().post(
        ApiUrl.putShops,
        data: formData,
      );
    }
  }

  @override
  Future<Response?> putChecklistFromInventory(
      {required List<String> itemIds}) async {
    return await BaseRepository().post(ApiUrl.putChecklistFromInventory, data: {
      'records': itemIds.map((e) => {"item_id": e}).toList()
    });
  }

  @override
  Future<Response?> putInventoryFromchecklist(
      {required List<String> itemIds, required String shopName}) async {
    return await BaseRepository().post(
      ApiUrl.putInventoryFromChecklist,
      data: {
        'records': itemIds
            .map((e) => {
                  "item_id": e,
                  'shop_name': shopName,
                })
            .toList()
      },
    );
  }

  @override
  Future<Response?> deletChecklistItems({required List<String> itemIds}) async {
    return await BaseRepository().post(ApiUrl.deleteChecklistItems, data: {
      'records': itemIds.map((e) => {"item_id": e}).toList()
    });
  }
}
