import 'dart:convert';
import 'dart:developer';

import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/routes/routes.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

abstract class BaseAuthService {
  Future<Response<dynamic>> signUp({
    required String phone,
    String? tempName,
  });

  Future<Response<dynamic>> confirmsignup({
    required String phone,
    required String code,
    String? sessionId,
  });

  Future<Response<dynamic>> refreshAuth();
  Future<Response<dynamic>> getProfile();
}

class AuthService implements BaseAuthService {
  final _api = BaseRepository.instance.dio;

  AuthService._();

  static final AuthService _instance = AuthService._();

  factory AuthService() => _instance;

  @override
  Future<Response<dynamic>> signUp({
    required String phone,
    String? tempName,
  }) async {
    final Map<String, dynamic> parms = {
      "phone_number": phone,
      "preferred_username": tempName,
    };

    final res = await _api.post(ApiUrl.signUP, data: parms);
    return res;
  }

  @override
  Future<Response> confirmsignup(
      {required String phone, required String code, String? sessionId}) async {
    return await _api.post(
      ApiUrl.confirmSignUp,
      data: {
        "session": SharedPrefs().sessionId,
        "confirmationcode": code,
        "username": phone,
      },
    );
  }

  @override
  Future<Response> refreshAuth() async {
    return await _api.post(ApiUrl.refreshAuth, data: {
      'refresh_token': SharedPrefs().refreshToken,
    });
  }

  @override
  Future<Response> getProfile() async {
    return await _api.post(ApiUrl.getProfile);
  }

  // void signUp(String phone, BuildContext context, bool isedit) async {
  //   String url = 'https://devapi.shopeaseapp.com/signup';
  //   Map<String, String> headers = {
  //     'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0',
  //     'Content-Type': 'application/json',
  //   };

  //   Map<String, dynamic> body = {
  //     "phone_number": phone,
  //     "temporary_password": "TempPassword123",
  //     "preferred_username": "sts"
  //   };

  //   String jsonBody = json.encode(body);

  //   try {

  //     http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: jsonBody,
  //     );

  //     if (response.statusCode == 200) {
  //       log('Sign up successful');
  //       ('Response: ${response.body}');
  //       CustomToast.showSuccess(context, 'Send code to $phone');
  //       context.pushNamed(AppRoute.otpScreen.name,
  //           extra: {'isEdit': isedit, 'mobile': phone});
  //     } else if (response.statusCode == 400) {
  //       log('Status code: ${response.statusCode}');
  //       log('Response 400: ${response.body}');
  //       CustomToast.showError(context, 'User already exists');
  //     } else {
  //       log('Failed to sign up');
  //       log('Status code: ${response.statusCode}');
  //       log('Response: ${response.body}');
  //     }
  //   } catch (e) {
  //     // Exception occurred during request
  //     log('Error signing up: $e');
  //   }
  // }

  // void confirmSignUp(String phone, String otp, BuildContext context) async {
  //   // URL and headers
  //   String url = 'https://devapi.shopeaseapp.com/confirmsignup';
  //   Map<String, String> headers = {
  //     'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0',
  //     'Content-Type': 'application/json',
  //   };

  //   // Body data
  //   Map<String, dynamic> body = {
  //     "phone_number": phone,
  //     "confirmationcode": otp
  //   };

  //   // Encode the body to JSON
  //   String jsonBody = json.encode(body);

  //   try {
  //     // Make POST request
  //     http.Response response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: jsonBody,
  //     );

  //     if (response.statusCode == 200) {
  //       log('Confirmation successful');
  //       log('Response: ${response.body}');

  //       CustomToast.showSuccess(context, '${response.body.toString()}');
  //       sharedPrefs.setToken('true');
  //       sharedPrefs.setPhone(phone);

  //       context.pushNamed(AppRoute.nickNameScreen.name);
  //     } else {
  //       log('Failed to confirm sign up');
  //       log('Status code: ${response.statusCode}');
  //       log('Response: ${response.body}');
  //       CustomToast.showError(
  //           context, 'OTP is invalid. Please enter correct OTP');
  //     }
  //   } catch (e) {
  //     print('Error confirming sign up: $e');
  //   }
  // }
}
