import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/utils/utilas.dart';

abstract class BaseHistoryService {
  Future<Response<dynamic>?> getHistoryItems();
  Future<Response<dynamic>?> putHistoryItems({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
  });
}

class Historyservice implements BaseHistoryService {
  @override
  Future<Response?> getHistoryItems() async {
    return await BaseRepository().post(ApiUrl.getHistoryItems);
  }

  @override
  Future<Response?> putHistoryItems(
      {required List<Map<String, dynamic>> data, required bool isEdit}) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      if (!isEdit && record.containsKey('image_url')) {
        record['image_url'] = Utils.getBse64String(record['image_url']);
      }
      // recordMap['item_details'] = record;
      (formData['records'] as List).add(record);
    }

    log('form data: ${formData.toString()}', name: 'putHistoryItems-service');

    if (isEdit) {
      return await BaseRepository().put(
        ApiUrl.putHistoryItems,
        data: formData,
      );
    } else {
      return await BaseRepository().post(
        ApiUrl.putHistoryItems,
        data: formData,
      );
    }
  }
}
