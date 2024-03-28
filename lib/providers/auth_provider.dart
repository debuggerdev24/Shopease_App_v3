import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';
import 'package:shopease_app_flutter/services/demo_service.dart';

class AuthProvider extends ChangeNotifier {
  final BaseDemoService services;

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

  Future<void> demoFunction({dynamic data}) async {
    try {
      setLoading(true);
      final response = await services.demoRequest(data: data);
      final token = response['token'];
      BaseRepository.instance.addToken(token);
      setLoading(false);
    } on DioException {
      setLoading(false);
      rethrow;
    } catch (e) {
      setLoading(false);
      debugPrint("Error while logging in $e");
    }
  }
}
