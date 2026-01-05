import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/network/dio_provider.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

/// Provider for the API client.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(dioProvider));
});

/// A type-safe API client wrapper around Dio.
/// All network calls return [Result] for consistent error handling.
class ApiClient {
  ApiClient(this._dio);
  final Dio _dio;

  /// Perform a GET request.
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    return _executeRequest(
      () => _dio.get<dynamic>(path, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  /// Perform a POST request.
  Future<Result<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    return _executeRequest(
      () => _dio.post<dynamic>(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  /// Perform a PUT request.
  Future<Result<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    return _executeRequest(
      () => _dio.put<dynamic>(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  /// Perform a PATCH request.
  Future<Result<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    return _executeRequest(
      () => _dio.patch<dynamic>(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  /// Perform a DELETE request.
  Future<Result<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic json)? fromJson,
  }) async {
    return _executeRequest(
      () => _dio.delete<dynamic>(path, data: data, queryParameters: queryParameters),
      fromJson: fromJson,
    );
  }

  /// Execute a request and convert to Result.
  Future<Result<T>> _executeRequest<T>(
    Future<Response<dynamic>> Function() request, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await request();

      if (fromJson != null) {
        return Success(fromJson(response.data));
      }

      return Success(response.data as T);
    } on DioException catch (e, stackTrace) {
      return Failure(_mapDioException(e, stackTrace));
    } on SocketException catch (_, stackTrace) {
      return Failure(
        NetworkException(
          message: 'No internet connection',
          code: 'NO_CONNECTION',
          stackTrace: stackTrace,
        ),
      );
    } catch (e, stackTrace) {
      return Failure(
        UnexpectedException(
          message: 'An unexpected error occurred',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  /// Map Dio exceptions to our custom exceptions.
  NetworkException _mapDioException(DioException e, StackTrace stackTrace) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => NetworkException.timeout(),
      DioExceptionType.connectionError => NetworkException.noConnection(),
      DioExceptionType.badResponse => _mapStatusCode(
        e.response?.statusCode,
        e.response?.data,
        stackTrace,
      ),
      _ => NetworkException(message: e.message ?? 'Network error occurred', stackTrace: stackTrace),
    };
  }

  /// Map HTTP status codes to exceptions.
  NetworkException _mapStatusCode(int? statusCode, dynamic data, StackTrace stackTrace) {
    final message = _extractErrorMessage(data);

    if (statusCode == 401) {
      return NetworkException.unauthorized();
    }

    if (statusCode != null && statusCode >= 500) {
      return NetworkException.serverError(statusCode);
    }

    return NetworkException(
      message: message ?? 'Request failed',
      statusCode: statusCode,
      stackTrace: stackTrace,
    );
  }

  /// Extract error message from response data.
  String? _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String? ?? data['errors']?.toString();
    }
    return null;
  }
}
