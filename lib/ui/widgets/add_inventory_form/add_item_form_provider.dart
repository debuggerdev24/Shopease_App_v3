import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddItemFormProvider extends ChangeNotifier {
  String? _selectedCategory;
  String _selectedInvType = 'low';
  XFile? _selectedFile;

  String? get selectedCategory => _selectedCategory;
  String? get selectedInvType => _selectedInvType;
  XFile? get selectedFile => _selectedFile;

  void changeSelectedCategory(String? newValue) {
    _selectedCategory = newValue;
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
}
