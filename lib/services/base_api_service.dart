import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

// import '../utils/shared_prefs.dart';

class BaseRepository {
  BaseRepository._();
  static final _instance = BaseRepository._();
  static const baseUrl =
      "https://devapi.shopeaseapp.com"; // https://api.shopeaseapp.com

  // static const socketUrl = "http://3.105.32.43.com";
  Dio get dio => _dio;
  late final Dio _dio;

  static BaseRepository get instance => _instance;

  intialize() {
    if (SharedPrefs().idToken != null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": "VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0",
            "Authorization": "${SharedPrefs().idToken}"
          },
        ),
      );
    } else {
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          headers: {
            "x-api-key": "VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0",
          },
        ),
      );
    }

    _dio.interceptors.add(
      PrettyDioLogger(request: true, requestBody: true, requestHeader: true),
    );
  }

  void addToken(String idToken) {
    _dio.options =
        _dio.options.copyWith(headers: {'Authorization': "Bearer $idToken"});
  }
}
