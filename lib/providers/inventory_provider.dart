import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class InventoryProvider extends ChangeNotifier {
  final BaseInventoryService services;

  InventoryProvider(this.services);

  bool _isLoading = false;
  final List<Product> _products = [];

  final List<Product> _selectedProducts = [];

  final List<Map<String, dynamic>> _searchedProducts = [];
  String? _addInvSelectedCategory;
  String _addInvSelectedInvType = 'low';
  XFile? _addInvSelectedFile;

  bool get isLoading => _isLoading;
  List<Product> get products => _products;
  List<Product> get selectedProducts => _selectedProducts;
  List<Map<String, dynamic>> get searchedProducts => _searchedProducts;
  String? get addInvSelectedCategory => _addInvSelectedCategory;
  String? get addInvSelectedInvType => _addInvSelectedInvType;
  XFile? get addInvSelectedFile => _addInvSelectedFile;

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  final int _selectedProduct = 0;

  int get selectedProduct => _selectedProduct;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void deleteProduct(String title, BuildContext context) {
    _productList.removeWhere((element) => element['title'] == title);

    CustomToast.showSuccess(context, 'Successfully deleted');

    notifyListeners();
  }

  void changeAddInvSelectedCategory(String? newValue) {
    _addInvSelectedCategory = newValue;
    notifyListeners();
  }

  void changeAddInvSelectedInvType(String? newValue) {
    _addInvSelectedInvType = newValue ?? 'low';
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

  Future<String?> selectFile() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    _addInvSelectedFile = file;
    notifyListeners();
    return file.name;
  }

  void clearFile() {
    _addInvSelectedFile = null;
    notifyListeners();
  }

  void changeInventoryType(String itemId, InventoryType newType) async {
    final product = _products.firstWhere((element) => element.itemId == itemId);
    if (product.itemLevel == newType.name) return;
    product.itemLevel = newType.name;
    await putInventoryItem(
        data: product.copyWith(itemLevel: newType.name).toJson(), isEdit: true);
  }

  void addToChecklist(
      List<Product> products, BuildContext context, bool isFromMulti) async {
    for (Product product in products) {
      product.isInChecklist = !product.isInChecklist;

      if (!product.isInChecklist) {
        if (isFromMulti) {
          CustomToast.showSuccess(context, 'Successfully added to Cart');
        }
      } else {
        if (isFromMulti) CustomToast.showError(context, 'Removed from Cart');
      }
    }
    clearSelectedProducts();
  }

  // void deleteCheckList(BuildContext context) {
  //   List<Map<dynamic, dynamic>> checkOutList = List.from(_checkoutList);
  //   for (Map<dynamic, dynamic> product in checkOutList) {
  //     if (product['isInCart']) {
  //       product['isInCart'] = false;

  //       _checkoutList.remove(product);
  //     }
  //   }

  //   notifyListeners();
  // }

  void onSearch(String query) {
    _searchedProducts.addAll(
      _productList.where(
          (element) => element['title'].toString().toLowerCase().contains(
                query.toLowerCase(),
              )),
    );
    notifyListeners();
  }

  void clearUploadedFilePath() {
    uploadedFilePath = null;
    notifyListeners();
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
    required Map<String, dynamic> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.putInventoryItem(data: [data], isEdit: isEdit);

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

  // Future<void> putToChecklist({
  //   required List<String> itemIds,
  //   Function(String)? onError,
  //   VoidCallback? onSuccess,
  // }) async {
  //   try {
  //     setLoading(true);
  //     final res = await services.putToChecklist(itemIds: itemIds);

  //     if (res == null) {
  //       onError?.call(Constants.tokenExpiredMessage);
  //       return;
  //     }

  //     if (res.statusCode == 200) {
  //       clearSelectedProducts();
  //       onSuccess?.call();
  //     } else {
  //       onError?.call(res.data["message"] ?? Constants.commonErrMsg);
  //     }
  //   } on DioException {
  //     rethrow;
  //   } catch (e) {
  //     debugPrint("Error while putToChecklist: $e");
  //   } finally {
  //     setLoading(false);
  //   }
  // }

  final List<Map<String, dynamic>> _productList = [
    {
      'image': AppAssets.apple,
      'title': 'Apple',
      'brand': 'Ice Berry',
      'inventoryLevel': InventoryType.low,
      'category': 'Fresh Fruits',
      'storage': 'Fridge Rack',
      'isInCart': false,
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.leaf,
      'title': 'Leaf',
      'brand': 'Alvera',
      'inventoryLevel': InventoryType.low,
      'category': 'Fresh Vegetables',
      'storage': 'Fridge Rack',
      'isInCart': false,
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.orange,
      'title': 'Orange',
      'brand': 'Devil',
      'inventoryLevel': InventoryType.high,
      'category': 'Fresh Fruits',
      'storage': 'Fridge Rack',
      'isInCart': false,
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.noImage,
      'title': 'Product Name',
      'brand': 'William',
      'inventoryLevel': InventoryType.high,
      'category': 'Fresh Fruits',
      'storage': 'Paper Rank',
      'isInCart': false,
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
    {
      'image': AppAssets.beetroot,
      'title': 'Beetroot',
      'brand': 'Bee',
      'inventoryLevel': InventoryType.low,
      'category': 'Fresh Vegetables',
      'storage': 'Paper Rack',
      'isInCart': false,
      'desc':
          'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
    },
  ];
}
