import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

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

  Future<Response<dynamic>?> userAdminGroup({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> cancelinvite({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> updateuser({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> userleavegroup({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> getFaqs();
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
      if ((record['profile_image'] != null) &&
          !record['profile_image'].toString().startsWith('http')) {
        record['profile_image'] =
            await Utils.getCompressedBse64String(record['profile_image']);
      } else {
        record.remove('profile_image');
      }
      if (isEdit) record.removeWhere((key, value) => value == null);
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
  Future<Response?> userAdminGroup({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'userAdminGroup');

    return await BaseRepository().post(
      ApiUrl.updateuser,
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
  Future<Response?> updateuser({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'updateuser');

    return await BaseRepository().post(
      ApiUrl.updateuser,
      data: formData,
    );
  }

  @override
  Future<Response?> userleavegroup({
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> formData = {'records': []};

    (formData['records'] as List).add(data);

    log('form data: ${formData.toString()}', name: 'userleavegroup');

    return await BaseRepository().post(
      ApiUrl.removeuserfromgroup,
      data: formData,
    );
  }

  @override
  Future<Response?> getFaqs() async {
    return await BaseRepository().get(ApiUrl.removeuserfromgroup);
  }
}
