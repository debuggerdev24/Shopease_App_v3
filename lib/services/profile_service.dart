import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/api_url.dart';

import 'base_api_service.dart';

abstract class BaseProfileService {
  Future<Response<dynamic>?> getProfile();
}

class ProfileService implements BaseProfileService {
  @override
  Future<Response?> getProfile() async {
    return await BaseRepository().post(ApiUrl.getProfile);
  }
}
