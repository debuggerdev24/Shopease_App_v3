import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseNotificationService {
  Future<Response<dynamic>?> getUserNotification();
  Future<Response<dynamic>?> updateUserNotification({
    required List<Map<String, dynamic>> data,
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
}
