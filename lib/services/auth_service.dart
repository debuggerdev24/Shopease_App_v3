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

abstract class BaseAuthService {}

class AuthService implements BaseAuthService {
  final _api = BaseRepository.instance.dio;
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

//   Future<dynamic> signUp({
//     required String phone,
//     required String tempPass,
//     required String userName,
//   }) async {
//     try {
//       final res = await _api.post(
//         ApiUrl.signUP,
//         data: {
//           "phone_number": phone,
//           "temporary_password": tempPass,
//           "preferred_username": userName,
//         },
//         options: Options(
//             headers: {'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0'}),
//       );

//       if (res.statusCode == 200) {
//         log("Response:${res.statusCode}");
//         return res.data;
//       } else if (res.statusCode == 400) {
//         // Handle specific status code 400 (Bad Request)
//         log("Bad Request - Response:${res.statusCode}");
//         return res.data; // Return response data for further handling
//       } else {
//         // Handle other non-200 status codes
//         throw Exception('Failed to sign up: ${res.statusCode}');
//       }
//     } catch (e) {
//       log('Error during sign up: $e');
//       log(e.toString());
//       throw e; // Rethrow the error to be handled by the caller
//     }
//   }

  void signUp(String phone, BuildContext context, bool isedit) async {
    // URL and headers
    String url = 'https://devapi.shopeaseapp.com/signup';
    Map<String, String> headers = {
      'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0',
      'Content-Type': 'application/json',
    };

    // Body data
    Map<String, dynamic> body = {
      "phone_number": phone,
      "temporary_password": "TempPassword123",
      "preferred_username": "sts"
    };

    // Encode the body to JSON
    String jsonBody = json.encode(body);

    try {
      // Make POST request

      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
      );

      // Check response status
      if (response.statusCode == 200) {
        // Successful request
        log('Sign up successful');
        ('Response: ${response.body}');
        CustomToast.showSuccess(context, 'Send code to $phone');
        context.pushNamed(AppRoute.otpScreen.name,
            extra: {'isEdit': isedit, 'mobile': phone});
      } else if (response.statusCode == 400) {
        log('Status code: ${response.statusCode}');
        log('Response 400: ${response.body}');
        CustomToast.showError(context, 'User already exists');
      } else {
        // Request failed
        log('Failed to sign up');
        log('Status code: ${response.statusCode}');
        log('Response: ${response.body}');
      }
    } catch (e) {
      // Exception occurred during request
      log('Error signing up: $e');
    }
  }

  void confirmSignUp(String phone, String otp, BuildContext context) async {
    // URL and headers
    String url = 'https://devapi.shopeaseapp.com/confirmsignup';
    Map<String, String> headers = {
      'x-api-key': 'VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0',
      'Content-Type': 'application/json',
    };

    // Body data
    Map<String, dynamic> body = {
      "phone_number": phone,
      "confirmationcode": otp
    };

    // Encode the body to JSON
    String jsonBody = json.encode(body);

    try {
      // Make POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonBody,
      );

      // Check response status
      if (response.statusCode == 200) {
        // Successful request
        log('Confirmation successful');
        log('Response: ${response.body}');

        CustomToast.showSuccess(context, '${response.body.toString()}');
        context.pushNamed(AppRoute.nickNameScreen.name);
      } else {
        // Request failed
        log('Failed to confirm sign up');
        log('Status code: ${response.statusCode}');
        log('Response: ${response.body}');
        CustomToast.showError(
            context, 'OTP is invalid. Please enter correct OTP');
      }
    } catch (e) {
      // Exception occurred during request
      print('Error confirming sign up: $e');
    }
  }
}
