import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/services/auth_service.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class AuthProvider extends ChangeNotifier {
  final BaseAuthService services;

  AuthProvider(this.services);

  bool _isLoading = false;
  bool _needToResendOTP = false;
  bool _showResendOTPText = false;

  Country _selectedCountry = Country.from(json: Constants.selectedCountryMap);

  bool get isLoading => _isLoading;
  bool get showResendOTPText => _showResendOTPText;
  bool get needToResendOTP => _needToResendOTP;
  Country get selectedCountry => _selectedCountry;

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setResendOtp(bool? value) {
    _needToResendOTP = value ?? _needToResendOTP;
    notifyListeners();
  }

  notifyAllListners() {
    notifyAllListners();
  }

  setNeedToResendOTP(bool rensedOTP) {
    _needToResendOTP = rensedOTP;
    notifyListeners();
  }

  setSelectedCountry(Country newCountry) {
    _selectedCountry = newCountry;
    log('setted selected country: ${newCountry.countryCode}');
    log('actually setted selected country: ${_selectedCountry.countryCode}');
    notifyListeners();
  }

  Future<void> signUp({
    required String phone,
    String? tempName,
    required VoidCallback onSuccess,
    Function(String)? onError,
  }) async {
    try {
      setLoading(true);
      final res = await services.signUp(phone: phone, tempName: tempName);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        SharedPrefs().setSessionId(res.data['session_id']);
        onSuccess.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while signUp: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> confirmSignUp({
    required String phone,
    required String otp,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.confirmsignup(phone: phone, code: otp);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        SharedPrefs().setAccessToken(res.data['AccessToken']);
        SharedPrefs().setRefreshToken(res.data['RefreshToken']);
        SharedPrefs().setIdToken(res.data['IdToken']);
        BaseRepository().addToken(res.data['IdToken']);
        onSuccess?.call();
      } else {
        setNeedToResendOTP(true);
        onError?.call('Invalid OTP.');
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while confirmSignUp: $e");
    } finally {
      setLoading(false);
    }
  }

  Future refreshAuth({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.refreshAuth();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        SharedPrefs().setAccessToken(res.data['AccessToken']);
        SharedPrefs().setIdToken(res.data['IdToken']);
        BaseRepository().addToken(res.data['IdToken']);
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
        setNeedToResendOTP(true);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while refreshAuth: $e");
    } finally {
      setLoading(false);
    }
  }
}
