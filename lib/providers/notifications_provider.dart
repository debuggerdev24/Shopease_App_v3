import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/models/invitation_model.dart';
import 'package:shopease_app_flutter/models/notification_model.dart';
import 'package:shopease_app_flutter/services/notifications_service.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

class NotificationProvider extends ChangeNotifier {
  final BaseNotificationService service;

  NotificationProvider(this.service);

  bool _isLoading = false;
  final List<NotificationModel> _notifications = [];
  List<Invitation> _userInvitation = [];

  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;
  List<Invitation> get invitations => _userInvitation;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void updateNotification(bool newValue, String notificationId) {
    _notifications
        .firstWhere((element) => element.notificationId == notificationId)
        .updateRead(newValue);
  }

  void settingInviteduser(List<Invitation> value) {
    _userInvitation = value;
    notifyListeners();
  }

  void removeInvitation(Invitation invitation) {
    _userInvitation.remove(invitation);
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

        _notifications.sort((a, b) {
          if (b.recievedDate == null && a.recievedDate == null) {
            return 0;
          } else if (b.recievedDate == null) {
            return -1;
          } else if (a.recievedDate == null) {
            return 1;
          } else {
            return b.recievedDate!.compareTo(a.recievedDate!);
          }
        });

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

  Future<void> getinvitations({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getinvitations();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        settingInviteduser(inviteduserFromJson(res.data));
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while getinvitesbyuser: $e");
      debugPrint("Error while getinvitesbyuser: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> acceptinvite({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.acceptinvite(data: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while acceptinvite: $e");
      debugPrint("Error while acceptinvite: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> rejectinvite({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.rejectinvite(data: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while rejectinvite: $e");
      debugPrint("Error while rejectinvite: $s");
    } finally {
      setLoading(false);
    }
  }
}
