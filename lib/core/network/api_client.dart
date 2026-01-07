import 'dart:io';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/core/network/dio_provider.dart';
import 'package:riverpod_go_router_boilerplate/core/network/error_converter.dart';
import 'package:riverpod_go_router_boilerplate/core/result/result.dart';

part 'api_client.g.dart';

/// Provider for the default error converter.
@Riverpod(keepAlive: true)
ErrorConverter errorConverter(Ref ref) {
  return const DefaultErrorConverter();
}

/// Provider for the API client.
@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  return ApiClient(ref.watch(dioProvider), errorConverter: ref.watch(errorConverterProvider));
}

/// A type-safe API client wrapper around Dio.
/// All network calls return [Result] for consistent error handling.
///
/// The error handling is delegated to an [ErrorConverter], making it
/// easy to customize for different APIs (e.g., Stripe, Google Maps).
class ApiClient {
  ApiClient(this._dio, {ErrorConverter? errorConverter})
    : _errorConverter = errorConverter ?? const DefaultErrorConverter();

  final Dio _dio;
  final ErrorConverter _errorConverter;

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
  ///
  /// If [fromJson] is provided, it will be used to parse the response.
  /// If [fromJson] is null, the response data must be directly castable to [T].
  ///
  /// **Important:** For complex types like `List<User>`, always provide [fromJson].
  /// Direct casting will fail for generic collections due to Dart's type system.
  Future<Result<T>> _executeRequest<T>(
    Future<Response<dynamic>> Function() request, {
    T Function(dynamic json)? fromJson,
  }) async {
    try {
      final response = await request();

      if (fromJson != null) {
        return Success(fromJson(response.data));
      }

      // Safety check: Warn if trying to cast complex types without fromJson
      // This prevents runtime errors when T is a generic type like List<User>
      final data = response.data;
      if (data is! T) {
        // Type mismatch - provide helpful error message
        return Failure(
          UnexpectedException(
            message:
                'Type mismatch: Expected $T but got ${data.runtimeType}. '
                'For complex types, provide a fromJson parameter.',
            code: 'TYPE_MISMATCH',
          ),
        );
      }

      return Success(data);
    } on DioException catch (e, stackTrace) {
      return Failure(_errorConverter.convertDioException(e, stackTrace));
    } on SocketException catch (e, stackTrace) {
      return Failure(_errorConverter.convertSocketException(e, stackTrace));
    } catch (e, stackTrace) {
      return Failure(_errorConverter.convertUnknownError(e, stackTrace));
    }
  }
}
