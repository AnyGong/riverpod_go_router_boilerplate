import 'package:dio/dio.dart';

class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  Future<Response<T>> get<T>(String path) {
    return _dio.get<T>(path);
  }

  Future<Response<T>> post<T>(String path, {Object? data}) {
    return _dio.post<T>(path, data: data);
  }
}
