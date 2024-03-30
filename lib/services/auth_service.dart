import 'package:dio/dio.dart';
import 'package:shopease_app_flutter/services/base_api_service.dart';

abstract class BaseAuthService {}

class AuthService implements BaseAuthService {
  final _api = BaseRepository.instance.dio;
  AuthService._();
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;
}
