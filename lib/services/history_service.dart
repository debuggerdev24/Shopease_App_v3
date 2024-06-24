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
  Future<Response<dynamic>?> putChecklistFromHistory({
    required List<Map<String, dynamic>> histDetails,
  });
  Future<Response<dynamic>?> getHistoryItemDetails({
    required List<String> histIds,
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
      if (!isEdit && record.containsKey('item_image')) {
        record['item_image'] = Utils.getBse64String(record['item_image']);
      }
      if (isEdit) record.removeWhere((key, value) => value == null);
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

  @override
  Future<Response?> putChecklistFromHistory({
    required List<Map<String, dynamic>> histDetails,
  }) async {
    return await BaseRepository()
        .post(ApiUrl.putChecklistFromHistory, data: {'records': histDetails});
  }

  @override
  Future<Response?> getHistoryItemDetails(
      {required List<String> histIds}) async {
    return await BaseRepository().post(ApiUrl.getPurchaseHistoryDetails, data: {
      'records': histIds.map((e) => {"hist_id": e}).toList()
    });
  }
}
