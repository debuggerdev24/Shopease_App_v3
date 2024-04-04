import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/app_colors.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';
import 'package:shopease_app_flutter/utils/styles.dart';
import 'package:toastification/toastification.dart';

class ProfileProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> userList = [
    {
      'img': AppAssets.lucy,
      'name': 'Lucy',
      'admin': true,
      'phone': 123456789,
      'invite': false,
    },
    {
      'img': AppAssets.joe,
      'name': 'Joe',
      'admin': false,
      'phone': 123456789,
      'invite': false,
    },
    {
      'img': AppAssets.noImage,
      'name': 'Riya',
      'admin': false,
      'phone': 123456789,
      'invite': false,
    },
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  SharedPrefs sharedPrefs = SharedPrefs();

  String? imagekey;
  File? imagefile;
  String imageurl = '';
  String? uploadedFilePath;
  bool _set = false;
  String username = '';
  String phone = '';

  bool get set => _set;
  int _selectedUser = -1;
  String get _username => username;
  String get _phone => phone;

  int get selectedUserIndex => _selectedUser;

  void toggleSet(bool value) {
    _set = !set;
    notifyListeners();
  }

  void changeSelectedUser(int newUserIndex) {
    _selectedUser = newUserIndex;
    notifyListeners();
  }

  void deleteUser(String image) {
    userList.removeWhere((element) => element['img'] == image);
    notifyListeners();
  }

  void deleteUserList(List list) {
    list.clear();
    notifyListeners();
  }

  void saveUser(Map<String, dynamic> user) {
    userList.add(user);
    notifyListeners();
  }
List<Map<String, dynamic>> _uninvitedUsers = [];

List<Map<String, dynamic>> get uninvitedUsers => _uninvitedUsers;

void updateUninvitedUsers() {
  _uninvitedUsers =
      userList.where((user) => user['invite'] == false).toList();
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
