import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shopease_app_flutter/models/profile_model.dart';
import 'package:shopease_app_flutter/services/profile_service.dart';
import 'package:shopease_app_flutter/ui/widgets/toast_notification.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  final BaseProfileService services;

  ProfileProvider(this.services);

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
  bool _isLoading = false;
  ProfileData? _profileData;
  List<ProfileData> _groupProfiles = [];

  bool get set => _set;
  int _selectedUser = -1;

  int get selectedUserIndex => _selectedUser;
  bool get isLoading => _isLoading;
  ProfileData? get profileData => _profileData;
  List<ProfileData> get groupProfiles => _groupProfiles;

  void toggleSet(bool value) {
    _set = !set;
    notifyListeners();
  }

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void changeSelectedUser(int newUserIndex) {
    _selectedUser = newUserIndex;
    notifyListeners();
  }

  void deleteUser(String userId) {
    groupProfiles.removeWhere((element) => element.userId == userId);
    notifyListeners();
  }

  void clearGroupProfiles() {
    _groupProfiles.clear();
    notifyListeners();
  }

  void saveUser(ProfileData user) {
    groupProfiles.add(user);
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

  Future<void> getProfile({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.getProfile();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _profileData = ProfileData.fromJson((res.data as List).first);
        SharedPrefs().setUserId(_profileData?.userId ?? '');
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getProfile: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> getAllProfile({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.getAllProfile();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        _groupProfiles.clear();
        _groupProfiles.addAll(
          (res.data as List).map((e) => ProfileData.fromJson(e)),
        );
        SharedPrefs().setUserId(_profileData?.userId ?? '');
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e) {
      debugPrint("Error while getAllProfile: $e");
    } finally {
      setLoading(false);
    }
  }

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
}
