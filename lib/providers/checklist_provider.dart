import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/models/product_model.dart';
import 'package:shopease_app_flutter/models/shop_model.dart';
import 'package:shopease_app_flutter/services/checklist_service.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/utils.dart';

class ChecklistProvider extends ChangeNotifier {
  final BaseChecklistService service;

  ChecklistProvider(this.service);

  /// Values

  bool _isLoading = false;
  final List<Product> _checklist = [];
  final List<Product> _filteredChecklist = [];
  final List<String> _selectedCategoryFilters = [];
  String? _selectedItemFilter;

  final List<Product> _selectedChecklists = [];
  bool _isAllSelected = false;
  bool _selectValue = false;
  bool _shopvalue = false;

  Shop? _selectedShop;
  final Set<Shop> _shops = {};
  final List<Shop> _filteredShops = [];
  final List<String> _selectedShopFilter = [];
  final Set<String> _shopLoacations = <String>{};

  final List<Map<String, dynamic>> _historylist = historyData;
  String? _currentHistId;
  int _currentTab = 0;

  /// Getters

  bool get isLoading => _isLoading;

  List<Product> get checklist => _checklist;
  List<Product> get filteredChecklist => _filteredChecklist;
  int get selectedItemsCount =>
      _filteredChecklist.where((e) => e.isSelectedForComplete).length;
  List<String> get selectedCategoryFilters => _selectedCategoryFilters;
  String? get selectedItemFilter => _selectedItemFilter;

  List<Product> get selectedChecklists => _selectedChecklists;
  bool get isAllSelected => _isAllSelected;
  String? get currentHistId => _currentHistId;

  Shop? get selectedShop => _selectedShop;
  Set<Shop> get shops => _shops;
  List<Shop> get filteredShops => _filteredShops;
  List<String> get selectedShopFilter => _selectedShopFilter;
  Set<String> get shopLoacations => _shopLoacations;
  bool get selectValue => _selectValue;
  bool get shopvalue => _shopvalue;

  List<Map<String, dynamic>> get historylist => _historylist;

  int get currentTab => _currentTab;

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  bool _searchable = false;

  bool get searchable => _searchable;

  get fromDate => null;

  void changeFilterCategoty(String categoryId) {
    if (_selectedCategoryFilters.contains(categoryId)) {
      _selectedCategoryFilters.remove(categoryId);
    } else {
      _selectedCategoryFilters.add(categoryId);
    }
    notifyListeners();
  }

  void changeFilterItem(String? level) {
    if (_selectedItemFilter == level) {
      _selectedItemFilter = null;
    } else {
      _selectedItemFilter = level;
    }
    notifyListeners();
  }

  void changeShopFilter(String newFilter) {
    if (_selectedShopFilter.contains(newFilter)) {
      _selectedShopFilter.remove(newFilter);
    } else {
      _selectedShopFilter.add(newFilter);
    }

    notifyListeners();
  }

  void clearChecklistFilter() {
    _selectedCategoryFilters.clear();
    _selectedItemFilter = null;
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
    _filteredChecklist.removeWhere((element) => element.itemId == itemId);
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

  void addToSelected(bool? value, Product product) {
    log('product value: ${product.isSelectedForComplete}');
    log('tapped value: $value');
    log('product value - after change: ${product.isSelectedForComplete}');
    product.changeSelectedState(value ?? false);
    if (value == true) {
      _filteredChecklist.add(product);
      // _selectedChecklists.add(product);
      _filteredChecklist.remove(product);
    } else {
      _filteredChecklist.remove(product);
      // _selectedChecklists.remove(product);
      _filteredChecklist.insert(0, product);
    }
    _selectValue = true;
    notifyListeners();
  }

  void filterChecklist({bool clearselected = true}) {
    _filteredChecklist.clear();
    if (clearselected) _selectedChecklists.clear();

    if (_selectedCategoryFilters.isEmpty && _selectedItemFilter == null) {
      _filteredChecklist.addAll(_checklist);

      notifyListeners();
      _selectValue = false;
      return;
    }

    if (_selectedCategoryFilters.isEmpty) {
      if (_selectedItemFilter == 'selected') {
        _filteredChecklist.addAll(
          _checklist.where(
            (element) => element.isSelectedForComplete,
          ),
        );
      } else {
        _filteredChecklist.addAll(
          _checklist.where(
            (element) => !element.isSelectedForComplete,
          ),
        );
      }
      _selectValue = true;
      notifyListeners();
      return;
    }

    if (_selectedItemFilter == null) {
      _filteredChecklist.addAll(
        _checklist.where(
          (product) => _selectedCategoryFilters.contains(Utils.categories
              .firstWhere(
                  (category) => category.categoryName == product.itemCategory)
              .categoryId),
        ),
      );
      _selectValue = true;
      notifyListeners();

      return;
    }
    _filteredChecklist.addAll(
      _checklist.where(
        (product) =>
            (_selectedItemFilter == 'selected'
                ? product.isSelectedForComplete
                : !product.isSelectedForComplete) &&
            _selectedCategoryFilters.contains(Utils.categories
                .firstWhere(
                    (category) => category.categoryName == product.itemCategory)
                .categoryId),
      ),
    );
    _selectValue = true;
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
      _shopvalue = false;
    } else {
      _filteredShops.addAll(
          _shops.where((e) => _selectedShopFilter.contains(e.shopLocation)));
      _shopvalue = true;
    }

    notifyListeners();
  }

  /// Checklist - APIs
  Future<void> changeInStockQuantity(String itemId, String quantity) async {
    final product = _checklist.firstWhere((e) => e.itemId == itemId);
    product.changeQuantity(quantity);
    await putCheklistItems(
      data: [product.toJson()],
      isEdit: true,
    );
  }

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
        _checklist.addAll((res.data as List)
            .map((e) => Product.fromJson(e)..isInChecklist = true));
        _checklist.sort(
          (a, b) =>
              b.updatedDate?.compareTo(a.updatedDate ?? DateTime(0)) ?? -1,
        );
        filterChecklist(clearselected: false);
        for (Product product in _checklist) {
          if (product.isSelectedForComplete) {
            _filteredChecklist.remove(product);
            _filteredChecklist.add(product);
          }
        }
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while getChecklistItems: $e");
      debugPrint("Error while getChecklistItems: $s");
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
    } catch (e, s) {
      debugPrint("Error while putShops: $e");
      debugPrint("Error while putShops: $s");
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
