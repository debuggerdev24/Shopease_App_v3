import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// import '../utils/shared_prefs.dart';

class BaseRepository {
  BaseRepository._();
  static final _instance = BaseRepository._();
  static const baseUrl = "https://devapi.shopeaseapp.com";

  // static const socketUrl = "http://3.105.32.43.com";
  Dio get dio => _dio;
  late final Dio _dio;

  static BaseRepository get instance => _instance;

  intialize() {
    // if (SharedPrefs().token != null) {
    //   _dio = Dio(BaseOptions(baseUrl: baseUrl, headers: {
    //     "Content-Type": "application/json",
    //     "x-api-key": "VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0"

    //     // 'Authorization': "Bearer ${SharedPrefs().token}"
    //   }));
    // } else {
    _dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: {"x-api-key": "VJRwQuymlVlkmxsiipmVtCTtFX5H2B7aapyk3kf0"}));

    _dio.interceptors.add(
        PrettyDioLogger(request: true, requestBody: true, requestHeader: true));
  }

  // addToken(String token) {
  //   _dio.options =
  //       _dio.options.copyWith(headers: {'Authorization': "Bearer $token"});
  // }
}
