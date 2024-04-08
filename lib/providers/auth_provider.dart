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
  //     final res = await services.signUp(phone: phone);

  //     print("tatatat ----> ${res}");

  //     if (res.statusCode == 200) {
  //       onSuccess?.call();
  //     } else {
  //       onError?.call(res.data["message"] ?? "Something went wrong!");
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


}
