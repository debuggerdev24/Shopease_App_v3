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

  /// initializer
  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// TOKEN ///
  String? get token => _prefs.getString(_tokenKey);

  Future<bool> setToken(String token) => _prefs.setString(_tokenKey, token);

  Future<bool> removeToken() => _prefs.remove(_tokenKey);

  /// Theme ///
  String? get theme => _prefs.getString(_theme);

  setTheme(String theme) => _prefs.setString(_theme, theme);

  Future resetTheme() => _prefs.remove(_theme);

  String? get getsavedUsers => _prefs.getString("savedUsers");

  Future<bool> setSavedUsers(String savedUsers) =>
      _prefs.setString("savedUsers", savedUsers);
}
