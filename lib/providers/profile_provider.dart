import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopease_app_flutter/Models/invitation_model.dart';
import 'package:shopease_app_flutter/models/profile_model.dart';
import 'package:shopease_app_flutter/services/profile_service.dart';
import 'package:shopease_app_flutter/utils/app_assets.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

class ProfileProvider extends ChangeNotifier {
  final BaseProfileService services;

  ProfileProvider(this.services);

  bool _set = false;
  bool _support = false;
  bool _isLoading = false;
  bool _editProfileLoading = false;
  ProfileData? _profileData;
  XFile? _selectedFile;
  List<ProfileData> _groupProfiles = [];
  List<Inviteduser> _userInvitation = [];

  bool get set => _set;
  int _selectedUser = -1;

  int get selectedUserIndex => _selectedUser;
  bool get isLoading => _isLoading;
  bool get support => _support;
  bool get editProfileLoading => _editProfileLoading;
  ProfileData? get profileData => _profileData;
  List<ProfileData> get groupProfiles => _groupProfiles;
  XFile? get selectedFile => _selectedFile;
  List<Inviteduser> get inviteduser => _userInvitation;

  void toggleSet(bool value) {
    _set = !set;
    notifyListeners();
  }

  void setLoading(bool newValue) {
    _isLoading = newValue;
    notifyListeners();
  }

  void setEditProfileLoading(bool newValue) {
    _editProfileLoading = newValue;
    notifyListeners();
  }

  void _toggleSubtitleVisibility() {
    _support = !_support;
    notifyListeners();
  }

  void changeSelectedUser(int newUserIndex) {
    if (_selectedUser == newUserIndex) {
      _selectedUser = -1;
      notifyListeners();
      return;
    }
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

  void settingInviteduser(List<Inviteduser> value) {
    _userInvitation = value;
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

  List<Map<String, dynamic>> _uninvitedUsers = [];

  List<Map<String, dynamic>> get uninvitedUsers => _uninvitedUsers;

  void updateUninvitedUsers() {
    _uninvitedUsers =
        userList.where((user) => user['invite'] == false).toList();
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
        _groupProfiles.removeWhere((e) => e.userId == profileData?.userId);
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

  Future<void> editProfile({
    required List<Map<String, dynamic>> data,
    required bool isEdit,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setEditProfileLoading(true);
      final res = await services.editMyProfile(data: data, isEdit: isEdit);

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
      debugPrint("Error while editProfile: $e");
      debugPrint("Error while editProfile: $s");
    } finally {
      setEditProfileLoading(false);
    }
  }

  Future<void> inviteUserToGroup({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.inviteUser(data: data);

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        getAllProfile();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> removeUserFromGroup({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.removeUserFromGroup(data: data);

      if (res == null) {
        _groupProfiles.removeWhere((e) => e.userId = data['user_id']);
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        getAllProfile();
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> getinvitesbyuser({
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.getinvitesbyuser();

      if (res == null) {
        onError?.call(Constants.tokenExpiredMessage);
        return;
      }

      if (res.statusCode == 200) {
        print("0res.data ========== ${res}");
        settingInviteduser(inviteduserFromJson(res.data));
        onSuccess?.call();
      } else {
        onError?.call(res.data["message"] ?? Constants.commonErrMsg);
      }
    } on DioException {
      rethrow;
    } catch (e, s) {
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> acceptinvite({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.acceptinvite(data: data);

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
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> cancelinvite({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.cancelinvite(data: data);

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
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
    } finally {
      setLoading(false);
    }
  }

  Future<void> rejectinvite({
    required Map<String, dynamic> data,
    Function(String)? onError,
    VoidCallback? onSuccess,
  }) async {
    try {
      setLoading(true);
      final res = await services.rejectinvite(data: data);

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
      debugPrint("Error while inviteUserToGroup: $e");
      debugPrint("Error while inviteUserToGroup: $s");
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
