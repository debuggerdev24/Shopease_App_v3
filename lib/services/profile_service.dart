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

  Future<Response<dynamic>?> inviteUser({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> removeUserFromGroup({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> getinvitesbyuser();

  Future<Response<dynamic>?> acceptinvite({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> cancelinvite({
    required Map<String, dynamic> data,
  });
  Future<Response<dynamic>?> rejectinvite({
    required Map<String, dynamic> data,
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

  @override
  Future<Response?> inviteUser({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'inviteUser');

    return await BaseRepository().post(
      ApiUrl.inviteUser,
      data: formData,
    );
  }

  @override
  Future<Response?> removeUserFromGroup({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'removeUserFromGroup');

    return await BaseRepository().post(
      ApiUrl.removeUser,
      data: formData,
    );
  }

  @override
  Future<Response?> getinvitesbyuser() async {
    final Map<String, dynamic> formData = {'records': []};

    // (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'getinvitesbyuser');

    return await BaseRepository().post(
      ApiUrl.getinvitesbyuser,
      data: formData,
    );
  }

  @override
  Future<Response?> acceptinvite({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'acceptinvite');

    return await BaseRepository().post(
      ApiUrl.acceptinvite,
      data: formData,
    );
  }

  @override
  Future<Response?> cancelinvite({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'cancelinvite');

    return await BaseRepository().post(
      ApiUrl.cancelinvite,
      data: formData,
    );
  }

  @override
  Future<Response?> rejectinvite({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'rejectinvite');

    return await BaseRepository().post(
      ApiUrl.rejectinvite,
      data: formData,
    );
  }
}
