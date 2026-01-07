import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:native_dio_adapter/native_dio_adapter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_go_router_boilerplate/config/env_config.dart';
import 'package:riverpod_go_router_boilerplate/core/storage/secure_storage.dart';
import 'package:riverpod_go_router_boilerplate/core/utils/logger.dart';

part 'dio_provider.g.dart';

/// Provider for the Dio HTTP client.
///
/// Uses native platform adapters for optimal performance:
/// - Android: Cronet (HTTP/3, QUIC, Brotli compression)
/// - iOS/macOS: NSURLSession (HTTP/3, system proxy support)
///
/// keepAlive: true ensures Dio instance is not disposed when no longer watched.
@Riverpod(keepAlive: true)
Dio dio(final Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Use native HTTP adapter for better performance (HTTP/3, Brotli, system proxy)
  // Only in release mode to preserve debugging capabilities in development
  if (kReleaseMode) {
    dio.httpClientAdapter = NativeAdapter();
  }

  // Add interceptors in order
  dio.interceptors.addAll([
    AuthInterceptor(ref),
    RetryInterceptor(dio),
    if (EnvConfig.enableLogging) LoggingInterceptor(ref),
  ]);

  return dio;
}

/// Interceptor for adding authentication headers and handling token refresh.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._ref);
  final Ref _ref;

  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshed = await _refreshToken();
        if (refreshed) {
          // Retry the original request with new token
          final response = await _retryRequest(err.requestOptions);
          _isRefreshing = false;
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed - clear tokens and let error propagate
        await _clearTokens();
      }

      _isRefreshing = false;
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    final storage = _ref.read(secureStorageProvider);
    final refreshToken = await storage.read(key: StorageKeys.refreshToken);

    if (refreshToken == null) return false;

    try {
      // TODO: Implement actual refresh token API call
      // final response = await Dio().post(
      //   '${EnvConfig.baseUrl}/auth/refresh',
      //   data: {'refresh_token': refreshToken},
      // );
      // await storage.write(key: StorageKeys.accessToken, value: response.data['access_token']);
      // await storage.write(key: StorageKeys.refreshToken, value: response.data['refresh_token']);
      return false; // Mock: refresh not implemented
    } catch (e) {
      return false;
    }
  }

  Future<Response<dynamic>> _retryRequest(final RequestOptions options) async {
    final storage = _ref.read(secureStorageProvider);
    final token = await storage.read(key: StorageKeys.accessToken);
    options.headers['Authorization'] = 'Bearer $token';
    return Dio().fetch(options);
  }

  Future<void> _clearTokens() async {
    final storage = _ref.read(secureStorageProvider);
    await storage.delete(key: StorageKeys.accessToken);
    await storage.delete(key: StorageKeys.refreshToken);
  }
}

/// Interceptor for retrying failed requests.
class RetryInterceptor extends Interceptor {
  RetryInterceptor(this._dio, {this.maxRetries = 3, this.retryDelays});

  final Dio _dio;
  final int maxRetries;
  final List<Duration>? retryDelays;

  static const _retryKey = 'retry_count';

  List<Duration> get _delays =>
      retryDelays ??
      const [Duration(seconds: 1), Duration(seconds: 2), Duration(seconds: 4)];

  @override
  Future<void> onError(
    final DioException err,
    final ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    if (!shouldRetry) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra[_retryKey] as int? ?? 0;
    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Wait before retrying
    final delay = _delays[retryCount.clamp(0, _delays.length - 1)];
    await Future<void>.delayed(delay);

    // Retry the request
    try {
      err.requestOptions.extra[_retryKey] = retryCount + 1;
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(final DioException err) {
    // Only retry on network errors or 5xx server errors
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }
}

/// Interceptor for logging requests and responses.
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._ref);
  final Ref _ref;

  AppLogger get _logger => _ref.read(loggerProvider);

  @override
  void onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      _logger.d('→ ${options.method} ${options.uri}');
      if (options.data != null) {
        _logger.d('   Body: ${options.data}');
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(
    final Response<dynamic> response,
    final ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      _logger.d('← ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.e(
        '✖ ${err.response?.statusCode ?? 'NETWORK'} ${err.requestOptions.uri}',
        error: err.message,
      );
    }
    handler.next(err);
  }
}
