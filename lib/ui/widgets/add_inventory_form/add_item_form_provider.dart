import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/category_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

class AddItemFormProvider extends ChangeNotifier {
  final InventoryService service;

  AddItemFormProvider(this.service);

  bool _isLoading = false;
  String? _selectedCategoryId;
  String _selectedInvType = 'low';
  XFile? _selectedFile;
  final List<CategoryModel> _categories = [];

  bool get isLoading => _isLoading;
  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedInvType => _selectedInvType;
  XFile? get selectedFile => _selectedFile;
  List<CategoryModel> get categories => _categories;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeSelectedCategory(String? newValue) {
    _selectedCategoryId = newValue;
    notifyListeners();
  }

  void changeSelectedInvType(String? newValue) {
    _selectedInvType = newValue ?? 'low';
    notifyListeners();
  }

  Future<String?> selectFile() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    _selectedFile = file;
    notifyListeners();
    return file.name;
  }

  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  }

  Future<void> getCategories({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getCategories();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _categories.clear();
        _categories
            .addAll((res.data as List).map((e) => CategoryModel.fromJson(e)));
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getCategories: $e");
    } finally {
      setLoading(false);
    }
  }
}
