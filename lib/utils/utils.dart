import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:shopease_app_flutter/models/category_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

class Utils {
  static Future<String> getCompressedBse64String(String filePath) async {
    Timeline.startSync('compressing image');
    log('starting compressing');

    final bytes = await FlutterImageCompress.compressWithFile(
      filePath,
      quality: 30,
    );
    log('file compressed');
    Timeline.finishSync();
    return base64Encode(bytes ?? []);
  }

  /// PRODUCT CATEGORIES ///
  static final List<CategoryModel> _categories = [];

  static List<CategoryModel> get categories => _categories;

  static Future<void> getCategories({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      final res = await InventoryService().getCategories();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _categories.clear();
        _categories.addAll(
            (res.data as List).map((e) => CategoryModel.fromJson(e)).toList());
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getCategories: $e");
    }
  }
}
