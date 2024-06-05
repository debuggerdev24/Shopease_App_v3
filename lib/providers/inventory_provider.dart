import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/category_model.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';

class InventoryProvider extends ChangeNotifier {
  final BaseInventoryService services;

  InventoryProvider(this.services);

  /// Variables
  bool _isLoading = false;
  final List<Product> _products = [];
  final List<Product> _serchresult = [];
  final List<Product> _filteredProducts = [];
  final List<String> _selectedCategoryFilters = [];
  String? _selectedInventoryLevelFilter;
  final List<Product> _selectedProducts = [];

  /// getters
  bool get isLoading => _isLoading;
  List<Product> get products => _products;
  List<String> get selectedCategoryFilters => _selectedCategoryFilters;
  String? get selectedInventoryLevelFilter => _selectedInventoryLevelFilter;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get selectedProducts => _selectedProducts;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeFilterCategoty(String categoryId) {
    if (_selectedCategoryFilters.contains(categoryId)) {
      _selectedCategoryFilters.remove(categoryId);
    } else {
      _selectedCategoryFilters.add(categoryId);
    }
    notifyListeners();
  }

  void changeFilterInventoryLevel(String? level) {
    if (_selectedInventoryLevelFilter == level) {
      _selectedInventoryLevelFilter = null;
    } else {
      _selectedInventoryLevelFilter = level;
    }

    notifyListeners();
  }

  void filterProducts() {
    _filteredProducts.clear();
    if (_selectedCategoryFilters.isEmpty &&
        _selectedInventoryLevelFilter == null) {
      _filteredProducts.addAll(_products);
      notifyListeners();
      return;
    }

    if (_selectedCategoryFilters.isEmpty) {
      _filteredProducts.addAll(
        _products.where(
          (element) => element.itemLevel == _selectedInventoryLevelFilter,
        ),
      );
      notifyListeners();
      return;
    }

    if (_selectedInventoryLevelFilter == null) {
      _filteredProducts.addAll(
        _products.where(
          (product) => _selectedCategoryFilters.contains(Constants.categories
              .firstWhere(
                  (category) => category.categoryName == product.itemCategory)
              .categoryId),
        ),
      );
      notifyListeners();

      return;
    }

    _filteredProducts.addAll(
      _products.where(
        (product) =>
            product.itemLevel == _selectedInventoryLevelFilter &&
            _selectedCategoryFilters.contains(Constants.categories
                .firstWhere(
                    (category) => category.categoryName == product.itemCategory)
                .categoryId),
      ),
    );

    notifyListeners();
  }

  void deleteProduct(List<String> productIds) {
    for (String itemId in productIds) {
      _products.removeWhere((element) => element.itemId == itemId);
    }
    notifyListeners();
  }

  void addProductToSelected(bool? value, Product product) {
    if (value == true) {
      _selectedProducts.add(product);
    } else {
      _selectedProducts.remove(product);
    }
    notifyListeners();
  }

  void clearSelectedProducts() {
    _selectedProducts.clear();
    getInventoryItems();
    notifyListeners();
  }

  void changeInventoryType(String itemId, InventoryType newType) async {
    final product = _products.firstWhere((element) => element.itemId == itemId);
    if (product.itemLevel == newType.name) return;
    product.itemLevel = newType.name;
    await putInventoryItem(
        data: [product.copyWith(itemLevel: newType.name).toJson()],
        isEdit: true);
  }

  void addToChecklist(
      List<Product> products, BuildContext context, bool isFromMulti) async {
    for (Product product in products) {
      product.isInChecklist = !(product.isInChecklist ?? false);

      if (product.isInChecklist == false) {
        if (isFromMulti) {
          CustomToast.showSuccess(context, 'Successfully added to Cart');
        }
      } else {
        if (isFromMulti) CustomToast.showError(context, 'Removed from Cart');
      }
    }
    clearSelectedProducts();
  }

  Future<void> getInventoryItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.getInventoryItems();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _products.clear();
        _products.addAll((res.data as List).map((e) => Product.fromJson(e)));
        _products.sort(
          (a, b) =>
              b.updatedDate?.compareTo(a.updatedDate ?? DateTime(0)) ?? -1,
        );
        filterProducts();
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getInventoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putInventoryItem({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.putInventoryItem(data: data, isEdit: isEdit);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while putInventoryItems: $e");
      debugPrint("Error while putInventoryItems: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> deletInventoryItems({
    required List<String> itemIds,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.deleteInventoryItems(itemIds: itemIds);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        deleteProduct(itemIds);
        clearSelectedProducts();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while deletInventoryItems: $e");
    } finally {
      setLoading(false);
    }
  }
}
