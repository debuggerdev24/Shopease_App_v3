import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/models/history_model.dart';
import 'package:shopease_app_flutter/services/history_service.dart';
import 'package:shopease_app_flutter/utils/constants.dart';

class HistoryProvider extends ChangeNotifier {
  final BaseHistoryService service;

  HistoryProvider(this.service);

  bool _isLoading = false;
  final List<History> _histories = [];
  final List<History> _filteredHistories = [];
  List<int> _selectedFilterMonth = [];
  int _selectedValue = -1;
  XFile? _selectedFile;

  bool get isLoading => _isLoading;
  List<History> get histories => _histories;
  List<History> get filteredHistories => _filteredHistories;
  List<int> get selectedFilterMonth => _selectedFilterMonth;
  int get selectedValueIndex => _selectedValue;
  XFile? get selectedFile => _selectedFile;

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void deleteHistory(String itemId) {
    _histories.removeWhere((element) => element.histId == itemId);
    notifyListeners();
  }

  void changeSelectedValue(int newIndex) {
    _selectedValue = newIndex;
    notifyListeners();
  }

  void changeHistoryFilter(int month) {
    if (_selectedFilterMonth.contains(month)) {
      _selectedFilterMonth.remove(month);
    } else {
      _selectedFilterMonth.add(month);
    }
    notifyListeners();
  }

  void clearHistoryFilters() {
    _selectedFilterMonth.clear();
    notifyListeners();
  }

  void filterHistories() {
    _filteredHistories.clear();
    if (_selectedFilterMonth.isEmpty) {
      _filteredHistories.addAll(_histories);
    } else {
      _filteredHistories.addAll(
        _histories.where(
          (element) =>
              _selectedFilterMonth.contains(element.updatedDate?.month),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> selectFileFromGallery({VoidCallback? onSuccess}) async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    _selectedFile = file;
    notifyListeners();
    onSuccess?.call();
  }

  Future<void> selectFileFromCamera({VoidCallback? onSuccess}) async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    if (file == null) return;
    _selectedFile = file;
    notifyListeners();
    onSuccess?.call();
  }

  Future<void> getHistoryItems({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.getHistoryItems();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _histories.clear();
        _histories.addAll((res.data as List).map((e) => History.fromJson(e)));
        filterHistories();
        notifyListeners();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getHistoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> puthistoryItems({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await service.putHistoryItems(data: data, isEdit: isEdit);

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
      debugPrint("Error while puthistoryItems: $e");
    } finally {
      setLoading(false);
    }
  }

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
}
