import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/services/checklist_service.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';

class ChecklistProvider extends ChangeNotifier {
  final BaseChecklistService service;

  ChecklistProvider(this.service);

  /// Values

  bool _isLoading = false;
  final List<Product> _checklist = [];
  final List<Product> _selectedChecklists = [];
  bool _isAllSelected = false;
  bool _checklistit = false;

  Shop? _selectedShop;
  final List<Shop> _shops = [];
  final List<Shop> _filteredShops = [];
  final List<String> _selectedShopFilter = [];
  final Set<String> _shopLoacations = <String>{};

  final List<Map<String, dynamic>> _historylist = historyData;
  String? _currentHistId;
  int _currentTab = 0;

  /// Getters

  bool get isLoading => _isLoading;

  List<Product> get checklist => _checklist;
  List<Product> get selectedChecklists => _selectedChecklists;
  bool get isAllSelected => _isAllSelected;
  String? get currentHistId => _currentHistId;

  Shop? get selectedShop => _selectedShop;
  List<Shop> get shops => _shops;
  List<Shop> get filteredShops => _filteredShops;
  List<String> get selectedShopFilter => _selectedShopFilter;
  Set<String> get shopLoacations => _shopLoacations;

  List<Map<String, dynamic>> get historylist => _historylist;

  int get currentTab => _currentTab;
  bool get checklistit => _checklistit;

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  bool _searchable = false;

  bool get searchable => _searchable;

  get fromDate => null;

  void changeShopFilter(String newFilter) {
    if (_selectedShopFilter.contains(newFilter)) {
      _selectedShopFilter.remove(newFilter);
    } else {
      _selectedShopFilter.add(newFilter);
    }
    notifyListeners();
  }

  void clearShopFilter() {
    _selectedShopFilter.clear();
    // notifyListeners();
  }

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void checklistrefersh({bool? value}) {
    _checklistit = value ?? !_checklistit;
    notifyListeners();
  }

  void changeTab(int newValue) {
    _currentTab = newValue;
    notifyListeners();
  }

  void changeSelectedShop(String shopId) {
    _selectedShop = _shops.firstWhere((element) => element.shopId == shopId);
    notifyListeners();
  }

  void changeCutterntHistId(String? newId) {
    _currentHistId = newId;
  }

  void deleteChecklistItem(String itemId) {
    _checklist.removeWhere((element) => element.itemId == itemId);
  }

  addToHistory(Map<String, dynamic> newData) {
    historylist.add(newData);
    notifyListeners();
    log('data add to historyList');
  }

  changeIsAllSelected(bool? newValue) {
    _isAllSelected = newValue ?? false;
    if (newValue == true) {
      _selectedChecklists.clear();
      _selectedChecklists.addAll(_checklist);
    } else {
      _selectedChecklists.clear();
    }
    notifyListeners();
  }

  void addProductToSelected(bool? value, Product product) {
    if (value == true) {
      _selectedChecklists.add(product);
    } else {
      _selectedChecklists.remove(product);
    }
    notifyListeners();
  }

  void clearSelectedProducts() {
    _selectedChecklists.clear();
    getChecklistItems();
    notifyListeners();
  }

  void filterShops() {
    _filteredShops.clear();
    if (_selectedShopFilter.isEmpty) {
      _filteredShops.addAll(_shops);
    } else {
      _filteredShops.addAll(
          _shops.where((e) => _selectedShopFilter.contains(e.shopLocation)));
    }

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
      // User canceled the file picker
    }
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      print('No file selected');
      return;
    }

    // Upload file with its filename as the key
    final platformFile = result.files.single;
    final path = platformFile.path!;
    final key = DateTime.now().toString() + platformFile.name;
    final file = File(path);

    imagekey = key;
    imagefile = File(path);
    uploadedFilePath = key;
    notifyListeners();
  }

  /// Checklist - APIs

  Future<void> getChecklistItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getChecklistItem();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _checklist.clear();
        _checklist.addAll((res.data as List).map((e) => Product.fromJson(e)));
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getChecklistItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putCheklistItems({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putChecklistItem(data: data, isEdit: isEdit);

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
    } catch (e) {
      debugPrint("Error while putCheklistItem: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putChecklistFromInventory({
    required List<String> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putChecklistFromInventory(itemIds: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        getChecklistItems();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while putCheklistItem: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putInventoryFromChecklist({
    required List<String> itemIds,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putInventoryFromchecklist(
          itemIds: itemIds, shopName: selectedShop!.shopName);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        changeCutterntHistId(res.data['hist_id']);
        for (String itemId in itemIds) {
          _checklist.removeWhere((element) => element.itemId == itemId);
        }
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while putCheklistItem: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteChecklistItems({
    required List<String> itemIds,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.deletChecklistItems(itemIds: itemIds);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        for (String itemId in itemIds) {
          deleteChecklistItem(itemId);
        }
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while deleteChecklistItems: $e");
    } finally {
      setLoading(false);
    }
  }

  /// Shops - APIs

  Future<void> getShops({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getShops();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _shops.clear();
        _shops.addAll((res.data as List).map((e) => Shop.fromJson(e)));
        filterShops();
        for (Shop shop in _shops) {
          _shopLoacations.add(shop.shopLocation ?? '');
        }
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getChecklistItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> putShops({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putShops(data: data, isEdit: isEdit);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        for (var shop in data) {
          _shopLoacations.add(shop['shop_location']);
        }
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while putShops: $e");
    } finally {
      setLoading(false);
    }
  }
}

final List<Map<String, dynamic>> checklistData = [
  {
    'image': AppAssets.apple,
    'title': 'Apple',
    'brand': 'Ice Berry',
    'inventoryLevel': InventoryType.high,
    'category': 'Fresh Fruits',
    'storage': 'Fridge Rack',
    'isInCart': true,
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
    'isInCart': true,
    'desc':
        'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
  },
  {
    'image': AppAssets.beetroot,
    'title': 'Beetroot',
    'brand': 'Alvera',
    'inventoryLevel': InventoryType.medium,
    'category': 'Fresh Vegetables',
    'storage': 'Fridge Rack',
    'isInCart': true,
    'desc':
        'Lorem Ipsum available, but the majority have \nsuffered alteration in some form. Lorem \nIpsum available, but the majority have suffered alteration'
  },
];

final List<Map<String, dynamic>> shopsData = [
  {
    'img': AppAssets.noImage,
    'title': 'Shop 1',
    'brand': 'Brand 1',
  },
  {
    'img': AppAssets.noImage,
    'title': 'Shop 2',
    'brand': 'Brand 2',
  },
  {
    'img': AppAssets.noImage,
    'title': 'Shop 3',
    'brand': 'Brand 3',
  },
];

final List<Map<String, dynamic>> historyData = [
  {
    'shop': 'Shop 1',
    'total': 300,
    'img': AppAssets.invoice,
    'products': 3,
    'isInvoice': true,
  },
];
