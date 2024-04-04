import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs._();

  /// private instance
  static final _instance = SharedPrefs._();

  /// singleton constructor
  factory SharedPrefs() => _instance;

  /// private SharedPreferences instance
  late final SharedPreferences _prefs;

  /// Keys
  final String _tokenKey = "token";
  final String _theme = 'theme';
  final String _phone = "phone";
  final String _userName = "name";


  /// initializer
  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// TOKEN ///
  String? get token => _prefs.getString(_tokenKey);

  Future<bool> setToken(String token) => _prefs.setString(_tokenKey, token);

  Future<bool> setPhone(String phone) => _prefs.setString(_phone, phone);

  Future<bool> setUserName(String userName) => _prefs.setString(_userName, userName);


  Future<bool> removeToken() => _prefs.remove(_tokenKey);

  /// Theme ///
  String? get theme => _prefs.getString(_theme);

  String? get phone => _prefs.getString(_phone);

  String? get userName => _prefs.getString(_userName);

  setTheme(String theme) => _prefs.setString(_theme, theme);

  Future resetTheme() => _prefs.remove(_theme);

  String? get getsavedUsers => _prefs.getString("savedUsers");

  Future<bool> setSavedUsers(String savedUsers) =>
      _prefs.setString("savedUsers", savedUsers);
}
