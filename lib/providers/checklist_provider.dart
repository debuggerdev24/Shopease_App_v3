import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/enums/inventory_type.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:toastification/toastification.dart';

class ChecklistProvider extends ChangeNotifier {
  final List<Map<String, String>> valueList = [
    {
      'name': 'Value 1',
    },
    {
      'name': 'Value 2',
    },
    {
      'name': 'Value 3',
    },
  ];
  bool _isLoading = false;
  final List<Map<String, dynamic>> _checklist = checklistData;
  final List<Map<String, dynamic>> _historylist = historyData;

  int _currentTab = 0;
  final List<Map<String, dynamic>> _shopsList = shopsData;

  int _selectedShop = -1;

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get checklist => _checklist;
  List<Map<String, dynamic>> get historylist => _historylist;

  int get currentTab => _currentTab;
  List<Map<String, dynamic>> get shops => _shopsList;
  int get selectedShopIndex => _selectedShop;

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  bool _set = false;
  int _selectedValue = -1;
  bool _searchable = false;

  bool get searchable => _searchable;

  String? _addCLSelectedCategory;
  String? _addCLSelectedInvType;
  XFile? _addCLSelectedFile;

  String? get addCLSelectedCategory => _addCLSelectedCategory;
  String? get addCLSelectedInvType => _addCLSelectedInvType;
  XFile? get addCLSelectedFile => _addCLSelectedFile;
  int get selectedValueIndex => _selectedValue;

  void toggleSearchable() {
    _searchable = !_searchable;
    notifyListeners();
  }

  void changeAddCLSelectedCategory(String? newValue) {
    _addCLSelectedCategory = newValue;
    notifyListeners();
  }

  void changeAddCLSelectedInvType(String? newValue) {
    _addCLSelectedInvType = newValue;
    notifyListeners();
  }

  Future<String?> selectFile() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return null;
    _addCLSelectedFile = file;
    notifyListeners();
    return file.name;
  }

  void clearFile() {
    _addCLSelectedFile = null;
    notifyListeners();
  }

  void changeLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeSelectedValue(int newIndex) {
    _selectedValue = newIndex;
    notifyListeners();
  }

  void changeTab(int newValue) {
    _currentTab = newValue;
    notifyListeners();
  }

  void changeSelectedShop(int newShopIndex) {
    _selectedShop = newShopIndex;
    notifyListeners();
  }

  void deleteProduct(String title) {
    _checklist.removeWhere((element) => element['title'] == title);
    notifyListeners();
  }

  addToHistory(Map<String, dynamic> newData) {
    historylist.add(newData);
    notifyListeners();
    log('data add to historyList');
  }

  addToShop(Map<String, dynamic> newData) {
    shops.add(newData);
    notifyListeners();
    log('data add to shop');
  }

  void deleteFromHistory(Map<String, dynamic> dataToDelete) {
    if (historylist.contains(dataToDelete)) {
      historylist.remove(dataToDelete);
      notifyListeners();
      log('Data deleted from historyList');
    } else {
      log('Item not found in historyList');
    }
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
