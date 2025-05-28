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
  final String _sessionIdKey = "sessionIdKey";
  final String _accessTokenKey = "accessToken";
  final String _refreshTokenKey = "refreshToken";
  final String _idTokenKey = "idTokenKey";
  final String _locationIdKey = 'locationId';
  final String _userIdKey = 'userId';
  final String _phoneKey = "phone";
  final String _userNameKey = "name";
  final String _theme = 'theme';

  /// initializer
  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  clear() async => await _prefs.clear();

  /// SESSION ID ///
  String? get sessionId => _prefs.getString(_sessionIdKey);

  Future<bool> setSessionId(String sessionId) =>
      _prefs.setString(_sessionIdKey, sessionId);

  Future<void> removeSessionId() async => await _prefs.remove(_sessionIdKey);

  /// ACCESS TOKEN ///
  String? get accessToken => _prefs.getString(_accessTokenKey);

  Future<bool> setAccessToken(String sessionId) =>
      _prefs.setString(_accessTokenKey, sessionId);

  Future<void> removeAccessToken() async =>
      await _prefs.remove(_accessTokenKey);

  /// REFRESH TOKEN ///
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  Future<bool> setRefreshToken(String sessionId) =>
      _prefs.setString(_refreshTokenKey, sessionId);

  Future<void> removeRefreshToken() async =>
      await _prefs.remove(_refreshTokenKey);

  /// ID TOKEN ///
  String? get idToken => _prefs.getString(_idTokenKey);

  Future<bool> setIdToken(String sessionId) =>
      _prefs.setString(_idTokenKey, sessionId);

  Future<void> removeIdToken() async => await _prefs.remove(_idTokenKey);

  /// LOCATION ID ///
  String? get locationId => _prefs.getString(_locationIdKey);

  Future<bool> setLocationId(String sessionId) =>
      _prefs.setString(_locationIdKey, sessionId);

  Future<void> removeLocationId() async => await _prefs.remove(_locationIdKey);

  /// USER ID ///
  String? get userId => _prefs.getString(_userIdKey);

  Future<bool> setUserId(String sessionId) =>
      _prefs.setString(_userIdKey, sessionId);

  Future<void> removeUserId() async => await _prefs.remove(_userIdKey);

  /// PHONE ///
  String? get phone => _prefs.getString(_phoneKey);

  Future<bool> setPhone(String phone) => _prefs.setString(_phoneKey, phone);

  Future<void> removePhone() async => await _prefs.remove(_phoneKey);

  /// NAME ///
  String? get userName => _prefs.getString(_userNameKey);

  Future<bool> setUserName(String userName) =>
      _prefs.setString(_userNameKey, userName);
  Future<void> removeUserName() async => await _prefs.remove(_userNameKey);

  /// Theme ///
  String? get theme => _prefs.getString(_theme);

  Future<bool> setTheme(String theme) => _prefs.setString(_theme, theme);

  Future<void> removeTheme() async => await _prefs.remove(_theme);
}
