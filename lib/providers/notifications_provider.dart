import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/models/notification_model.dart';
import 'package:shopease_app_flutter/services/notifications_service.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

class NotificationProvider extends ChangeNotifier {
  final BaseNotificationService service;

  NotificationProvider(this.service);

  bool _isLoading = false;
  final List<NotificationModel> _notifications = [];

  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void updateNotification(bool newValue, String notificationId) {
    _notifications
        .firstWhere((element) => element.notificationId == notificationId)
        .updateRead(newValue);
  }

  Future<void> getNotifications({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getUserNotification();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _notifications.clear();
        _notifications.addAll(
            (res.data as List).map((e) => NotificationModel.fromJson(e)));
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getNotifications: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateNotifications({
    required List<Map<String, dynamic>> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.updateUserNotification(data: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        for (Map<String, dynamic> notificationData in data) {
          updateNotification(
            notificationData['is_message_read'],
            notificationData['notification_id'],
          );
        }
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while updateNotifications: $e");
    } finally {
      setLoading(false);
    }
  }
}
