import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/models/category_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';

class Constants {
  Constants._();

  static const String tokenExpiredMessage =
      'Something went wrong, Please try again later.';

  static const String commonErrMsg = 'Something went wrong.';

  static const String commonAuthErrMsg = 'Authentication failed.';

  static const String defaultShopImage =
      'https://shopease-bucket-prod.s3.amazonaws.com/default/shops/shop_default.jpeg?';

  static const String defaultItemImage =
      'https://shopease-bucket-prod.s3.amazonaws.com/default/items/item_default.jpeg?';

  static const String defaultUserImage =
      'https://shopease-bucket-prod.s3.amazonaws.com/default/users/user_default.jpeg?';

  static const String placeholdeImg =
      'https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png';

  static const Map<String, dynamic> selectedCountryMap = {
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
  };
}
