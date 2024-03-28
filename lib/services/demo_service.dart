import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseDemoService {
  Future<dynamic> demoRequest({required dynamic data});
}

class DemoService implements BaseDemoService {
  final _api = BaseRepository.instance.dio;

  DemoService._();

  static final DemoService _instance = DemoService._();

  factory DemoService() => _instance;

  @override
  Future demoRequest({required dynamic data}) async {
    final res = await _api.post('/auth/signUp', data: data);
    return res.data;
  }
}
