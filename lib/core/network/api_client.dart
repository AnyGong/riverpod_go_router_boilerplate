import 'package:dio/dio.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Future<Response> get(String path) => _dio.get(path);
}
