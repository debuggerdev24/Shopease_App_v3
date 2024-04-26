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

  Country _selectedCountry = Country.from(
    json: {
      "e164_cc": "61",
      "iso2_cc": "AU",
      "e164_sc": 0,
      "geographic": true,
      "level": 1,
      "name": "Australia",
      "example": "412345678",
      "display_name": "Australia (AU) [+61]",
      "full_example_with_plus_sign": "+61412345678",
      "display_name_no_e164_cc": "Australia (AU)",
      "e164_key": "61-AU-0"
    },
  );

  bool get isLoading => _isLoading;
  Country get selectedCountry => _selectedCountry;

  setLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  setSelectedCountry(Country newCountry) {
    _selectedCountry = newCountry;
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

      if(res == null ) {
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
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
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
        await getProfile();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while refreshAuth: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> getProfile({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.getProfile();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        SharedPrefs().setLocationId(res.data['location_id']);
        SharedPrefs().setUserId(res.data['user_id']);
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getProfile: $e");
    } finally {
      setLoading(false);
    }
  }
}
