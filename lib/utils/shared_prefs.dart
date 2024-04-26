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

  /// SESSION ID ///
  String? get sessionId => _prefs.getString(_sessionIdKey);

  Future<bool> setSessionId(String sessionId) =>
      _prefs.setString(_sessionIdKey, sessionId);

  /// ACCESS TOKEN ///
  String? get accessToken => _prefs.getString(_accessTokenKey);

  Future<bool> setAccessToken(String sessionId) =>
      _prefs.setString(_accessTokenKey, sessionId);

  /// REFRESH TOKEN ///
  String? get refreshToken => _prefs.getString(_refreshTokenKey);

  Future<bool> setRefreshToken(String sessionId) =>
      _prefs.setString(_refreshTokenKey, sessionId);

  /// ID TOKEN ///
  String? get idToken => _prefs.getString(_idTokenKey);

  Future<bool> setIdToken(String sessionId) =>
      _prefs.setString(_idTokenKey, sessionId);

  /// LOCATION ID ///
  String? get locationId => _prefs.getString(_locationIdKey);

  Future<bool> setLocationId(String sessionId) =>
      _prefs.setString(_locationIdKey, sessionId);

  /// USER ID ///
  String? get userId => _prefs.getString(_userIdKey);

  Future<bool> setUserId(String sessionId) =>
      _prefs.setString(_userIdKey, sessionId);

  /// PHONE ///
  Future<bool> setPhone(String phone) => _prefs.setString(_phoneKey, phone);

  String? get phone => _prefs.getString(_phoneKey);

  /// NAME ///
  Future<bool> setUserName(String userName) =>
      _prefs.setString(_userNameKey, userName);

  String? get userName => _prefs.getString(_userNameKey);

  /// Theme ///
  String? get theme => _prefs.getString(_theme);

  setTheme(String theme) => _prefs.setString(_theme, theme);
}
