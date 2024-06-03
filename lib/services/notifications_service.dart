import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseNotificationService {
  Future<Response<dynamic>?> getUserNotification();
  Future<Response<dynamic>?> updateUserNotification({
    required List<Map<String, dynamic>> data,
  });

  Future<Response<dynamic>?> getinvitations();

  Future<Response<dynamic>?> rejectinvite({
    required Map<String, dynamic> data,
  });

  Future<Response<dynamic>?> acceptinvite({
    required Map<String, dynamic> data,
  });
}

class NotificationsService implements BaseNotificationService {
  @override
  Future<Response?> getUserNotification() {
    return BaseRepository().post(ApiUrl.getUserNotification);
  }

  @override
  Future<Response?> updateUserNotification(
      {required List<Map<String, dynamic>> data}) {
    return BaseRepository().post(
      ApiUrl.updateUserNotification,
      data: {'records': data},
    );
  }

  @override
  Future<Response?> getinvitations() async {
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
