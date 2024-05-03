import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/utils/utilas.dart';

import 'base_api_service.dart';

abstract class BaseProfileService {
  Future<Response<dynamic>?> getProfile();
  Future<Response<dynamic>?> getAllProfile();
  Future<Response<dynamic>?> editMyProfile({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
  });

  Future<Response<dynamic>?> addProfile({
    required List<Map<String, dynamic>> data,
  });
}

class ProfileService implements BaseProfileService {
  @override
  Future<Response?> getProfile() async {
    return await BaseRepository().post(ApiUrl.getProfile);
  }

  @override
  Future<Response?> getAllProfile() async {
    return await BaseRepository().post(ApiUrl.getAllProfile);
  }

  @override
  Future<Response?> editMyProfile(
      {required List<Map<String, dynamic>> data, required bool isEdit}) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      if (!isEdit && record.containsKey('profile_image')) {
        record['profile_image'] = Utils.getBse64String(record['profile_image']);
      }
      // recordMap['item_details'] = record;
      (formData['records'] as List).add({'profile_details': record});
    }

    log('form data: ${formData.toString()}', name: 'editProfile');

    if (isEdit) {
      return await BaseRepository().put(
        ApiUrl.putProfile,
        data: formData,
      );
    } else {
      return await BaseRepository().post(
        ApiUrl.putProfile,
        data: formData,
      );
    }
  }

  @override
  Future<Response?> addProfile({
    required List<Map<String, dynamic>> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    for (Map<String, dynamic> record in data) {
      (formData['records'] as List).add({'profile_details': record});
    }

    log('form data: ${formData.toString()}', name: 'editProfile');

    return await BaseRepository().post(
      ApiUrl.putProfile,
      data: formData,
    );
  }
}
