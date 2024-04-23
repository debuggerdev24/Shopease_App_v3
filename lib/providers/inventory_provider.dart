import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/services/inventory_services.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class InventoryProvider extends ChangeNotifier {
  final BaseInventoryService services;

  InventoryProvider(this.services);

  bool _isLoading = false;
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

  final List<Map<String, dynamic>> _searchedProducts = [];
  String? _addInvSelectedCategory;
  String? _addInvSelectedInvType;
  XFile? _addInvSelectedFile;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get products => _productList;
  List<Map<String, dynamic>> get searchedProducts => _searchedProducts;
  String? get addInvSelectedCategory => _addInvSelectedCategory;
  String? get addInvSelectedInvType => _addInvSelectedInvType;
  XFile? get addInvSelectedFile => _addInvSelectedFile;

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  final int _selectedProduct = 0;

  List<Map<dynamic, dynamic>> _checkoutList = [];

  List<Map<dynamic, dynamic>> get checkOutList => _checkoutList;

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

  void checkOutProducts() {
    _checkoutList =
        products.where((product) => product['isInCart'] == true).toList();
    notifyListeners();
  }

  void changeAddInvSelectedCategory(String? newValue) {
    _addInvSelectedCategory = newValue;
    notifyListeners();
  }

  void changeAddInvSelectedInvType(String? newValue) {
    _addInvSelectedInvType = newValue;
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

  void changeInventoryType(
      String title, InventoryType newType, BuildContext context) {
    final product =
        _productList.firstWhere((element) => element['title'] == title);
    if (product['inventoryLevel'] == newType) return;
    product['inventoryLevel'] = newType;

    CustomToast.showSuccess(context, 'Successfully changed inventory type ');

    notifyListeners();
  }

  void addtoCart(
      String title, bool isInCart, BuildContext context, bool multi) {
    final product = _productList
        .firstWhere((element) => element['title'] == title, orElse: () => {});

    if (product == null) {
      if (multi) CustomToast.showError(context, 'Product not found');
      return;
    }

    product['isInCart'] = isInCart;

    if (isInCart) {
      _checkoutList.add(product);
      if (multi) CustomToast.showSuccess(context, 'Successfully added to Cart');
    } else {
      _checkoutList.remove(product);
      if (multi) CustomToast.showError(context, 'Removed from Cart');
    }

    notifyListeners();
  }

  void deleteCheckList(BuildContext context) {
    List<Map<dynamic, dynamic>> checkOutList = List.from(_checkoutList);
    for (Map<dynamic, dynamic> product in checkOutList) {
      if (product['isInCart']) {
        product['isInCart'] = false;

        _checkoutList.remove(product);
      }
    }

    notifyListeners();
  }

  void onSearch(String query) {
    _searchedProducts.addAll(
      _productList.where(
          (element) => element['title'].toString().toLowerCase().contains(
                query.toLowerCase(),
              )),
    );
    notifyListeners();
  }

  Future<void> openFilePicker(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final platformFile = result.files.single;
      final fileSize = platformFile.size ?? 0; // File size in bytes

      if (fileSize <= 5 * 1024 * 1024) {
        // File size is less than or equal to 5MB
        String? filePath = platformFile.path;
        String fileName = File(filePath ?? '').path.split('/').last;
        uploadedFilePath = fileName;
        notifyListeners(); // Notify listeners that the state has changed
      } else {
        CustomToast.showWarning(
            context, 'Please select a file smaller than 5MB.');
      }
    } else {
      context.pop();
    }
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      log('No file selected');
      return;
    }

    // Upload file with its filename as the key
    final platformFile = result.files.single;
    final path = platformFile.path!;
    final key = DateTime.now().toString() + platformFile.name;

    imagekey = key;
    imagefile = File(path);
    uploadedFilePath = key;
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

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? "Something went wrong!");
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getInventoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putInventoryItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.putInventoryItems();

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? "Something went wrong!");
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while putInventoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> deletInventoryItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.deleteInventoryItems();

      if (res.statusCode == 200) {
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? "Something went wrong!");
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
