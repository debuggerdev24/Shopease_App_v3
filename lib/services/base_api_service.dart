import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shopease_app_flutter/services/api_url.dart';
import 'package:shopease_app_flutter/utils/constants.dart';
import 'package:shopease_app_flutter/utils/shared_prefs.dart';

// import '../utils/shared_prefs.dart';

class BaseRepository {
  BaseRepository._();

  static final _instance = BaseRepository._();

  factory BaseRepository() => _instance;

  late final Dio _dio;

  Dio get dio => _dio;

  intialize() {
    if (SharedPrefs().idToken != null) {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrl.prodBaseURL,
          headers: {
            "Content-Type": "application/json",
            "x-api-key": Constants.prodApiKey,
            "Authorization": "${SharedPrefs().idToken}"
          },
        ),
      );
    } else {
      _dio = Dio(
        BaseOptions(
          baseUrl: ApiUrl.prodBaseURL,
          headers: {
            "x-api-key": Constants.prodApiKey,
          },
        ),
      );
    }
    log('dio headers: ${_dio.options.headers}');
    _dio.interceptors.add(
      PrettyDioLogger(requestBody: true, requestHeader: true),
    );
  }

  void addToken(String idToken) {
    _dio.options = _dio.options.copyWith(headers: {
      'Authorization': idToken,
      'x-api-key': Constants.prodApiKey,
    });
  }

  void removeToken() {
    _dio.options.headers.remove('Authorization');
  }

  Future<Response<dynamic>?> get(String path, {dynamic data}) async {
    try {
      final res = await _dio.get(path, data: data);
      if (res.statusCode == 200) {
        return res;
      }
    } on DioException catch (e) {
      log("Error while caaling GET : $path - $e");
      if (e.response?.statusCode == 401) {
        final refreshRes = await _dio.get(ApiUrl.refreshAuth, data: {
          'refresh_token': SharedPrefs().refreshToken,
        });

        if (refreshRes.statusCode == 200) {
          SharedPrefs().setAccessToken(refreshRes.data['AccessToken']);
          SharedPrefs().setIdToken(refreshRes.data['IdToken']);
          addToken(refreshRes.data['IdToken']);
          return get(path, data: data);
        }
      }

      return e.response;
    }

    return null;
  }

  Future<Response<dynamic>?> post(String path,
      {Map<String, dynamic>? data}) async {
    try {
      log("${_dio.options.headers}");
      final res = await _dio.post(path, data: data);
      if (res.statusCode == 200) {
        return res;
      }
    } on DioException catch (e) {
      log("Error while caaling POST : $path - $e");
      if (e.response?.statusCode == 401) {
        final refreshRes = await _dio.post(ApiUrl.refreshAuth, data: {
          'refresh_token': SharedPrefs().refreshToken,
        });

        if (refreshRes.statusCode == 200) {
          SharedPrefs().setAccessToken(refreshRes.data['AccessToken']);
          SharedPrefs().setIdToken(refreshRes.data['IdToken']);
          addToken(refreshRes.data['IdToken']);
          return get(path, data: data);
        }
      }

      return e.response;
    }

    return null;
  }

  Future<Response<dynamic>?> put(String path, {dynamic data}) async {
    try {
      final res = await _dio.put(path, data: data);
      if (res.statusCode == 200) {
        return res;
      }
    } on DioException catch (e) {
      log("Error while caaling PUT : $path - $e");
      if (e.response?.statusCode == 401) {
        final refreshRes = await _dio.get(ApiUrl.refreshAuth, data: {
          'refresh_token': SharedPrefs().refreshToken,
        });

        if (refreshRes.statusCode == 200) {
          SharedPrefs().setAccessToken(refreshRes.data['AccessToken']);
          SharedPrefs().setIdToken(refreshRes.data['IdToken']);
          addToken(refreshRes.data['IdToken']);
          return get(path, data: data);
        }
        log("-------------------> AK Log : ${refreshRes.statusCode}");
      }

      return e.response;
    }
  }

  Future<Response<dynamic>?> delete(String path, {dynamic data}) async {
    try {
      final res = await _dio.delete(path, data: data);
      if (res.statusCode == 200) {
        return res;
      }
    } on DioException catch (e) {
      log("Error while caaling DELETE : $path - $e");
      if (e.response?.statusCode == 401) {
        final refreshRes = await _dio.get(ApiUrl.refreshAuth, data: {
          'refresh_token': SharedPrefs().refreshToken,
        });

        if (refreshRes.statusCode == 200) {
          SharedPrefs().setAccessToken(refreshRes.data['AccessToken']);
          SharedPrefs().setIdToken(refreshRes.data['IdToken']);
          addToken(refreshRes.data['IdToken']);
          return get(path, data: data);
        }
      }

      return e.response;
    }

    return null;
  }
}
