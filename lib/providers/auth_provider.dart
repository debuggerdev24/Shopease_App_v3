import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/services/auth_service.dart';

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


  // Future<void> signUp({
  //   required String phone,
   
  //   Function(String)? onError,
  //   VoidCallback? onSuccess,
  // }) async {
  //   try {
  //     setLoading(true);
  //     final res = await services.signUp(
         
  //      phone: phone);
  //     if (res["status"] == true) {
  //       onSuccess?.call();
  //     } else {
  //       onError?.call(res["message"] ?? "Something went wrong!");
  //     }

  //     setLoading(false);
  //   } on DioException {
  //     setLoading(false);
  //     rethrow;
  //   } catch (e) {
  //     setLoading(false);
  //     debugPrint("Error while signing up in $e");
  //   }
  // }

  
  //   Future<void> signUp(
  //   String phone,
  //   String temp, {
  //   VoidCallback? onSuccess,
  //   VoidCallback? onChangePassword,
  //   VoidCallback? onError,
  // }) async {
  //   setLoading(true);
  //   try {
  //     final response = await AuthService().signUp(phone: phone, tempPass: tempPass, userName: userName)
  //     if (response['code'] == 200) {
        
  //       log("response ====${response.toString()}");
      
  //       if (loginResp.data.tempPass == true) {
  //         // SharedPrefs().setDocId(response['doctor']);
  //         onChangePassword?.call();
  //       } else {
  //         onSuccess?.call();
  //       }
  //     } else {
  //       onError?.call();
  //     }
  //   } on DioException {
  //     onError?.call();
  //     rethrow;
  //   } catch (e, s) {
  //     debugPrint('Error while login: $e');
  //     debugPrint('Error while login: $s');
  //   } finally  {
  //   setLoading(false);
  //   }
  // }

}
