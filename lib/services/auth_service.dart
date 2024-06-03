import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

abstract class BaseAuthService {
  Future<Response<dynamic>?> signUp({
    required String phone,
    String? tempName,
  });

  Future<Response<dynamic>?> confirmsignup({
    required String phone,
    required String code,
    String? sessionId,
  });

  Future<Response<dynamic>?> refreshAuth();
}

class AuthService implements BaseAuthService {
  final _api = BaseRepository().dio;

  AuthService._();

  static final AuthService _instance = AuthService._();

  factory AuthService() => _instance;

  @override
  Future<Response<dynamic>?> signUp({
    required String phone,
    String? tempName,
  }) async {
    final Map<String, dynamic> parms = {
      "phone_number": phone,
      "preferred_username": tempName,
    };

    return await BaseRepository().post(ApiUrl.signUP, data: parms);
  }

  @override
  Future<Response?> confirmsignup(
      {required String phone, required String code, String? sessionId}) async {
    return await BaseRepository().post(
      ApiUrl.confirmSignUp,
      data: {
        "session": SharedPrefs().sessionId,
        "confirmationcode": code,
        "username": phone,
      },
    );
  }

  @override
  Future<Response?> refreshAuth() async {
    return await BaseRepository().post(ApiUrl.refreshAuth, data: {
      'refresh_token': SharedPrefs().refreshToken ?? "",
    });
  }
}
